# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'acts_as_diffable/version'

Gem::Specification.new do |s|
  s.name = %q{acts_as_diffable}
  s.version = ActsAsDiffable::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Mason 'bear454'"]
  s.date = %q{2012-05-07}
  s.description = %q{ActsAsDiffable provides a dead-simple way to compare two instances of a class, including any or all associations, or more complex relationships.}
  s.email = %q{jmason@suse.com}
  s.files = Dir.glob("lib/**/*")
  s.extra_rdoc_files = [
    "README"
  ]
  s.homepage = %q{https://github.com/bear454/ActsAsDiffable}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{Compare two instances of an ActiveRecord::Base class.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<acts_as_diffable>, [">= 0"])
      s.add_runtime_dependency(%q<jquery-rails>, [">= 0"])
      s.add_runtime_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<jquery-rails>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 2.3.14"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_runtime_dependency(%q<rails>, ["~> 3.2"])
    else
      s.add_dependency(%q<acts_as_diffable>, [">= 0"])
      s.add_dependency(%q<jquery-rails>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<jquery-rails>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 2.3.14"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<rails>, ["~> 3.2"])
    end
  else
    s.add_dependency(%q<acts_as_diffable>, [">= 0"])
    s.add_dependency(%q<jquery-rails>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<jquery-rails>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 2.3.14"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<rails>, ["~> 3.2"])
  end
  s.license = "MIT"
end

