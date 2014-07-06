# encoding: utf-8

require 'omniauth-oauth'

module OmniAuth
  module Strategies
    class Oxygen < OmniAuth::Strategies::OAuth
      option :name, "oxygen"

      option :client_options, {
        :site => 'https://accounts.autodesk.com',
        :site_dev => 'https://accounts-dev.autodesk.com',
        :site_staging => 'https://accounts-staging.autodesk.com',
        :authorize_url => '/oauth2.0/authorize',
        :token_url => "/oauth2.0/token"
      }

      option :scope, 'r_basicprofile r_emailaddress'

      uid do
        @uid ||= begin
          access_token.options[:mode] = :query
          access_token.options[:param_name] = :access_token
          # Response Example: "callback( {\"client_id\":\"11111\",\"openid\":\"000000FFFF\"} );\n"
          response = access_token.get('/oauth2.0/me')
          #TODO handle error case
          matched = response.body.match(/"openid":"(?<openid>\w+)"/)
          matched[:openid]
        end
      end

      info do 
        { 
          :nickname => raw_info['nickname'],
          :name => raw_info['nickname'],
          :image => raw_info['figureurl_1'],
        }
      end
      
      extra do
        {
          :raw_info => raw_info
        }
      end

      def raw_info
        @raw_info ||= begin
          #TODO handle error case
          #TODO make info request url configurable
          client.request(:get, "https://graph.qq.com/user/get_user_info", :params => {
              :format => :json,
              :openid => uid,
              :oauth_consumer_key => options[:client_id],
              :access_token => access_token.token
            }, :parse => :json).parsed
        end
      end
    end
  end
end

#OmniAuth.config.add_camelization('qq_connect', 'QQConnect')