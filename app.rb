require 'sinatra'
require 'hipchat'
require 'pry'
require 'json'

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
<a href='#{error_url}'>#{hoptoad_data["error"]["error_message"]}</a><br />
- environment: #{hoptoad_data["error"]["environment"]}<br />
- last occurence: #{hoptoad_data["error"]["last_occurred_at"]}<br />
- times occurred: #{hoptoad_data["error"]["times_occurred"]}<br />
DOC


  hipchat = HipChat::Client.new(token)
  hipchat[room_id].send("Airbrake", respond_body, :color => :red)
  "Ok"
end
