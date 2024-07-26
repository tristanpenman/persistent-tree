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
end
