# Omniauth::Oxygen

An Omniauth strategy for Autodesk accounts.

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth-oxygen', :git => 'git@github.com:ljinke/omniauth-oxygen.git'

And then execute:

    $ bundle install


## Usage


Ruby on Rails:
  
In development.rb, add

    config.middleware.use OmniAuth::Builder do
      provider :oxygen, :env => "staging"
    end

or in production.rb, add

    config.middleware.use OmniAuth::Builder do
      provider :oxygen, :env => "production"
    end

## Run the example

Update /etc/hosts: 

     127.0.1.1 b2-dev.autodesk.com

Go to the examples folder:

     $ ruby sinatra.rb

Visit http://b2-dev.autodesk.com:4567
