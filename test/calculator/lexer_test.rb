require_relative '../../lib/calculator/lexer'
require_relative '../../lib/calculator/token'
require 'test/unit'

module Calculator
  # Tests for the Lexer class
  class LexerTest < Test::Unit::TestCase
    # asserts that the given source string tokenises to the given possibly
    # empty list of tokens
    def assert_tokenises_as(source, *expected)
      assert_nothing_raised "Exception occurred while tokenising #{source.inspect}" do
        actual = Lexer.new(source).to_a
        assert_equal expected, actual, "Expected the source #{source.inspect} to tokenise to #{expected.join(', ')}; but got #{actual.join(', ')}"
      end
    end

    # Ensure that the empty string works ok
    def test_empty_string
      assert_tokenises_as ''
    end

    # Ensure that all white space is eaten
    def test_only_whitespace
      assert_tokenises_as ' '
      assert_tokenises_as "\t"
      assert_tokenises_as "\n"
      assert_tokenises_as "\n \t"
    end

    # Try out non-negative integers
    def test_non_negative_integers
      (0..1000).each do |digit|
        assert_tokenises_as digit.to_s, IntegerToken.new(digit)
      end
      assert_tokenises_as '0 ', IntegerToken.new(0)
      assert_tokenises_as ' 0', IntegerToken.new(0)
    end

    # Try out negative integers
    def test_negative_integers
      (-1000..-1).each do |digit|
        assert_tokenises_as digit.to_s, IntegerToken.new(digit)
      end
      assert_tokenises_as '-1 ', IntegerToken.new(-1)
      assert_tokenises_as ' -1', IntegerToken.new(-1)
    end

    # Try out various decimals
    def test_decimals
      assert_tokenises_as '0.0', DecimalToken.new(0)
      assert_tokenises_as '1.', DecimalToken.new(1)
      assert_tokenises_as ' 3.14159', DecimalToken.new(3.14159)
      assert_tokenises_as '-2.0 ', DecimalToken.new(-2)
    end

    # A sequence of numbers
    def test_several_numbers
      assert_tokenises_as '1 -2 3. -4.0',
                          IntegerToken.new(1),
                          IntegerToken.new(-2),
                          DecimalToken.new(3),
                          DecimalToken.new(-4)
    end

    # Test tokenisation of the <tt>+</tt> operator
    def test_add_token
      assert_tokenises_as '+', AddOpToken.instance
      assert_tokenises_as ' +', AddOpToken.instance
      assert_tokenises_as ' + ', AddOpToken.instance
    end

    # Test tokenisation of the <tt>-</tt> operator
    def test_subtract_token
      assert_tokenises_as '-', SubtractOpToken.instance
      assert_tokenises_as ' -', SubtractOpToken.instance
      assert_tokenises_as ' - ', SubtractOpToken.instance
    end

    # Test tokenisation of the <tt>*</tt> operator
    def test_multiply_token
      assert_tokenises_as '*', MultiplyOpToken.instance
      assert_tokenises_as ' *', MultiplyOpToken.instance
      assert_tokenises_as ' * ', MultiplyOpToken.instance
    end

    # Test tokenisation of the <tt>*</tt> operator
    def test_divide_token
      assert_tokenises_as '/', DivideOpToken.instance
      assert_tokenises_as ' /', DivideOpToken.instance
      assert_tokenises_as ' / ', DivideOpToken.instance
    end

    # Test tokenisation of the <tt>^</tt> operator
    def test_exponent_token
      assert_tokenises_as '^', ExponentOpToken.instance
      assert_tokenises_as ' ^', ExponentOpToken.instance
      assert_tokenises_as ' ^ ', ExponentOpToken.instance
    end

    # Test tokenisation of the <tt>(</tt> operator
    def test_left_parenthesis_token
      assert_tokenises_as '(', LeftParenthesisToken.instance
      assert_tokenises_as ' (', LeftParenthesisToken.instance
      assert_tokenises_as ' ( ', LeftParenthesisToken.instance
    end

    # Test tokenisation of the <tt>(</tt> operator
    def test_right_parenthesis_token
      assert_tokenises_as ')', RightParenthesisToken.instance
      assert_tokenises_as ' )', RightParenthesisToken.instance
      assert_tokenises_as ' ) ', RightParenthesisToken.instance
    end

    # Tests an integer followed by a <tt>+</tt> operator
    def test_integer_plus_sequence
      assert_tokenises_as '2+2', IntegerToken.new(2), AddOpToken.instance, IntegerToken.new(2)
      assert_tokenises_as '2+-2', IntegerToken.new(2), AddOpToken.instance, IntegerToken.new(-2)
    end

    # Tests an integer followed by a <tt>-</tt> operator
    def test_integer_minus_sequence
      assert_tokenises_as '2-2', IntegerToken.new(2), SubtractOpToken.instance, IntegerToken.new(2)
      assert_tokenises_as '2--2', IntegerToken.new(2), SubtractOpToken.instance, IntegerToken.new(-2)
    end

    # Tests an integer followed by a <tt>*</tt> operator
    def test_integer_multiply_sequence
      assert_tokenises_as '2*2', IntegerToken.new(2), MultiplyOpToken.instance, IntegerToken.new(2)
      assert_tokenises_as '2*-2', IntegerToken.new(2), MultiplyOpToken.instance, IntegerToken.new(-2)
    end

    # Tests an integer followed by a <tt>/</tt> operator
    def test_integer_divide_sequence
      assert_tokenises_as '2/2', IntegerToken.new(2), DivideOpToken.instance, IntegerToken.new(2)
      assert_tokenises_as '2/-2', IntegerToken.new(2), DivideOpToken.instance, IntegerToken.new(-2)
    end

    # Tests an integer followed by a <tt>^</tt> operator
    def test_integer_exponent_sequence
      assert_tokenises_as '2^2', IntegerToken.new(2), ExponentOpToken.instance, IntegerToken.new(2)
      assert_tokenises_as '2^-2', IntegerToken.new(2), ExponentOpToken.instance, IntegerToken.new(-2)
    end

    # Tests an integer followed by a <tt>(</tt> operator
    def test_integer_left_paren_sequence
      assert_tokenises_as '2(2', IntegerToken.new(2), LeftParenthesisToken.instance, IntegerToken.new(2)
      assert_tokenises_as '-2(-2', IntegerToken.new(-2), LeftParenthesisToken.instance, IntegerToken.new(-2)
    end

    # Tests an integer followed by a <tt>*</tt> operator
    def test_integer_right_paren_sequence
      assert_tokenises_as '2)2', IntegerToken.new(2), RightParenthesisToken.instance, IntegerToken.new(2)
      assert_tokenises_as '-2)-2', IntegerToken.new(-2), RightParenthesisToken.instance, IntegerToken.new(-2)
    end

    # Tests a decimal followed by a <tt>+</tt> operator
    def test_decimal_plus_sequence
      assert_tokenises_as '2.+2.0', DecimalToken.new(2), AddOpToken.instance, DecimalToken.new(2)
      assert_tokenises_as '2.0+-2.', DecimalToken.new(2), AddOpToken.instance, DecimalToken.new(-2)
    end

    # Tests a decimal followed by a <tt>-</tt> operator
    def test_decimal_minus_sequence
      assert_tokenises_as '2.-2.0', DecimalToken.new(2), SubtractOpToken.instance, DecimalToken.new(2)
      assert_tokenises_as '2.0--2.', DecimalToken.new(2), SubtractOpToken.instance, DecimalToken.new(-2)
    end

    # Tests a decimal followed by a <tt>*</tt> operator
    def test_decimal_multiply_sequence
      assert_tokenises_as '2.*2.0', DecimalToken.new(2), MultiplyOpToken.instance, DecimalToken.new(2)
      assert_tokenises_as '2.0*-2.', DecimalToken.new(2), MultiplyOpToken.instance, DecimalToken.new(-2)
    end

    # Tests a decimal followed by a <tt>/</tt> operator
    def test_decimal_divide_sequence
      assert_tokenises_as '2./2.0', DecimalToken.new(2), DivideOpToken.instance, DecimalToken.new(2)
      assert_tokenises_as '2.0/-2.', DecimalToken.new(2), DivideOpToken.instance, DecimalToken.new(-2)
    end

    # Tests a decimal followed by a <tt>^</tt> operator
    def test_decimal_exponent_sequence
      assert_tokenises_as '2.^2.0', DecimalToken.new(2), ExponentOpToken.instance, DecimalToken.new(2)
      assert_tokenises_as '2.0^-2.', DecimalToken.new(2), ExponentOpToken.instance, DecimalToken.new(-2)
    end

    # Tests a decimal followed by a <tt>(</tt> operator
    def test_decimal_left_paren_sequence
      assert_tokenises_as '2.(2.0', DecimalToken.new(2), LeftParenthesisToken.instance, DecimalToken.new(2)
      assert_tokenises_as '-2.0(-2.', DecimalToken.new(-2), LeftParenthesisToken.instance, DecimalToken.new(-2)
    end

    # Tests a decimal followed by a <tt>*</tt> operator
    def test_decimal_right_paren_sequence
      assert_tokenises_as '2.)2.0', DecimalToken.new(2), RightParenthesisToken.instance, DecimalToken.new(2)
      assert_tokenises_as '-2.0)-2.', DecimalToken.new(-2), RightParenthesisToken.instance, DecimalToken.new(-2)
    end

    # Tests all sequences of one operator followed by another
    def test_op_op_sequences
      ops = [AddOpToken.instance, SubtractOpToken.instance,
             MultiplyOpToken.instance, DivideOpToken.instance,
             ExponentOpToken.instance,
             LeftParenthesisToken.instance, RightParenthesisToken.instance]
      ops.each do |op1|
        ops.each do |op2|
          source = op1.lexeme.to_s + op2.lexeme.to_s
          assert_tokenises_as source, op1, op2
        end
      end
    end
  end
end
