# -*- encoding: utf-8 -*-
require File.expand_path('../lib/nesquikcsv/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Juan Martty"]
  gem.email         = ["null.terminated.string@gmail.com"]
  gem.description   = %q{Fastest-CSV fork with encoding support}
  gem.summary       = %q{Fastest-CSV fork with encoding support}
  gem.homepage      = "https://github.com/jmartty/nesquikcsv"

  gem.files         = `git ls-files`.split($\)
  #gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "nesquikcsv"
  gem.require_paths = ["lib"]
  gem.version       = NesquikCSV::VERSION

  gem.extensions  = ['ext/csv_parser/extconf.rb']
  
  gem.add_development_dependency "rake-compiler"
  
  gem.license = 'MIT'
end
