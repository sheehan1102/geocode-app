require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require 'sinatra/json'
require 'httparty'
require 'pry'

require_relative './initializer'

Dir['./models/*'].each { |file| require file }
Dir['./services/*'].each { |file| require file }


# Static pages

get '/' do
  @locations = Location.all
  erb :index, layout: :application
end


# Locations

post '/api/locations' do
  location = Location.new(location_params)
  if location.save
    coords = GoogleGeocoder.call(location)
    location.update_attributes(lat: coords[:lat], long: coords[:long])
    data = { address: location.full_text_address, coords: location.full_text_coordinates }
    status 201
    json data.to_json
  else
    status 422
    json {}.to_json
  end
end

def location_params
  sanitized_hash = { }
  params[:location].each do |key, value|
    sanitized_hash[key] = ActiveRecord::Base.send(:sanitize_sql, value)
  end
  return sanitized_hash
end
