# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'myrando/version'

Gem::Specification.new do |spec|
  spec.name          = "myrando"
  spec.version       = Myrando::VERSION
  spec.authors       = ["Ómar Kjartan Yasin"]
  spec.email         = ["omarkj@gmail.com"]
  spec.summary       = "Interact with the Rando API"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "uri-handler"
  spec.add_dependency "httparty"
  spec.add_dependency "multi_json"
end
