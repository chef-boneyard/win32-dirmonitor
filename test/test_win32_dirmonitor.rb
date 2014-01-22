#############################################################################
# test_win32_dirmonitor.rb
#
# Test suite for the win32-dirmonitor library. You should run this
# via the 'rake test' task.
#############################################################################
require 'test-unit'
require 'win32/dirmonitor'
include Win32

class TC_Win32_DirMonitor < Test::Unit::TestCase
  def self.startup
    Dir.chdir(File.expand_path(File.dirname(__FILE__)))
    @@file = 'win32_dirmonitor_test.txt'
  end

  def setup
    # The thread is used to force an event to happen for the tests
    @monitor = DirMonitor.new(Dir.pwd)
    @thread  = Thread.new{
       sleep 2
       File.open(@@file, 'w'){ |fh| fh.puts 'Delete me!' }
    }
  end

  test "version constant is set to expected value" do
    assert_equal('1.0.0', DirMonitor::VERSION)
  end

  test "constructor requires a path argument" do
    assert_raise(ArgumentError){ DirMonitor.new }
  end

  test "path and host arguments must be strings" do
    assert_raise(TypeError){ DirMonitor.new(1) }
    assert_raise(TypeError){ DirMonitor.new(Dir.pwd, 1) }
  end

  test "path argument must exist" do
    assert_raise(ArgumentError){ DirMonitor.new("C:/Bogus/Bogus") }
  end

=begin
   def test_dirmonitor_action
      @thread.join
      @monitor.wait(2){ |c|
         assert_kind_of(Array, c)
         assert_kind_of(Struct::DirMonitorStruct, c.first)
         assert_equal(['action', 'file_name', 'path'], c.first.members)
         assert_true(c.first.frozen?)
      }
   end

   # We provide some very short timeouts here - shouldn't slow the tests down
   def test_wait_basic
      assert_respond_to(@monitor, :wait)
      assert_nothing_raised{ @monitor.wait(0.01) }
      assert_nothing_raised{ @monitor.wait(0.01){ |s| } }
   end

   def test_wait_expected_errors
      assert_raise(ArgumentError){ @monitor.wait(1,1) }
      assert_raise(TypeError){ @monitor.wait('a') }
   end

   def test_error_class_defined
      assert_kind_of(Object, Win32::DirMonitor::Error)
   end
=end

  def teardown
    @thread.kill if @thread.alive?

    @monitor = nil
    @flags   = nil
    @thread  = nil
  end

  def self.shutdown
    File.delete(@@file) if File.exists?(@@file)
  end
end
