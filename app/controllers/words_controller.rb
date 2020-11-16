class WordsController < ApplicationController

  before_action :set_words # keeps the last 5 words in memory


  def index
    @dictionary_list = Dictionary::LIST
    # get error message returned from last request
    @error = session[:error]
    # clear out error
    session[:error] = nil
  end

  def define
    word = Word.new(params[:word][:name])
    begin
      word.definition = Dictionary.call(word, params[:source])
      @words.push(word)
      session[:words] = @words
      session[:error] = nil
    rescue StandardError => e
      session[:error] = e.message
    end
    redirect_to action: 'index'
  end

  private

  # retrieves current words from session storage and keeps the array to a maximum of 5 words
  def set_words
    @words = session[:words]
    @words ||= []
    # shift array if it exceeds 5 words
    @words.length > 5 && @words.shift
  end

end
