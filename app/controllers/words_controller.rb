class WordsController < ApplicationController
  before_action :set_words # keeps the last 5 words in memory


  def index

    # get error message returned from last request
    @error = session[:error]
    # clear out error
    session[:error] = nil
  end

  def log_error(error, params = nil, responseParams = nil)
    open('log.txt', 'a') do |f|
      f << "#{error} | #{params} | #{responseParams} | #{DateTime.now}\n"
    end
  end

  # checks if text entered is valid
  def validate_entry(text)
    is_valid = true
    if text.blank?
      session[:error] = 'Please enter a word before searching'
      log_error('Blank word submitted')
      is_valid = false
    end
    unless text.match('^[A-Za-z]*$')
      session[:error] = 'Please enter a word without numbers, special characters, or spaces'
      log_error('Invalid characters submitted',text)
      is_valid = false
    end
    is_valid

  end

  def define
    # get word data from Oxford API
    word_data = find_word(params[:word])

    # word_data will be nil if an error occured
    unless word_data.nil?
      # create word object from raw data
      word = get_word_from_data(word_data)
      # add word to persistent word array
      @words.push(word)
      session[:words] = @words
      # clear out any errors
      session[:error] = nil
    end
    redirect_to action: 'index'




  end

  #returns object with word and its definition
  def get_word_from_data(word_data)
    name = word_data['id']
    definition = word_data['results'][0]['lexicalEntries'][0]['entries'][0]['senses'][0]['definitions'][0]
    { name: name, definition: definition }
  end

  # takes in a url and uses Excon with API credentials to fetch from Oxford Dictionary
  def request_api(url)
    response = Excon.get(
        url,
        headers: {
            'app_id' => 'bba16219',
            'app_key' => '50c00bf7a76d9662ac42b784fccfb234'
        }
    )
    # if response is no good
    if response.status != 200
      session[:error] = determine_error_message(response, url)
      return nil
    end

    # parse response if it is good
    JSON.parse(response.body)
  end

  # set error message based on status code returned from server
  def determine_error_message(response, url)
    case response.status
    when 404
      error = 'Word not found'
    when 400
      error = 'Bad request, please try again'
    when 403
      error = 'Invalid credentials. Please check your Oxford Dictionary account'
    when 414
      error = 'Word exceeds character limit. Please try another word'
    when 500, 502, 503, 504
      error = 'Something went wrong with the Oxford Dictionary servers. Please try again in a moment'
    else
      error = 'Unknown error occured. Please try again.'
    end
    #log error in log file
    log_error(error, url, JSON.parse(response.body))
    error
  end

  # creates url for requesting the information about the given word
  def find_word(word)
    puts 'valid?'
    # validate entry before send API request
    if validate_entry(word[:name])
      request_api("https://od-api.oxforddictionaries.com/api/v2/entries/en-gb/#{word['name']}")
    else
      nil
    end
  end

  # retrieves current words from session storage and keeps the array to a maximum of 5 words
  def set_words
    @words = session[:words]
    @words ||= []
    # shift array if it exceeds 5 words
    if @words.length > 5
      @words.shift
    end

  end

end
