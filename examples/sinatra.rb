require 'rubygems'
require 'bundler'
require 'json'

Bundler.setup :default, :example
require 'sinatra'
require 'omniauth-oxygen'

use Rack::Session::Pool

use OmniAuth::Builder do
  provider :oxygen, :env => "staging", :key => 'mycloud-staging.autodesk.com', :secret =>'Secret123'
end

get '/' do
  if (session[:auth].nil?)
    redirect '/auth/oxygen'
  else
    content_type :json
    session[:auth]
  end
end

[:get, :post].each do |method|
  send method, '/auth/:provider/callback' do
    content_type :json

    session[:auth] = request.env['omniauth.auth'].to_json

    redirect '/'
  end

  send method, '/auth/failure' do
    "OmniAuth authentication failed."
  end
end
