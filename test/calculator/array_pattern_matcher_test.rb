require_relative '../../lib/calculator/array_pattern_matcher'
require 'test/unit'

module Calculator
  # Test suite for ArrayPatternMatcher
  class ArrayPatternMatcherTest < Test::Unit::TestCase
    # Test empty matchers
    def test_empty
      assert_true ArrayPatternMatcher.new === []
      assert_false ArrayPatternMatcher.new === Integer
    end

    # Test matchers with one element
    def test_one_arg
      assert_true ArrayPatternMatcher.new(1) === [1]
      assert_true ArrayPatternMatcher.new(Integer) === [1]
      assert_true ArrayPatternMatcher.new(/\s/) === [' ']
      assert_true ArrayPatternMatcher.new(String) === [' ']
      assert_false ArrayPatternMatcher.new(Integer) === []
      assert_false ArrayPatternMatcher.new(Integer) === [' ']
      assert_false ArrayPatternMatcher.new(String) === ' '
      assert_false ArrayPatternMatcher.new(Array) === ' '
    end

    # Test matchers with two elements
    def test_two_artgs
      assert_true ArrayPatternMatcher.new(1, 2) === [1, 2]
      assert_true ArrayPatternMatcher.new(Integer, 2) === [1, 2]
      assert_true ArrayPatternMatcher.new(/\s/, 'a') === [' ', 'a']
      assert_false ArrayPatternMatcher.new(/\s/, 'b') === [' ', 'a']
      assert_false ArrayPatternMatcher.new(/\s/) === [' ', 'a']
    end
  end
end
