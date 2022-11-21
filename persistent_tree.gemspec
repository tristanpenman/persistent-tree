Gem::Specification.new do |s|
  s.name = 'persistent_tree'
  s.version = '0.0.1'
  s.summary = 'Partially Persistent Tree for Ruby'
  s.description = "Partially Persistent Tree, based on Okasaki's thesis 'Purely Functional Data Structures'"
  s.homepage = 'https://github.com/tristanpenman/persistent-tree'
  s.license = 'MIT'
  s.authors = ['Tristan Penman']
  s.email = 'tristan@tristanpenman.com'
  s.required_ruby_version = '>= 2.6'

  s.files = [
    'lib/persistent_tree.rb',
    'lib/persistent_tree/algorithms.rb',
    'lib/persistent_tree/map.rb',
    'lib/persistent_tree/node.rb',
    'lib/persistent_tree/tree.rb'
  ]

  s.add_development_dependency 'rake', '~> 13.0.3'
  s.add_development_dependency 'rspec', '~> 3.10'
  s.add_development_dependency 'rubocop', '~> 1.39.0'
  s.add_development_dependency 'rubocop-rake', '~> 0.6.0'
  s.add_development_dependency 'rubocop-rspec', '~> 2.15.0'
  s.add_development_dependency 'simplecov', '~> 0.21.2'
end
