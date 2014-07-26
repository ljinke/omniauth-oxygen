# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/oxygen/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-oxygen"
  spec.version       = Omniauth::Oxygen::VERSION
  spec.authors       = ["Jackie Liu"]
  spec.email         = ["jinke.liu@autodesk.com"]
  spec.summary       = %q{Omniauth OpenID strategy for Autodesk accounts.}
  spec.description   = %q{Omniauth OpenID strategy for Autodesk accounts.}
  spec.homepage      = "https://github.com/ljinke/omniauth-oxygen"
  spec.license       = "MIT"

  spec.files = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_dependency('omniauth', '~> 1.0')
  spec.add_dependency('oauth', '0.4.7')

  spec.add_dependency 'rack-openid', '~> 1.3.1'
  spec.add_development_dependency 'rack-test', '~> 0.5'
  spec.add_development_dependency 'rdiscount', '~> 1.6'
  spec.add_development_dependency 'rspec', '~> 2.7'
  spec.add_development_dependency 'simplecov', '~> 0.4'
  spec.add_development_dependency 'webmock', '~> 1.7'
  spec.add_development_dependency 'yard', '~> 0.7'

  spec.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if spec.respond_to? :required_rubygems_version=
  spec.summary = spec.description
end
