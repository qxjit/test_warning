require 'test_helper'

unit_tests do
  test "single_character_display is 'W'" do
    assert_equal 'W', 
                 Test::Unit::Warning.new('name', nil).single_character_display
  end

  test "long_display includes warning designation" do
    assert_match /Warning/, 
                 Test::Unit::Warning.new("name", Exception.new).long_display
  end

  test "long_display includes test name" do
    assert_match /TestName/, 
                 Test::Unit::Warning.new("TestName", Exception.new).long_display
  end

  test "long_display includes message" do
    warning = Test::Unit::Warning.new("TestName", Exception.new("message"))
    assert_match(/#{warning.message}/, warning.long_display)
  end

  test "long_display includes backtrace" do
    exception = Exception.new   
    exception.set_backtrace ['backtrace_line_1', 'backtrace_line_2']

    assert_match /backtrace_line_1.*backtrace_line_2/m, 
                 Test::Unit::Warning.new("TestName", exception).long_display
  end

  test "long_display only includes first few elements of backtrace" do
    exception = Exception.new   
    exception.set_backtrace ['backtrace_line_1', 
                             'backtrace_line_2',
                             'backtrace_line_3',
                             'backtrace_line_4',
                             'backtrace_line_5']

    warning = Test::Unit::Warning.new("TestName", exception)
    assert_match    /backtrace_line_4/, warning.long_display
    assert_no_match /backtrace_line_5/, warning.long_display
  end
end
