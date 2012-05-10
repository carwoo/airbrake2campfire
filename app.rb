require 'sinatra'
require 'hipchat'
require 'pry'
require 'json'

get "/" do
  "<img style='height: 100%' src='http://blog.stackoverflow.com/wp-content/uploads/error-lolcat-problemz.jpg'>"
end

post "/" do
  token = params[:auth_token]
  room_id = params[:room_id]
  hoptoad_data = JSON.parse(request.body.read)
  respond_body = "#{hoptoad_data["error"]["error_class"]}:#{hoptoad_data["error"]["error_message"]}<br /><a href='http://airbrake.io/projects/#{hoptoad_data["error"]["id"]}/errors'>View on Airbake...</a>"
  hipchat = HipChat::Client.new(token)
  hipchat[room_id].send("Airbake", respond_body, :color => :red)
  "Ok"
end
