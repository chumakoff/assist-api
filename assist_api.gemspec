# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'assist_api/version'

Gem::Specification.new do |spec|
  spec.name          = "assist_api"
  spec.version       = AssistApi::VERSION
  spec.authors       = ["Pavel Ishenin (based on Anton Chumakov Assist SDK)"]
  spec.email         = ["isheninp@gmail.com"]

  spec.summary       = %q{Assist Online Payment API}
  spec.description   = %q{Assist Online Payment API}
  spec.homepage      = "https://github.com/isheninp/assist_api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 2.1"
end
