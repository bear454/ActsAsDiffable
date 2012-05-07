#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler jeweler` and `bundle install` to run rake tasks'
end

begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ActsAsDiffable'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    gem.name = "acts_as_diffable"
    gem.summary = "Compare two instances of an ActiveRecord::Base class."
    gem.description = "ActsAsDiffable provides a dead-simple way to compare two instances of a class, including any or all associations, or more complex relationships."
    gem.email = "jmason@suse.com"
    gem.homepage = "https://github.com/bear454/ActsAsDiffable"
    gem.authors = ["James Mason 'bear454'"]
    gem.add_dependency "activerecord", ">=2.3.14"
    gem.add_development_dependency "jeweler"
    gem.add_dependency "rails", "~>3.2"
  end
  Jeweler::RubygemsDotOrgTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end


Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end


task :default => :test
