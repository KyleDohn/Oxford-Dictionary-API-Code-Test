# takes a word object and a dictionary source and returns a definition or appropriate error
class Dictionary < ApplicationService
  require 'Dictionaries/oxford'

  #list of dictionary sources available, add new sources here
  LIST = ['oxford']

  def initialize(word, source)
    @word = word
    @source = source
  end

  #defines the word or raises the appropriate error
  def call
    if @word.valid?
      if LIST.include?(@source)
        define
      else
        error = 'Unknown dictionary source'
        ErrorLogger.log(error, {word: @word.name, source: @source})
        raise error
      end
    else
      error = @word.errors.messages[:name][0]
      ErrorLogger.log(error, {word: @word.name, source: @source})
      raise error
    end
  end


  #uses source to retrieve definition of word
  def define
    source = @source.camelize.constantize
    url = source.url(@word)
    headers = source::HEADERS
    response = Excon.get(url, headers: headers)
    unless response.status == 200
      message = source.get_error_message(response.status)
      ErrorLogger.log(message, { word: @word, source: @source }, JSON.parse(response.body))
      raise message
    end
    source.parse_response(response)
  end

end