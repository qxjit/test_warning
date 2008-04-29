require 'test_helper'

unit_tests do
  test "initial warning count is 0" do
    assert_equal 0, Test::Unit::TestResult.new.warning_count
  end

  test "adding a warning increases warning count" do
    result = Test::Unit::TestResult.new

    result.add_warning Test::Unit::Warning.new(nil, nil)
    assert_equal 1, result.warning_count

    result.add_warning Test::Unit::Warning.new(nil, nil)
    assert_equal 2, result.warning_count
  end
end
