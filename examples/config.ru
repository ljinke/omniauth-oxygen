require 'bundler/setup'
require 'sinatra/base'
require 'omniauth-oxygen'

ENV['OXYGEN_CONSUMER_KEY'] = "eumx4m8w39qb"
ENV['OXYGEN_CONSUMER_SECRET'] = "PczJNDDLYic6kQOL"

class App < Sinatra::Base
  get '/' do
    redirect '/auth/linkedin'
  end

  get '/auth/:provider/callback' do
    content_type 'application/json'
    MultiJson.encode(request.env)
  end

  get '/auth/failure' do
    content_type 'application/json'
    MultiJson.encode(request.env)
  end
end

use Rack::Session::Cookie, :secret => "change_me"

use OmniAuth::Builder do
  provider :oxygen, OpenID::Store::Filesystem.new('/tmp'), 
    :name => 'oxygen',
    :identifier => 'https://accounts.autodesk.com', 
    :consumer_key => ENV['OXYGEN_CONSUMER_KEY'],
    :consumer_secret => ENV['OXYGEN_CONSUMER_SECRET']
end

run App.new