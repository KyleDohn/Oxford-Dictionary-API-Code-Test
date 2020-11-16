# Oxford dictionary source
class Oxford

  APP_ID = 'bba16219'
  APP_KEY = '50c00bf7a76d9662ac42b784fccfb234'

  HEADERS = {
      'app_id' => APP_ID,
      'app_key' => APP_KEY
  }


  # create url with given word
  def self.url(word)
    "https://od-api.oxforddictionaries.com/api/v2/entries/en-us/#{word}"
  end

  # parse definition from response
  def self.parse_response(response)
    JSON.parse(response.body)['results'][0]['lexicalEntries'][0]['entries'][0]['senses'][0]['definitions'][0]
  end

  # Returns user friendly error message based on codes defined in API
  def self.get_error_message(code)
    case code
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
      error = 'Unknown error occurred. Please try again.'
    end
    error
  end

end

