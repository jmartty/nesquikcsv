#!/usr/bin/env rake
require "bundler/gem_tasks"

spec = Gem::Specification.load('nesquikcsv.gemspec')

require 'rake/extensiontask'
Rake::ExtensionTask.new('csv_parser', spec)

require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/tc_*.rb']
  #test.libs << 'lib' << 'test'
  #test.pattern = 'test/**/test_*.rb'
  #test.verbose = true
end

