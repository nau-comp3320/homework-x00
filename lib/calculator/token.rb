require 'singleton'

module Calculator
  # Main superclass for all tokens.
  #
  # == Numeric literal tokens
  #
  # Both IntegerToken and DecimalToken are used to represent numeric literals.
  #
  # == Operator tokens
  #
  # As operator tokens, such as AddOpToken, are stateless.  They are
  # singletons.  Instead of calling <tt>new</tt>, use <tt>instance</tt>.
  #
  class Token
    # The lexeme represented by this token
    attr_reader :lexeme

    # Initializes the token with the given lexeme
    def initialize(lexeme)
      @lexeme = lexeme
    end

    # Two Tokens are equal if they are of the same class.
    def ==(rhs)
      self.class == rhs.class && self.lexeme == rhs.lexeme
    end
  end

  # Represents a numeric literal token
  class NumberToken < Token
    # The value of the numeric literal
    attr_reader :value, :type

    # Creates a new NumberToken with the given value
    def initialize(value, type)
      super(value.to_s)
      @value = value
      @type = type
    end

    # A NumberToken is equal to another object only if they are both
    # NumberTokens with the same value
    def ==(rhs)
      self.class == rhs.class && @value == rhs.value
    end

    # Returns a string representing the NumberToken
    def to_s
      "'#{value.to_s}'"
    end
  end

  # Represents an integer literal
  class IntegerToken < NumberToken
    # Creates a new integer token with the given lexeme
    def initialize(lex)
      super(lex.to_i, :integer)
    end
  end

  # Represents a decimal literal
  class DecimalToken < NumberToken
    # Creates a new decimal token with the given lexeme
    def initialize(lex)
      super(lex.to_f, :decimal)
    end
  end

  # A comman parent class for all operator tokens
  class OpToken < Token
    # Creates a new operator token with the given lexeme
    def initialize(lexeme)
      super(lexeme)
    end

    # returns the lexeme
    def to_s
      "'#{lexeme}'"
    end
  end

  # Represents the <tt>+</tt> token
  class AddOpToken < OpToken
    include Singleton

    # Uses <tt>+</tt> as the lexeme
    def initialize
      super('+')
    end
  end

  # Represents the <tt>-</tt> token
  class SubtractOpToken < OpToken
    include Singleton

    # Uses <tt>-</tt> as the lexeme
    def initialize
      super('-')
    end
  end

  # Represents the <tt>*</tt> token
  class MultiplyOpToken < OpToken
    include Singleton

    # Uses <tt>*</tt> as the lexeme
    def initialize
      super('*')
    end
  end

  # Represents the <tt>/</tt> token
  class DivideOpToken < OpToken
    include Singleton

    # Uses <tt>/</tt> as the lexeme
    def initialize
      super('/')
    end
  end

  # Represents the <tt>^</tt> token
  class ExponentOpToken < OpToken
    include Singleton

    # Uses <tt>^</tt> as the lexeme
    def initialize
      super('^')
    end
  end

  # Represents the <tt>(</tt> token
  class LeftParenthesisToken < OpToken
    include Singleton

    # Uses <tt>(</tt> as the lexeme
    def initialize
      super('(')
    end
  end

  # Represents the <tt>)</tt> token
  class RightParenthesisToken < OpToken
    include Singleton

    # Uses <tt>)</tt> as the lexeme
    def initialize
      super(')')
    end
  end
end
