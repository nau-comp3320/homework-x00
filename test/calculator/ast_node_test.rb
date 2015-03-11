require_relative '../../lib/calculator/ast_node'
require_relative '../../lib/calculator/token'
require 'test/unit'

module Calculator
  # Test suite for AST node attributes
  class ASTNodeTest < Test::Unit::TestCase
    # An approximation of π
    PI = 3.14159263
    # An approximation of e
    E = 2.718281828

    # Base node of the integer 2
    B_TWO = BaseNode.new(IntegerToken.new(2))
    # Base node of the integer 3
    B_THREE = BaseNode.new(IntegerToken.new(3))
    # Base node of the decimal PI
    B_PI = BaseNode.new(DecimalToken.new(PI))
    # Base node of the decimal E
    B_E = BaseNode.new(DecimalToken.new(E))

    # Factor node of the integer 2
    F_TWO = FactorNode.new(B_TWO)
    # Factor node of the integer 3
    F_THREE = FactorNode.new(B_THREE)
    # Factor node of the decimal PI
    F_PI = FactorNode.new(B_PI)
    # Factor node of the decimal E
    F_E = FactorNode.new(B_E)

    # Term node of the integer 2
    T_TWO = TermNode.new(F_TWO, TermPrimeNode.new)
    # Term node of the integer 3
    T_THREE = TermNode.new(F_THREE, TermPrimeNode.new)
    # Term node of the decimal PI
    T_PI = TermNode.new(F_PI, TermPrimeNode.new)
    # Term node of the decimal E
    T_E = TermNode.new(F_E, TermPrimeNode.new)

    # Expression node of the integer 2
    E_TWO = ExpressionNode.new(T_TWO, ExpressionPrimeNode.new)
    # Expression node of the integer 3
    E_THREE = ExpressionNode.new(T_THREE, ExpressionPrimeNode.new)
    # Expression node of the decimal PI
    E_PI = ExpressionNode.new(T_PI, ExpressionPrimeNode.new)
    # Expression node of the decimal E
    E_E = ExpressionNode.new(T_E, ExpressionPrimeNode.new)


    # test that constructing a base node from an integer results in the correct
    # value and type
    def DISABLED_test_integer_base_node
      assert_integer_with_value 2, B_TWO
      assert_integer_with_value 3, B_THREE
    end

    # test that constructing a base node from a decimal results in the correct
    # value and type
    def DISABLED_test_decimal_base_node
      assert_decimal_with_value PI, B_PI
      assert_decimal_with_value E, B_E
    end

    # tests that constructing a factor node from just a base node results in
    # the correct value and type
    def DISABLED_test_base_factor_node
      assert_integer_with_value 2, F_TWO
      assert_integer_with_value 3, F_THREE
      assert_decimal_with_value PI, F_PI
      assert_decimal_with_value E, F_E
    end

    # tests that constructing a factor node from a base node and exponent
    # results in the correct value and type
    def DISABLED_test_exponent_factor_node
      assert_integer_with_value 8, FactorNode.new(B_TWO, ExponentOpToken.instance, F_THREE)
      assert_integer_with_value 9, FactorNode.new(B_THREE, ExponentOpToken.instance, F_TWO)
      assert_decimal_with_value PI ** E, FactorNode.new(B_PI, ExponentOpToken.instance, F_E)
      assert_decimal_with_value PI ** 2, FactorNode.new(B_PI, ExponentOpToken.instance, F_TWO)
      assert_decimal_with_value 2 ** E, FactorNode.new(B_TWO, ExponentOpToken.instance, F_E)
    end

    # tests that constructing a factor node from a base node, exponent, and
    # exponent results int he correct value and type
    def DISABLED_test_two_exponent_factor_node
      assert_integer_with_value 512, FactorNode.new(B_TWO, ExponentOpToken.instance, F_THREE, ExponentOpToken.instance, F_TWO)
      assert_decimal_with_value PI ** E ** 2, FactorNode.new(B_PI, ExponentOpToken.instance, F_E, ExponentOpToken.instance, F_TWO)
    end

    # tests that constructing a factor node from a base node, exponent,
    # exponent, and exponent results in the correct value and type
    def DISABLED_test_three_exponent_factor_node
      assert_integer_with_value 65536, FactorNode.new(B_TWO, ExponentOpToken.instance, F_TWO, ExponentOpToken.instance, F_TWO, ExponentOpToken.instance, F_TWO)
      assert_decimal_with_value PI ** 2 ** E ** 2, FactorNode.new(B_PI, ExponentOpToken.instance, F_TWO, ExponentOpToken.instance, F_E, ExponentOpToken.instance, F_TWO)
    end

    # tests that an epsilon term′ node get the correct value and type
    def DISABLED_test_epsilon_term_prime_node
      epsilon_two = TermPrimeNode.new
      epsilon_two.lhs_type = :integer
      epsilon_two.lhs_value = 2
      assert_integer_with_value 2, epsilon_two

      epsilon_pi = TermPrimeNode.new
      epsilon_pi.lhs_type = :decimal
      epsilon_pi.lhs_value = PI
      assert_decimal_with_value PI, epsilon_pi
    end

    # tests that a multiplication term′ node get the correct value and type
    def DISABLED_test_multiply_term_prime_node
      two_times = TermPrimeNode.new(MultiplyOpToken.instance, F_TWO, TermPrimeNode.new)
      e_times = TermPrimeNode.new(MultiplyOpToken.instance, F_E, TermPrimeNode.new)

      two_times_three = two_times
      two_times_three.lhs_type = :integer
      two_times_three.lhs_value = 3
      assert_integer_with_value 6, two_times_three

      two_times_pi = two_times
      two_times_pi.lhs_type = :decimal
      two_times_pi.lhs_value = PI
      assert_decimal_with_value 2 * PI, two_times_pi

      e_times_three = e_times
      e_times_three.lhs_type = :integer
      e_times_three.lhs_value = 3
      assert_decimal_with_value E * 3, e_times_three

      e_times_pi = e_times
      e_times_pi.lhs_type = :integer
      e_times_pi.lhs_value = PI
      assert_decimal_with_value E * PI, e_times_pi
    end

    # tests that a division term′ node get the correct value and type
    def DISABLED_test_divide_term_prime_node
      divided_by_two = TermPrimeNode.new(DivideOpToken.instance, F_TWO, TermPrimeNode.new)
      divided_by_e = TermPrimeNode.new(DivideOpToken.instance, F_E, TermPrimeNode.new)

      three_divided_by_two = divided_by_two
      three_divided_by_two.lhs_type = :integer
      three_divided_by_two.lhs_value = 3
      assert_integer_with_value 3 / 2, three_divided_by_two

      pi_divided_by_two = divided_by_two
      pi_divided_by_two.lhs_type = :decimal
      pi_divided_by_two.lhs_value = PI
      assert_decimal_with_value PI / 2, pi_divided_by_two

      three_divided_by_e = divided_by_e
      three_divided_by_e.lhs_type = :integer
      three_divided_by_e.lhs_value = 3
      assert_decimal_with_value 3 / E, three_divided_by_e

      pi_divided_by_e = divided_by_e
      pi_divided_by_e.lhs_type = :decimal
      pi_divided_by_e.lhs_value = PI
      assert_decimal_with_value PI / E, pi_divided_by_e
    end

    # tests that building a term node results in the correct value and type
    def DISABLED_test_term_node
      assert_integer_with_value 2, T_TWO
      assert_integer_with_value 3, T_THREE
      assert_decimal_with_value E, T_E
      assert_decimal_with_value PI, T_PI
    end

    # tests that an epsilon expression′ node get the correct value and type
    def DISABLED_test_epsilon_expression_prime_node
      epsilon_two = ExpressionPrimeNode.new
      epsilon_two.lhs_type = :integer
      epsilon_two.lhs_value = 2
      assert_integer_with_value 2, epsilon_two

      epsilon_pi = ExpressionPrimeNode.new
      epsilon_pi.lhs_type = :decimal
      epsilon_pi.lhs_value = PI
      assert_decimal_with_value PI, epsilon_pi
    end

    # tests that an addition expression′ node get the correct value and type
    def DISABLED_test_addition_expression_prime_node
      two_plus = ExpressionPrimeNode.new(AddOpToken.instance, T_TWO, ExpressionPrimeNode.new)
      e_plus = ExpressionPrimeNode.new(AddOpToken.instance, T_E, ExpressionPrimeNode.new)

      two_plus_three = two_plus
      two_plus_three.lhs_type = :integer
      two_plus_three.lhs_value = 3
      assert_integer_with_value 5, two_plus_three

      two_plus_pi = two_plus
      two_plus_pi.lhs_type = :decimal
      two_plus_pi.lhs_value = PI
      assert_decimal_with_value 2 + PI, two_plus_pi

      e_plus_three = e_plus
      e_plus_three.lhs_type = :integer
      e_plus_three.lhs_value = 3
      assert_decimal_with_value E + 3, e_plus_three

      e_plus_pi = e_plus
      e_plus_pi.lhs_type = :integer
      e_plus_pi.lhs_value = PI
      assert_decimal_with_value E + PI, e_plus_pi
    end

    # tests that a subtraction expression′ node get the correct value and type
    def DISABLED_test_subtraction_expression_prime_node
      two_minus = ExpressionPrimeNode.new(SubtractOpToken.instance, T_TWO, ExpressionPrimeNode.new)
      e_minus = ExpressionPrimeNode.new(SubtractOpToken.instance, T_E, ExpressionPrimeNode.new)

      two_minus_three = two_minus
      two_minus_three.lhs_type = :integer
      two_minus_three.lhs_value = 3
      assert_integer_with_value -1, two_minus_three

      two_minus_pi = two_minus
      two_minus_pi.lhs_type = :decimal
      two_minus_pi.lhs_value = PI
      assert_decimal_with_value 2 - PI, two_minus_pi

      e_minus_three = e_minus
      e_minus_three.lhs_type = :integer
      e_minus_three.lhs_value = 3
      assert_decimal_with_value E - 3, e_minus_three

      e_minus_pi = e_minus
      e_minus_pi.lhs_type = :integer
      e_minus_pi.lhs_value = PI
      assert_decimal_with_value E - PI, e_minus_pi
    end

    # tests that an expression′ node get the correct value and type
    def DISABLED_test_expression_node
      assert_integer_with_value 2, E_TWO
      assert_integer_with_value 3, E_THREE
      assert_decimal_with_value PI, E_PI
      assert_decimal_with_value E, E_E
    end

    # tests that a base node consisting of a parenthesised expression gets the
    # correct value and type
    def DISABLED_test_expression_base_node
      assert_integer_with_value 2, BaseNode.new(LeftParenthesisToken.instance, E_TWO, RightParenthesisToken.instance)
      assert_integer_with_value 3, BaseNode.new(LeftParenthesisToken.instance, E_THREE, RightParenthesisToken.instance)
      assert_decimal_with_value PI, BaseNode.new(LeftParenthesisToken.instance, E_PI, RightParenthesisToken.instance)
      assert_decimal_with_value E, BaseNode.new(LeftParenthesisToken.instance, E_E, RightParenthesisToken.instance)
    end

    private

    # assert that the given node is of an integer type and has the given value
    def assert_integer_with_value(value, node)
      assert_equal value, node.value
      assert_equal :integer, node.type
    end

    # assert that the given node is of an decimal type and has the given value
    def assert_decimal_with_value(value, node)
      assert_in_epsilon value, node.value
      assert_equal :decimal, node.type
    end
  end
end
