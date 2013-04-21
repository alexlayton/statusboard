require 'rubygems'
require 'sinatra'
require 'swoosh'
require 'json'
require 'haml'

configure do
  set :fuelkey, 'ca1605577ac688c2fb9906760d78ff82'
end

get '/' do
  'You only YOLO once. YOYO'
end

get '/fuel/widget' do
  fuelband = Swoosh::Client.new(settings.fuelkey)
  haml :fuel, :locals => {:todays_fuel => fuelband.todays_fuel}
end

get '/fuel/graph/:days' do
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
            :title => "#{params[:days]} Days",
            :color => 'blue',
            :datapoints => datapoints
          }
      ]
    }
  }.to_json
end