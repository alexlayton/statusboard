require 'rubygems'
require 'sinatra'
require 'swoosh'
require 'json'

configure do
  set :fuelkey, 'ca1605577ac688c2fb9906760d78ff82'
end

get '/' do
  'You only YOLO once. YOYO'
end

get '/week' do
  content_type :json
  
  datapoints = Array.new
  
  fuelband = Swoosh::Client.new(settings.fuelkey)
  fuelband.weeks_fuel.reverse.each do |entry|
    day = entry[:date].strftime('%A')
    hash = { :title => day, :value => entry[:fuel]}
    datapoints.push(hash)
  end
  
  {
    :graph => {
      :title => 'Nike+ Fuel',
      :total => true,
      :type => 'line',
      :datasequences => [
          {
            :title => 'Week',
            :color => 'blue',
            :datapoints => datapoints
          }
      ]
    }
  }.to_json
end

get '/fuel/:days' do
  content_type :json
  
  to = Time.now
  from = to - (60 * 60 * 24 * params[:days].to_i)
  
  datapoints = Array.new
  fuelband = Swoosh::Client.new(settings.fuelkey)
  fuelband.fuel(from, to).reverse.each do |entry|
    day = entry[:date].strftime('%A')
    hash = { :title => day, :value => entry[:fuel]}
    datapoints.push(hash)
  end
  
  {
    :graph => {
      :title => 'Nike+ Fuel',
      :total => true,
      :type => 'line',
      :datasequences => [
          {
            :title => 'Week',
            :color => 'blue',
            :datapoints => datapoints
          }
      ]
    }
  }.to_json
end