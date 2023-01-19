require("open-uri")
require("json")
require("date")
require("time")

puts "========================================"
puts "Will you need an umbrella today?"
puts "========================================"

puts "Where are you?"

#user_location = gets.chomp
user_location = "Gleacher Center"

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{ENV.fetch("GMAPS_KEY")}"

raw_gmap_response = URI.open(gmaps_url).read
parsed_gmap_response = JSON.parse(raw_gmap_response)

results_gmap_array = parsed_gmap_response.fetch("results")

results_gmap = results_gmap_array[0]

geometry = results_gmap.fetch("geometry")
location = geometry.fetch("location")
location_lat = location.fetch("lat")
location_lng = location.fetch("lng")

puts "Checking the weather at " + user_location.capitalize + "...."

puts "Your coordinates are " + location_lat.to_s + ", " + location_lng.to_s + "."

darksky_url = "https://api.darksky.net/forecast/#{ENV.fetch("DARK_SKY_KEY")}/#{location_lat},#{location_lng}"

raw_ds_response = URI.open(darksky_url).read
parsed_ds_response = JSON.parse(raw_ds_response)

current_temp_hash = parsed_ds_response.fetch("currently")
current_temp = current_temp_hash.fetch("temperature")

hourly_temp_hash = parsed_ds_response.fetch("hourly")
hourly_temp_data = hourly_temp_hash.fetch("data")

puts "It is currently #{current_temp}°F."


counter = 0
while counter < 12
  epoch_time = hourly_temp_data[counter].fetch("time")
  hours_from = (Time.at(epoch_time) - Time.now) / 3600
  p "In #{hours_from} hours"
  p "there is a #{hourly_temp_data[counter].fetch("precipProbability")}% chance of precipitation."
  counter = counter + 1
end
