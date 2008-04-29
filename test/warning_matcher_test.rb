require 'test_helper'

unit_tests do
  test "matching based on class returns true for same class" do
    matcher = Test::Unit::WarningMatcher.new(RuntimeError)
    assert_equal true, matcher.matches?(RuntimeError.new)
  end

  test "matching based on class returns true for subclasses" do
    matcher = Test::Unit::WarningMatcher.new(StandardError)
    assert_equal true, matcher.matches?(RuntimeError.new)
  end

  test "matching based on class returns false for non class/subclass" do
    matcher = Test::Unit::WarningMatcher.new(RuntimeError)
    assert_equal false, matcher.matches?(ArgumentError.new)
  end

  test "matching based on regex returns true if message matches regex" do
    matcher = Test::Unit::WarningMatcher.new(/some text in/)
    error   =      RuntimeError.new("there is some text in this message")
    assert_equal true, matcher.matches?(error)
  end

  test "matching based on regex retuns false if message doesn't match regex" do
    matcher = Test::Unit::WarningMatcher.new(/some text in/)
    error   =      RuntimeError.new("there is more text in this message")
    assert_equal false, matcher.matches?(error)
  end

  test "matching based on regex and class returns false if class doesn't match" do
    matcher = Test::Unit::WarningMatcher.new(ArgumentError, /abc/)
    error   = RuntimeError.new("abc")
    assert_equal false, matcher.matches?(error)
  end

  test "matching based on regex and class returns false if regex doesn't match" do
    matcher = Test::Unit::WarningMatcher.new(RuntimeError, /xyz/)
    error   = RuntimeError.new("abc")
    assert_equal false, matcher.matches?(error)
  end
end
