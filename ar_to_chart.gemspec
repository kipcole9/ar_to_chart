# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ar_to_chart/version"

Gem::Specification.new do |s|
  s.name        = "ar_to_chart"
  s.version     = ArToChart::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Kip Cole"]
  s.email       = ["kipcole9@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/ar_to_chart"
  s.summary     = %q{Render an ActiveRecord result set as a chart}
  s.description = <<-EOF
    Defines Array#to_chart that will accept ActiveRecord result sets
    and render them as a chart.  Currently assumes OpenFlashChart as the
    only supported charting engine.  Protovis based charting coming
    soon.
  EOF

  s.rubyforge_project = "ar_to_chart"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
