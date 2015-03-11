module Calculator
  # A utility for pattern matching within arrays
  class ArrayPatternMatcher
    # Create with the array of values to match against
    def initialize(*patterns)
      @pattern_array = patterns
    end

    # Match the elements of the arugment (which must by an array) with the
    # values contained herein
    def ===(value_array)
      value_array.is_a?(Array) &&
        value_array.length == @pattern_array.length &&
        @pattern_array.zip(value_array).all? { |pattern, value| pattern === value }
    end
  end
end
