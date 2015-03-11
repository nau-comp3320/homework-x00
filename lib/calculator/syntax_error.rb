module Calculator
  # Handy exception class for syntax errors
  class SyntaxError < Exception
    # Creates a new error with the given message
    def initialize(message)
      super(message)
    end
  end
end
