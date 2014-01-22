########################################################################
# example_changejournal.rb
#
# A test script for general futzing.  Modify as you see fit. You can
# run this test script via the 'rake example' task.
########################################################################
require 'win32/dirmonitor'

puts 'VERSION: ' + Win32::DirMonitor::VERSION

monitor = Win32::DirMonitor.new(ENV['HOME'])

# Wait up to 5 minutes for a change journals
monitor.wait(300){ |struct|
  puts 'Something changed'
  puts 'File: ' + struct.file
  puts 'Action: ' + struct.action
  struct.changes.each do |change|
    puts "Change: " + change[0].to_s
    puts "Old: " + change[1].to_s
    puts "New: " + change[2].to_s
  end
}
