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

  test "wait method yields a frozen DirMonitorStruct" do
    @thread.join
    @monitor.wait(2){ |s|
      assert_kind_of(Struct::DirMonitorStruct, s)
      assert_equal(['action', 'file', 'changes'], s.members)
      assert_kind_of(Array, s.changes)
      assert_kind_of(Array, s.changes.first)
      assert_true(s.frozen?)
    }
  end

  test "wait method basic functionality" do
    assert_respond_to(@monitor, :wait)
  end

  # We provide some very short timeouts here - shouldn't slow the tests down
  test "wait method accepts an optional timeout value" do
    assert_nothing_raised{ @monitor.wait(0.01){ |s| } }
  end

  test "wait method accepts a single integer argument only" do
    assert_raise(ArgumentError){ @monitor.wait(1,1) }
    assert_raise(TypeError){ @monitor.wait('a') }
  end

  test "a custom error class is defined" do
    assert_kind_of(Object, Win32::DirMonitor::Error)
  end

  test "path attribute basic functionality" do
    assert_respond_to(@monitor, :path)
    assert_nothing_raised{ @monitor.path }
    assert_kind_of(String, @monitor.path)
  end

  test "path method returns expected value" do
    assert_equal(Dir.pwd, @monitor.path.tr("\\", "/"))
  end

  test "host attribute basic functionality" do
    assert_respond_to(@monitor, :host)
    assert_nothing_raised{ @monitor.host}
    assert_kind_of(String, @monitor.host)
  end

  test "host method returns expected value" do
    assert_equal(Socket.gethostname, @monitor.host)
  end

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
