# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

require 'guard/roxy/version'

Gem::Specification.new do |gem|
  gem.name          = "guard-roxy"
  gem.version       = Guard::RoxyVersion::VERSION
  gem.authors       = ["Paxton Hare"]
  gem.email         = ["paxton@greenllama.com"]
  gem.description   = %q{Guard gem for running Roxy Unit Tests. Roxy is a Framework for writing xquery application in MarkLogic.}
  gem.summary       = %q{Guard gem for running Roxy Unit Tests}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
