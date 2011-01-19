# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "virastar/version"

Gem::Specification.new do |s|
  s.name        = "virastar"
  s.version     = Virastar::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Allen A. Bargi"]
  s.email       = ["allen.bargi@gmail.com"]
  s.homepage    = "http://github.com/aziz/virastar"
  s.summary     = %q{cleanning up Persian text!}
  s.description = %q{cleanning up Persian text!}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.rubyforge_project = "virastar"
  s.extra_rdoc_files  = [ "LICENSE", "README.md"]
  s.rdoc_options      = ["--charset=UTF-8"]
  s.add_development_dependency(%q<rspec>, ["~> 2.1.0"])
  s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
end
