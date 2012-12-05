# -*- encoding: utf-8 -*-
$:.push File.expand_path("../has_friends", __FILE__)
require "lib/version"

Gem::Specification.new do |s|
  s.name        = "has_friends"
  s.platform    = Gem::Platform::RUBY
  s.version     = VisClient::VERSION
  s.authors     = ["jessicabarbalho"]
  s.email       = ["jessica@redu.com.br"]
  s.homepage    = "https://github.com/jessicabarbalho/has_friends"
  s.summary     = %q{Adiciona suporte a amizado numa aplicação rails}
  s.description = %q{Esta gem permite que o usuário se relacione com outros usuários dentro de uma aplicação rails por meio de amizades}

  s.rubyforge_project = "has_friends"
  s.add_development_dependency "rspec"
  s.add_development_dependency "bundler"
  s.add_development_dependency "rails"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end

