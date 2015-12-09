# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "knife-ec2find/version"

Gem::Specification.new do |s|
  s.name        = "knife-ec2find"
  s.version     = Knife::EC2Find::VERSION
  s.has_rdoc = true
  s.authors     = ["Mikhail Advani"]
  s.email       = ["mikhail.advani@gmail.com"]
  s.homepage = "https://github.com/mikhailadvani/knife-ec2find"
  s.summary = "AWS resource finder by tags using knife"
  s.description = s.summary
  s.extra_rdoc_files = ["README.rdoc", "LICENSE" ]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.add_dependency "knife-ec2"

  %w(rspec-core rspec-expectations rspec-mocks  rspec_junit_formatter).each { |gem| s.add_development_dependency gem }

  s.require_paths = ["lib"]
end