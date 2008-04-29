require 'test_helper'

unit_tests do
  test "warning? returns true if exception is class to be treated as warning" do
    test_class = Class.new(Test::Unit::TestCase) do
      treat_error_as_warning RuntimeError
      treat_error_as_warning ArgumentError
    end

    assert_equal true, test_class.warning?(RuntimeError.new)
    assert_equal true, test_class.warning?(ArgumentError.new)
  end

  test "warning? returns true if exception is regiseted as warning in superclass" do
    test_superclass = Class.new(Test::Unit::TestCase) do
      treat_error_as_warning RuntimeError
    end

    assert_equal true, Class.new(test_superclass).warning?(RuntimeError.new)
  end

  test "warning? returns false if exception is not class to be treated as warning" do
    test_class = Class.new(Test::Unit::TestCase)
    assert_equal false, test_class.warning?(RuntimeError.new)
  end

  test "add_error routes exceptions registered as warnings to add_warning" do
    test_case = Class.new(Test::Unit::TestCase) do
      treat_error_as_warning RuntimeError
      test("warning") {raise RuntimeError}
    end.new("test_warning")

    test_case.run(result = Test::Unit::TestResult.new) {|c,e|}

    assert_equal 1, result.warning_count
  end

  test "add_warning adds a warning with test name and exception" do
    test_case = Test::Unit::TestCase.new("default_test")
    test_case.instance_variable_set(:@_result, result = Test::Unit::TestResult.new)
    test_case.add_warning(exception = StandardError.new)
    warning = result.send(:warnings).first

    assert_kind_of Test::Unit::Warning, warning
    assert_equal   test_case.name,      warning.test_name
    assert_equal   exception,           warning.exception
  end

  test "add_error routes unregisetered exceptions to add_error" do
    test_case = Class.new(Test::Unit::TestCase) do
      test("warning") {raise StandardError}
    end.new("test_warning")

    test_case.run(result = Test::Unit::TestResult.new) {|c,e|}

    assert_equal 1, result.error_count
  end

  test "unregistered exceptions make test fail" do
    test_case = Class.new(Test::Unit::TestCase) do
      test("warning") {raise StandardError}
    end.new("test_warning")

    test_case.run(Test::Unit::TestResult.new) {|c,e|}
    assert_equal false, test_case.send(:passed?)
  end
end
