module Test
  module Unit
    class TestCase
      def self.warning_matchers
        @warning_matchers ||= []
      end

      def self.treat_error_as_warning(error_class)
        warning_matchers << WarningMatcher.new(error_class)
      end

      def self.warning?(error)
        return true if superclass.warning?(error) unless self == TestCase
        warning_matchers.any? {|m| m.matches?(error)}
      end
      
      alias_method :add_error_without_warnings, :add_error
      def add_error(error)
        if self.class.warning?(error)
          add_warning(error)
        else
          add_error_without_warnings(error)
        end
      end

      def add_warning(error)
        @_result.add_warning Test::Unit::Warning.new(name, error)
      end
    end

    class Warning < Error
      def single_character_display
        'W'
      end

      def backtrace_limit
        4
      end

      def long_display
        backtrace = filter_backtrace(@exception.backtrace).
                      first(backtrace_limit).join("\n    ")

        "Warning:\n#{@test_name}:#{message}\n    #{backtrace}"
      end
    end

    class TestResult
      def add_warning(exception)
        warnings << exception
      end

      def warning_count
        warnings.size
      end

      protected

      def warnings
        @warnings ||= []
      end
    end

    class WarningMatcher
      def initialize(*criteria)
        @criteria = criteria
      end

      def matches?(error)
        @criteria.all? do |crit|
          if crit.kind_of?(Class)
            error.kind_of?(crit)
          else
            !!crit.match(error.message)
          end
        end
      end
    end
  end
end
