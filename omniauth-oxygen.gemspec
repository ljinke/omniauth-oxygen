# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/oxygen/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-oxygen"
  spec.version       = Omniauth::Oxygen::VERSION
  spec.authors       = ["Jackie Liu"]
  spec.email         = ["ljinke@gmail.com"]
  spec.summary       = %q{OAuth for Autodesk accounts.}
  spec.description   = %q{OAuth for Autodesk accounts.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir.glob("{lib}/**/**/*") + ["Rakefile"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
