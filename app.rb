require 'sinatra'
require 'tinder'
require 'pry'
require 'json'

post "/airbrake" do
  token = params[:auth_token]
  room_id = params[:room_id]

  hoptoad_data = JSON.parse(request.body.read)

  error_url = if params[:company]
    "http://#{params[:company]}.airbrake.io/errors/#{hoptoad_data["error"]["id"]}"
  else
    "http://airbrake.io/errors/#{hoptoad_data["error"]["id"]}"
  end

  respond_body = " !! Exception on #{hoptoad_data["error"]["environment"]} !! #{hoptoad_data["error"]["error_message"]} (#{hoptoad_data["error"]["times_occurred"]} times) #{error_url}"

  campfire = Tinder::Campfire.new ENV['HUBOT_CAMPFIRE_ACCOUNT'], :token => ENV['HUBOT_CAMPFIRE_TOKEN']

  room = campfire.find_room_by_id ENV['HUBOT_CAMPFIRE_ROOMS']
  room.speak respond_body

  "Ok"
end
