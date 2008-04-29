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

  test "adding a warning notifies of change" do
    result = Test::Unit::TestResult.new

    value = nil
    result.add_listener(Test::Unit::TestResult::CHANGED) {|value|}
    result.add_warning  Test::Unit::Warning.new(nil, nil)

    assert_equal result, value
  end

  test "adding a warning notifies of fault" do
    result = Test::Unit::TestResult.new

    value = nil
    result.add_listener(Test::Unit::TestResult::FAULT) {|value|}
    result.add_warning  warning = Test::Unit::Warning.new(nil, nil)

    assert_equal warning, value
  end
end
