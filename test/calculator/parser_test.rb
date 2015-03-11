require_relative '../../lib/calculator/parser'
require_relative '../../lib/calculator/token'
require 'test/unit'

module Calculator
  # tests the functionality of Parser.
  class ParserTest < Test::Unit::TestCase
    # Tests that "1" parses
    def test_single_integer
      assert_parses_to [IntegerToken.new(1)],
                       ExpressionNode.new(
                           TermNode.new(
                               FactorNode.new(
                                   BaseNode.new(
                                       IntegerToken.new(1))),
                               TermPrimeNode.new),
                           ExpressionPrimeNode.new)
    end

    # Tests that "-1.0" parses
    def test_single_decimal
      assert_parses_to [DecimalToken.new(-1)],
                       ExpressionNode.new(
                           TermNode.new(
                               FactorNode.new(
                                   BaseNode.new(
                                       DecimalToken.new(-1))),
                               TermPrimeNode.new),
                           ExpressionPrimeNode.new)
    end

    # Tests that "(-1)" parses
    def test_parenthetical_integer
      assert_parses_to [LeftParenthesisToken.instance, IntegerToken.new(-1), RightParenthesisToken.instance],
                       ExpressionNode.new(
                           TermNode.new(
                               FactorNode.new(
                                   BaseNode.new(
                                       LeftParenthesisToken.instance,
                                       ExpressionNode.new(
                                           TermNode.new(
                                               FactorNode.new(
                                                   BaseNode.new(
                                                       IntegerToken.new(-1))),
                                               TermPrimeNode.new),
                                           ExpressionPrimeNode.new),
                                       RightParenthesisToken.instance)),
                               TermPrimeNode.new),
                           ExpressionPrimeNode.new)
    end

    # Tests that "1 + 2.0" parses
    def test_addition
      assert_parses_to [IntegerToken.new(1), AddOpToken.instance, DecimalToken.new(2)],
                       ExpressionNode.new(
                           TermNode.new(
                               FactorNode.new(
                                   BaseNode.new(
                                       IntegerToken.new(1))),
                               TermPrimeNode.new),
                           ExpressionPrimeNode.new(
                               AddOpToken.instance,
                               TermNode.new(
                                   FactorNode.new(
                                       BaseNode.new(
                                           DecimalToken.new(2))),
                                   TermPrimeNode.new),
                               ExpressionPrimeNode.new))
    end

    # Tests that "0.0 - 2 + 3" parses
    def test_subtraction_with_addition
      assert_parses_to [DecimalToken.new(0), SubtractOpToken.instance, IntegerToken.new(2), AddOpToken.instance, DecimalToken.new(3)],
                       ExpressionNode.new(
                           TermNode.new(
                               FactorNode.new(
                                   BaseNode.new(
                                       DecimalToken.new(0))),
                               TermPrimeNode.new),
                           ExpressionPrimeNode.new(
                               SubtractOpToken.instance,
                               TermNode.new(
                                   FactorNode.new(
                                       BaseNode.new(
                                           IntegerToken.new(2))),
                                   TermPrimeNode.new),
                               ExpressionPrimeNode.new(
                                   AddOpToken.instance,
                                   TermNode.new(
                                       FactorNode.new(
                                           BaseNode.new(
                                               DecimalToken.new(3))),
                                       TermPrimeNode.new),
                                   ExpressionPrimeNode.new)))
    end

    # Tests that "0.0 * 2 + 3 / 4" parses
    def test_multiplication_addition_and_division
      assert_parses_to [DecimalToken.new(0),
                        MultiplyOpToken.instance,
                        IntegerToken.new(2),
                        AddOpToken.instance,
                        IntegerToken.new(3),
                        DivideOpToken.instance,
                        IntegerToken.new(4)],
                       ExpressionNode.new(
                           TermNode.new(
                               FactorNode.new(
                                   BaseNode.new(
                                       DecimalToken.new(0))),
                               TermPrimeNode.new(
                                   MultiplyOpToken.instance,
                                   FactorNode.new(
                                       BaseNode.new(
                                           IntegerToken.new(2))),
                                   TermPrimeNode.new)),
                           ExpressionPrimeNode.new(
                               AddOpToken.instance,
                               TermNode.new(
                                   FactorNode.new(
                                       BaseNode.new(
                                           IntegerToken.new(3))),
                                   TermPrimeNode.new(
                                       DivideOpToken.instance,
                                       FactorNode.new(
                                           BaseNode.new(
                                               IntegerToken.new(4))),
                                       TermPrimeNode.new)),
                               ExpressionPrimeNode.new))
    end

    # Tests that "0 ^ (1 + 2) ^ 3" parses
    def test_exponents_and_a_group
      assert_parses_to [IntegerToken.new(0),
                        ExponentOpToken.instance,
                        LeftParenthesisToken.instance,
                        IntegerToken.new(1),
                        AddOpToken.instance,
                        IntegerToken.new(2),
                        RightParenthesisToken.instance,
                        ExponentOpToken.instance,
                        IntegerToken.new(3)],
                       ExpressionNode.new(
                           TermNode.new(
                               FactorNode.new(
                                   BaseNode.new(
                                       IntegerToken.new(0)),
                                   ExponentOpToken.instance,
                                   FactorNode.new(
                                       BaseNode.new(
                                           LeftParenthesisToken.instance,
                                           ExpressionNode.new(
                                               TermNode.new(
                                                   FactorNode.new(
                                                       BaseNode.new(
                                                           IntegerToken.new(1))),
                                                   TermPrimeNode.new),
                                               ExpressionPrimeNode.new(
                                                   AddOpToken.instance,
                                                   TermNode.new(
                                                       FactorNode.new(
                                                           BaseNode.new(
                                                               IntegerToken.new(2))),
                                                       TermPrimeNode.new),
                                                   ExpressionPrimeNode.new)),
                                           RightParenthesisToken.instance),
                                       ExponentOpToken.instance,
                                       FactorNode.new(
                                           BaseNode.new(
                                               IntegerToken.new(3))))),
                               TermPrimeNode.new),
                           ExpressionPrimeNode.new)
    end

    # Tests that "+2" does not parse
    def test_plus_two
      assert_does_not_parse [AddOpToken.instance, IntegerToken.new(2)]
    end

    # Tests that "3.-" does not parse
    def three_minus
      assert_does_not_parse [DecimalToken.new(3), SubtractOpToken.instance]
    end

    private

    # asserts that a given list of tokens will parse into the given tree
    def assert_parses_to(tokens, expected)
      assert_nothing_raised "Exception occurred while parsing #{tokens.join(', ')}" do
        actual = Parser.new(tokens).tree
        assert_equal expected, actual, "Expected the tokens #{tokens.join(', ')} to parse to #{expected.to_s}; but got #{actual.to_s}"
      end
    end

    # assertion that an array of tokens will not parse
    def assert_does_not_parse(tokens)
      assert_raise SyntaxError, "A SyntaxError should have occurred while parsing #{tokens.join(', ')}" do
        Parser.new(tokens)
      end
    end
  end
end
