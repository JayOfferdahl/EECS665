// The name of the grammar. The name here needs to match the name of the
// file, including capitalization.
grammar Lab5;

// Define literals, keywords or operators, here as tokens.
tokens {
    ADD = '+';
    SUB = '-';
    MUL = '*';
    DIV = '/';
    EXP = '^';
    LPA = '(';
    RPA = ')';
    LOG = 'log';
    SIN = 'sin';
    COS = 'cos';
    TAN = 'tan';
}

// Written in the target language. The header section can be
// used to import any Java classes that may be required.
@header {
    import java.lang.Math;
}

// A main function to the parser. This function will setup the
// parsers input stream and execute the rule named "top".
@members {
    public static void main(String[] args) throws Exception {
        Lab5Lexer lex = new Lab5Lexer(new ANTLRInputStream(System.in));
       	CommonTokenStream tokens = new CommonTokenStream(lex);
        Lab5Parser parser = new Lab5Parser(tokens);

        try {
            parser.top();
        } catch (RecognitionException e)  {
            e.printStackTrace();
        }
    }
}

// Some example lexer fragments. These fragments don't produce any
// tokens themselves but can be used inside of other lexer rules.
fragment BIN: '0' .. '1';
fragment OCT: '0' .. '7';
fragment DEC: '0' .. '9';
fragment HEX: ('0' .. '9' | 'A' .. 'F' | 'a' .. 'f');

// The white space lexer rule. Match any number of white space characters
// and hide the results from the parser.
WS : (' ' | '\t' | '\r' | '\n')+ { $channel=HIDDEN; };

// The decimal value lexer rule. Match one or more decimal digits.
BINARY      : '0b' BIN+;
OCTAL       : '0' OCT+;
DECIMAL     : DEC+;
HEXIDECIMAL : '0x' HEX+;
REAL        : DECIMAL '.' DECIMAL;

// The top rule. You should replace this with your own rule definition to
// parse expressions according to the assignment.
top : expr EOF | EOF;

expr : result = auntSally { System.out.println($result.value); };

auntSally returns [double value]
    :      left = myDear { $value = $left.value; }
    ( ADD right = myDear { $value += $right.value; }
    | SUB right = myDear { $value -= $right.value; })*;

myDear returns [double value]
    :      left = excuse { $value = $left.value; }
    ( MUL right = excuse { $value *= $right.value; }
    | DIV right = excuse { 
        if($right.value == 0) {
            System.out.println("Error: Attempted divide by zero. Returning 0.");
            $value = 0;
        }
        else
            $value /= $right.value; })*;

excuse returns [double value]
    :      left = please { $value = $left.value; }
    ( EXP right = please { $value = (double) Math.pow($left.value, $right.value); })*;

please returns [double value]
    : LPA left = auntSally RPA { $value = $left.value; }
    | left = logTrig { $value = $left.value; }
    | left = term { $value = $left.value; };

logTrig returns [double value]
    : LOG left = please { $value = Math.log($left.value); }
    | SIN left = please { $value = Math.sin($left.value); }
    | COS left = please { $value = Math.cos($left.value); }
    | TAN left = please { $value = Math.tan($left.value); };

term returns [double value]
    : result = BINARY { 
        String str = $result.getText();
        $value = (double) Integer.parseInt(str.substring(2), 2); }
    | result = OCTAL {
        String str = $result.getText();
        $value = (double) Integer.parseInt(str.substring(1), 8); }
    | result = REAL { $value = Double.parseDouble($result.getText()); }
    | result = DECIMAL { $value = Double.parseDouble($result.getText()); }
    | result = HEXIDECIMAL {
        String str = $result.getText();
        $value = (double) Integer.parseInt(str.substring(2), 16); };