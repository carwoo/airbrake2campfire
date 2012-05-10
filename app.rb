require 'sinatra'
require 'hipchat'
require 'pry'
require 'json'

get "/" do
  ""
end

post "/" do
  token = params[:auth_token]
  room_id = params[:room_id]

  hoptoad_data = JSON.parse(request.body.read)

  error_url = if params[:company]
    "http://#{params[:company]}.airbrake.io/errors/#{hoptoad_data["error"]["id"]}"
  else
    "http://airbrake.io/errors/#{hoptoad_data["error"]["id"]}"
  end

respond_body =<<DOC
#{hoptoad_data["error"]["error_class"]}: #{hoptoad_data["error"]["error_message"]}<br />
Environment: #{hoptoad_data["error"]["environment"]}<br />
Last occurence: #{hoptoad_data["error"]["last_occurred_at"]}<br />
Times occurred: #{hoptoad_data["error"]["times_occurred"]}<br />
<a href='#{error_url}'>view on Airbake...</a>
DOC


  hipchat = HipChat::Client.new(token)
  hipchat[room_id].send("Airbrake", respond_body, :color => :red)
  "Ok"
end
