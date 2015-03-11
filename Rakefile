require 'rake/testtask'
require 'rdoc/task'

Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_test.rb'
end

RDoc::Task.new do |rdoc|
  rdoc.options = %w(--all)
  rdoc.rdoc_dir = 'doc'
  rdoc.main = 'README.md'
end

desc 'Run the calculator'
task :run do
  require_relative './lib/calculator'
  Calculator.run
end

desc 'Run tests'
task :default => :test
