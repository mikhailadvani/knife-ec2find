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
  s.description = "Referencing of resources needs to be done by ids but the only controlled attributes are tags. This is a knife plugin to help you get the id using tags"
  s.license = "Apache"
  s.extra_rdoc_files = ["LICENSE" ]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.add_dependency "aws-sdk", "~> 2.0"
  s.add_dependency "chef", "~> 12.5"

  %w(rspec-core rspec-expectations rspec-mocks  rspec_junit_formatter).each { |gem| s.add_development_dependency gem }

  s.require_paths = ["lib"]
end