require 'sinatra'
require 'tinder'
require 'pry'
require 'json'

post "/airbrake" do
  begin
    hoptoad_data = JSON.parse(request.body.read)
  rescue => e
    puts "Oops! #{e.inspect}\n#{request.body.read}"

    hoptoad_data = {}
  end

  # Make sure there's always an "error" key
  hoptoad_data['error'] ||= {}

  error_url = "http://airbrake.io/errors/#{hoptoad_data["error"]["id"]}"

  respond_body = " !! Exception on #{hoptoad_data["error"]["environment"]} !! #{hoptoad_data["error"]["error_message"]} (#{hoptoad_data["error"]["times_occurred"]} times) #{error_url}"

  campfire = Tinder::Campfire.new ENV['HUBOT_CAMPFIRE_ACCOUNT'], :token => ENV['HUBOT_CAMPFIRE_TOKEN']

  room = campfire.find_room_by_id ENV['HUBOT_CAMPFIRE_ROOMS']
  room.speak respond_body

  "Ok"
end
