# encoding: utf-8
require 'omniauth'
require 'rack/openid'
require 'openid/store/memory'

module OmniAuth
  module Strategies
    class Oxygen
      include OmniAuth::Strategy

        AX = {
          :email => 'http://axschema.org/contact/email',
          :name => 'http://axschema.org/namePerson',
          :nickname => 'http://axschema.org/namePerson/friendly',
          :first_name => 'http://axschema.org/namePerson/first',
          :last_name => 'http://axschema.org/namePerson/last',
          :uid => "http://axschema.org/autodesk/userid",
          :image20 => "http://axschema.org/autodesk/media/image/20",
          :image50 => "http://axschema.org/autodesk/media/image/50"
        }

        option :env, :staging
        option :required, [AX[:email], AX[:name], AX[:first_name], AX[:last_name], 'email', 'fullname', AX[:uid], AX[:image20], AX[:image50]]
        option :optional, [AX[:nickname], 'nickname']
        option :store, ::OpenID::Store::Memory.new
        option :identifier, nil
        option :identifier_param, 'openid_url'
        option :logout, '/auth/oxygen'

        def request_phase
         openid = Rack::OpenID.new(dummy_app, options[:store])
          response = openid.call(env)
          case env['rack.openid.response']
          when Rack::OpenID::MissingResponse, Rack::OpenID::TimeoutResponse
            fail!(:connection_failed)
          else
            response
          end
        end

        def callback_phase
          return fail!(:invalid_credentials) unless openid_response && openid_response.status == :success
          super
        end

        def other_phase
          if on_path?("/auth/logout")
            @env['omniauth.strategy'] ||= self
            setup_phase
            [302, {'Content-Type' => 'text','Location' => logout_url}, ['302 found'] ]
          else
            call_app!
          end
        end

        uid { oxygen_info['uid'] }

        info do
          oxygen_info
        end

        def credentials
          {}
        end

        extra do
          {}
        end

      private

        def dummy_app
          lambda{|env| [401, {"WWW-Authenticate" => Rack::OpenID.build_header(
              :identifier => identifier,
              :return_to => callback_url,
              :required => options.required,
              :optional => options.optional,
              :"oauth[consumer]" => @options[:key],
              :method => 'post'
            )}, []]}
        end

        def identifier
          i = options.identifier || request.params[options.identifier_param.to_s] || ENV['OXYGEN_URL']

          if i.nil? or i == ''
            i = case options.env
            when "development"
              ENV['OXYGEN_URL'] || "https://accounts-staging.autodesk.com"
            when "production"
              ENV['OXYGEN_URL'] || "https://accounts.autodesk.com"
            else
              ENV['OXYGEN_URL'] || "https://accounts-staging.autodesk.com"
            end
          end
          i + "?viewmode=popup"
        end

        def logout_url
          "#{identifier}/Authentication/LogOut?ReturnToUrl=#{full_host}#{logout_return_url}"
        end

	def logout_return_url
	  options[:logout] ||= '/auth/oxygen'
	end

	def openid_response
          unless @openid_response
            openid = Rack::OpenID.new(lambda{|env| [200,{},[]]}, options[:store])
            openid.call(env)
            @openid_response = env.delete('rack.openid.response')
          end
          @openid_response
        end

        def sreg_user_info
          sreg = ::OpenID::SReg::Response.from_success_response(openid_response)
          return {} unless sreg
          {
            'email' => sreg['email'],
            'name' => sreg['fullname'],
            'location' => sreg['postcode'],
            'nickname' => sreg['nickname']
          }.reject{|k,v| v.nil? || v == ''}
        end

        def ax_user_info
          ax = ::OpenID::AX::FetchResponse.from_success_response(openid_response)
          return {} unless ax
          {
            'email' => ax.get_single(AX[:email]),
            'first_name' => ax.get_single(AX[:first_name]),
            'last_name' => ax.get_single(AX[:last_name]),
            'name' => (ax.get_single(AX[:name]) || [ax.get_single(AX[:first_name]), ax.get_single(AX[:last_name])].join(' ')).strip,
            'nickname' => ax.get_single(AX[:nickname]),
            'uid' => ax.get_single(AX[:uid]),
            'profile20' => ax.get_single(AX[:image20]),
            'profile50' => ax.get_single(AX[:image50])
          }.inject({}){|h,(k,v)| h[k] = Array(v).first; h}.reject{|k,v| v.nil? || v == ''}
        end

        def oxygen_info
          @oxygen_info ||= sreg_user_info.merge(ax_user_info)
        end
    end
  end
end
