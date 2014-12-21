# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ppcommand/version'

Gem::Specification.new do |spec|
  spec.name          = 'ppcommand'
  spec.version       = PPCommand::VERSION
  spec.authors       = ['KOSEKI Kengo']
  spec.email         = ['koseki@gmail.com']
  spec.summary       = %q{Parse and pretty print YAML/JSON/XML/CSV/HTML}
  spec.description   = %q{Parse and pretty print YAML/JSON/XML/CSV/HTML}
  spec.homepage      = 'http://github.com/koseki/ppcommand'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'xml-simple'
  spec.add_dependency 'awesome_print'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
