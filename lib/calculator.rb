require_relative 'calculator/lexer'
require_relative 'calculator/parser'

# A  simple Ruby module used to show how to build a lexical analyser and
# recursive-descent parser.
#
# == Primary classes
#
# The primary classes for this package are:
#
# Lexer::
#   The implementation of the lexical analyser as a DFA.
# Parser::
#   The implementation of the syntax analyser using a recursive-descent
#   algorithm.
#
# == Helper classes
#
# Token::
#   The parent class for all lexical tokens.
# ASTNode::
#   The parent class for all nodes in the generated parse tree.
# SyntaxError::
#   Exception type to be thrown whenever lexing or parsing fails.
#
# == Test classes
#
# LexerTest::
#   Provides tests for the Lexer.
# ParserTest::
#   Provides tests for the Parser.
#
module Calculator
  # Runs the lexer and parser interactively
  def self.run
    loop do
      print '>> '
      input = $stdin.gets
      break unless input
      begin
        lexer = Lexer.new(input.chomp)
        puts 'Lexer output:'
        puts '  ' + lexer.to_a.join(',')
        parser = Parser.new(lexer)
        puts 'Parser output:'
        parser.tree.print_tree('  ')
        puts "value: #{parser.tree.value}"
        puts "type: #{parser.tree.type}"
      rescue SyntaxError => e
        puts "  Got a syntax error: #{e.message}"
      end
    end
  end
end
