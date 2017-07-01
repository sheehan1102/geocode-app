require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/json'
require 'httparty'

if development?
  require 'pry'
  require 'sinatra/reloader'
end

require_relative './initializer'

Dir['./models/*'].each { |file| require file }
Dir['./services/*'].each { |file| require file }
Dir['./queries/*'].each { |file| require file }


# Static pages

get '/' do
  @locations = Location.id_descending
  erb :index, layout: :application
end


# Locations

post '/api/locations' do
  location = Location.new(location_params)
  if location.save
    coords = GoogleGeocoder.call(location)
    location.update_attributes(lat: coords[:lat], long: coords[:long])
    data = {
      id: location.id,
      address: location.full_text_address,
      lat: location.shortened(:lat),
      long: location.shortened(:long)
    }
    status 201
    json data.to_json
  else
    status 422
    json "{}"
  end
end

def location_params
  sanitized_hash = {}
  unless params[:location].nil?
    params[:location].each do |key, value|
      sanitized_hash[key] = ActiveRecord::Base.send(:sanitize_sql, value)
    end
  end
  return sanitized_hash
end
