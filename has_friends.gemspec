# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "version"

Gem::Specification.new do |s|
  s.name        = "redu-has_friends"
  s.platform    = Gem::Platform::RUBY
  s.version     = Friends::VERSION
  s.authors     = ["jessicabarbalho, guiocavalcanti"]
  s.email       = ["jessica@redu.com.br", "guilhermec@redu.com.br"]
  s.homepage    = "https://github.com/redu/has_friends"
  s.summary     = %q{Adiciona suporte a amizado numa aplicação rails}
  s.description = %q{Permite que o usuário se relacione com outros usuários dentro de uma aplicação rails por meio de amizades}

  s.rubyforge_project = "has_friends"
  s.add_development_dependency 'rspec'
  s.add_development_dependency "bundler"
  s.add_development_dependency "activerecord", "~> 3.2"
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'debugger'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

