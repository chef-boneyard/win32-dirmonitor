require 'rubygems'

Gem::Specification.new do |spec|
  spec.name       = 'win32-dirmonitor'
  spec.version    = '1.0.0'
  spec.authors    = ['Daniel J. Berger', 'Park Heesob']
  spec.license    = 'Artistic 2.0'
  spec.email      = 'djberg96@gmail.com'
  spec.homepage   = 'https://github.com/djberg96/win32-dirmonitor'
  spec.summary    = 'A library for monitoring files on MS Windows'
  spec.test_file  = 'test/test_win32_dirmonitor.rb'
  spec.files      = Dir['**/*'].reject{ |f| f.include?('git') }

  spec.rubyforge_project = 'win32utils'

  spec.extra_rdoc_files = [
    'README',
    'CHANGES',
    'MANIFEST',
  ]

  spec.add_development_dependency('test-unit')
  spec.add_development_dependency('rake')

  spec.description = <<-EOF
    The win32-dirmonitor library provides a way to asynchronously monitor
    changes to files in a given directory, and provides detailed information
    about the changes that occurred.
  EOF
end
