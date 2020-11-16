# Logs errors in a text file
class ErrorLogger
  def self.log(error, params = nil, response_params = nil)
    open('log.txt', 'a') do |f|
      f << "#{error} | #{params} | #{response_params} | #{DateTime.now}\n"
    end
  end
end