/*
 * Format string with named arguments.
 * 
 * Author: Isaac Luiz Vieira Ferreira <isaacluizvieiraferreira@id.uff.br>
 * License: MIT
 * 
 * Usage:
 * 
 * Formatter.format('Hello, {name}!', new Map<String, String> {
 *     'name' => 'World!'
 * });
 */

public class Formatter {
    private final static Integer NEW_LINE_CHAR = 10;
    private final static Integer OPEN_BRACE_CHAR = 123;
    private final static Integer CLOSE_BRACE_CHAR = 125;
    
    private static Boolean isNewLine (Integer ch) {
        return ch == NEW_LINE_CHAR;
    }
    
    private static Boolean isOpenBrace (Integer ch) {
        return ch == OPEN_BRACE_CHAR;
    }
    
    private static Boolean isCloseBrace (Integer ch) {
        return ch == CLOSE_BRACE_CHAR;
    }
    
    public static Tokens prepare (String source) {
        Lexer lexer = new Lexer(source);
        
        return lexer.run();
    }
    
    public static String compile (Tokens tokens, Map<String, Object> arguments) {
        Compiler compiler = new Compiler(tokens, arguments);
        
        return compiler.run();
    }
    
    public static String format (String source, Map<String, Object> arguments) {
        Tokens tokens = prepare(source);
        
       return compile(tokens, arguments);
    }
    
    public class FormatterException extends Exception {}
    
    public class Tokens {
        private List<Token> tokens = new List<Token>();
        
        private void add (Token token) {
            tokens.add(token);
        }

        private List<Token> all () {
            return tokens;
        }        
    }
    
    private interface Arguments {
        Object getArgument (String argument);
    }

    private interface Token {
        Object getValue (Arguments arguments);
    }
    
    private class LiteralToken implements Token {
        private String value;
        
        private LiteralToken (String value) {
            this.value = value;
        }
        
        public String getValue (Arguments arguments) {
            return value;
        }
    }
    
    private class VariableToken implements Token {
        private String name;
        
        private VariableToken (String name) {
            this.name = name;
        }
        
        public Object getValue (Arguments arguments) {
            return arguments.getArgument(name);
        }
    }
    
    private class Lexer {
        private Integer offset = 0;
        
        private Integer line = 1;
        private Integer column = 1;
        
        private String source;
        
        private Lexer (String source) {
            this.source = source;
        }
        
        private void advance () {            
            if (isNewLine(peek())) {
                line = 1;
                column += 1;
            } else {
                line += 1;
            }
            
            offset += 1;
        }
        
        private Integer peek () {
            return source.charAt(offset);
        }
        
        private Boolean finished () {
            return offset >= source.length();
        }
        
        private String span (Integer startOffset, Integer endOffset) {
            return source.substring(startOffset, endOffset);
        }
                
        private Token token () {
            if (isCloseBrace(peek())) {
                throw new FormatterException('Unexpected close brace at ' + column + ':' + line + '.');
            }
            
            if (isOpenBrace(peek())) {
                advance();
                
                Integer startOffset = offset;
                
                if (finished() || isCloseBrace(peek())) {
                    throw new FormatterException('Expected argument at ' + column + ':' + line + '.');
                }
                                
                while (!finished() && !isOpenBrace(peek()) && !isCloseBrace(peek())) {
                    advance();
                }
                
                if (finished() || !isCloseBrace(peek())) {
                    throw new FormatterException('Expected close brace at ' + column + ':' + line + '.');
                }
                
                Integer endOffset = offset;
                
                advance();
                
                return new VariableToken(
                    span(startOffset, endOffset)
                );
            } else {
                Integer startOffset = offset;
                
                while (!finished() && !isOpenBrace(peek()) && !isCloseBrace(peek())) {                    
                    advance();
                }
                
                Integer endOffset = offset;
                
                return new LiteralToken(
                    span(startOffset, endOffset)
                );
            }    
        }
        
        private Tokens run () {
            Tokens tokens = new Tokens();
            
            while (!finished()) {                
               tokens.add(token());
            }           
            
            return tokens;
        }
    }
    
    private class StringBuilder {
        private String output = '';
        
        private void add (Object slice) {
            output += slice;
        }
        
        private String build () {
            return output;
        }
    }
    
    private class Compiler implements Arguments {
        private Tokens tokens;
        private Map<String, Object> arguments;
        
        private Compiler (Tokens tokens, Map<String, Object> arguments) {
            this.tokens = tokens;
            this.arguments = arguments;
        }
        
        public Object getArgument (String name) {
            Object value = arguments.get(name);
            
            if (value == null) {
                throw new FormatterException('Argument `' + name + '` is null.');
            }
            
            return value;
        }
        
        private String run () {
            StringBuilder builder = new StringBuilder();
        
            for (Token token : tokens.all()) {
                builder.add(token.getValue(this));
            }
            
            return builder.build();
        }
    }
}