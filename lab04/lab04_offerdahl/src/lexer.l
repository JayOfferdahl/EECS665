%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

//Define the tokens that you want to return from your lex as follows
#define PREPROC     256
#define ID          257
#define INTVAL      258
#define FLTVAL      259
#define DBLVAL      260
#define STRVAL      261
#define CHARVAL     262
#define VOID        263
#define CHAR        264
#define SHORT       265
#define INT         266
#define LONG        267
#define FLOAT       268
#define DOUBLE      269
#define EQ          270
#define NE          271
#define GE          272
#define LE          273
#define GT          274
#define LT          275
#define ADD         276
#define SUB         277
#define MUL         278
#define DIV         279
#define MOD         280
#define OR          281
#define AND         282
#define BITOR       283
#define BITAND      284
#define BITXOR      285
#define NOT         286
#define COM         287
#define LSH         288
#define RSH         289
#define SET         290
#define SETADD      291
#define SETSUB      292
#define SETMUL      293
#define SETDIV      294
#define SETMOD      295
#define SETOR       296
#define SETAND      297
#define SETXOR      298
#define SETLSH      299
#define SETRSH      300
#define RETURN      301
#define DO          302
#define WHILE       303
#define FOR         304
#define SWITCH      305
#define CASE        306
#define DEFAULT     307
#define IF          308
#define ELSE        309
#define CONTINUE    310
#define BREAK       311
#define GOTO        312
#define UNSIGNED    313
#define TYPEDEF     314
#define STRUCT      315
#define UNION       316
#define CONST       317
#define STATIC      318
#define EXTERN      319
#define AUTO        320
#define REGISTER    321
#define SIZEOF      322

int list_type;
%}

%option noyywrap nounput yylineno
ID [a-zA-Z][a-zA-Z0-9_]*
PREPROC ^"#".*
INTVAL [a-fA-F0-9]*
FLTVAL [0-9]*"."[0-9]*"f"
DBLVAL [0-9]*"."[0-9]*
STRVAL "\""[^\"]*"\""
CHARVAL "\'"(.|"\\".)"\'"
%x COMMENT MULTICOMMENT

%%

"//" {
    /**
     * Matching single line comments
     */
    BEGIN COMMENT;
}
"/*" {
    /**
     * Matching multi-line comments
     */
    BEGIN MULTICOMMENT;
}
<COMMENT>[\n](\r)? {
    /**
     * A newline (or newline with carriage return) ends the
     * single line comment
     */
    BEGIN 0;
}
<MULTICOMMENT>"*/" {
    /** 
     * A multi-line comment ends on "\*\/"
     */
    BEGIN 0;
}
<MULTICOMMENT>[\n] {
    /**
     * Do nothing for a newline inside a multi-line comment
     */
}
<COMMENT,MULTICOMMENT>. {
    /** 
     * Ignore characters inside a comment/multi-line comment
     */
}



{PREPROC} {
    /**
     * If the line starts with "#", print PREPROC and return 
     * the defined token PREPROC
     */
    printf("PREPROC\n");
    return PREPROC;
}



"(" {
    /**
     * If "(" is found, print it and return the same character.
     */
    printf("(\n");
    return '(';
}
")" {
    /**
     * If ")" is found, print it and return the same character.
     */
    printf(")\n");
    return ')';
}
"{" {
    /**
     * If "{" is found, print it and return the same character.
     */
    printf("{\n");
    return '{';
}
"}" {
    /**
     * If "}" is found, print it and return the same character.
     */
    printf("}\n");
    return '}';
}
"[" {
    /**
     * If "[" is found, print it and return the same character.
     */
    printf("[\n");
    return '[';
}
"]" {
    /**
     * If "]" is found, print it and return the same character.
     */
    printf("]\n");
    return ']';
}
"," {
    /**
     * If "," is found, print it and return the same character.
     */
    printf(",\n");
    return ',';
}
";" {
    /**
     * If ";" is found, print it and return the same character.
     */
    printf(";\n");
    return ';';
}



"void" {
    /**
     * If void is found, print it in uppercase and return its token.
     */
    printf("VOID\n");
    return VOID;
}
"char" {
    /**
     * If char is found, print it in uppercase and return its token.
     */
    printf("CHAR\n");
    return CHAR;
}
"short" {
    /**
     * If short is found, print it in uppercase and return its token.
     */
    printf("SHORT\n");
    return SHORT;
}
"int" {
    /**
     * If int is found, print it in uppercase and return its token.
     */
    printf("INT\n");
    return INT;
}
"long" {
    /**
     * If long is found, print it in uppercase and return its token.
     */
    printf("LONG\n");
    return LONG;
}
"float" {
    /**
     * If float is found, print it in uppercase and return its token.
     */
    printf("FLOAT\n");
    return FLOAT;
}
"double" {
    /**
     * If double is found, print it in uppercase and return its token.
     */
    printf("DOUBLE\n");
    return DOUBLE;
}


"==" {
    /**
     * If "==" is found, print "EQ" and return the corresponding token.
     */
    printf("EQ\n");
    return EQ;
}
"!=" {
    /**
     * If "!=" is found, print "NE" and return the corresponding token.
     */
    printf("NE\n");
    return NE;
}
">=" {
    /**
     * If ">=" is found, print "GE" and return the corresponding token.
     */
    printf("GE\n");
    return GE;
}
"<=" {
    /**
     * If "<=" is found, print "LE" and return the corresponding token.
     */
    printf("LE\n");
    return LE;
}
">" {
    /**
     * If ">" is found, print "GT" and return the corresponding token.
     */
    printf("GT\n");
    return GT;
}
"<" {
    /**
     * If "<" is found, print "LT" and return the corresponding token.
     */
    printf("LT\n");
    return LT;
}
"+" {
    /**
     * If "+" is found, print "ADD" and return the corresponding token.
     */
    printf("ADD\n");
    return ADD;
}
"-" {
    /**
     * If "-" is found, print "SUB" and return the corresponding token.
     */
    printf("SUB\n");
    return SUB;
}
"*" {
    /**
     * If "*" is found, print "MUL" and return the corresponding token.
     */
    printf("MUL\n");
    return MUL;
}
"/" {
    /**
     * If "/" is found, print "DIV" and return the corresponding token.
     */
    printf("DIV\n");
    return DIV;
}
"%" {
    /**
     * If "%" is found, print "MOD" and return the corresponding token.
     */
    printf("MOD\n");
    return MOD;
}
"||" {
    /**
     * If "||" is found, print "OR" and return the corresponding token.
     */
    printf("OR\n");
    return OR;
}
"&&" {
    /**
     * If "&&" is found, print "AND" and return the corresponding token.
     */
    printf("AND\n");
    return AND;
}
"|" {
    /**
     * If "|" is found, print "BITOR" and return the corresponding token.
     */
    printf("BITOR\n");
    return BITOR;
}
"&" {
    /**
     * If "&" is found, print "BITAND" and return the corresponding token.
     */
    printf("BITAND\n");
    return BITAND;
}
"^" {
    /**
     * If "^" is found, print "BITXOR" and return the corresponding token.
     */
    printf("BITXOR\n");
    return BITXOR;
}
"!" {
    /**
     * If "!" is found, print "NOT" and return the corresponding token.
     */
    printf("NOT\n");
    return NOT;
}
"~" {
    /**
     * If "~" is found, print "COM" and return the corresponding token.
     */
    printf("COM\n");
    return COM;
}
"<<" {
    /**
     * If "<<" is found, print "LSH" and return the corresponding token.
     */
    printf("LSH\n");
    return LSH;
}
">>" {
    /**
     * If ">>" is found, print "RSH" and return the corresponding token.
     */
    printf("RSH\n");
    return RSH;
}
"=" {
    /**
     * If "=" is found, print "SET" and return the corresponding token.
     */
    printf("SET\n");
    return SET;
}
"+=" {
    /**
     * If "+=" is found, print "SETADD" and return the corresponding token.
     */
    printf("SETADD\n");
    return SETADD;
}
"-=" {
    /**
     * If "-=" is found, print "SETSUB" and return the corresponding token.
     */
    printf("SETSUB\n");
    return SETSUB;
}
"*=" {
    /**
     * If "*=" is found, print "SETMUL" and return the corresponding token.
     */
    printf("SETMUL\n");
    return SETMUL;
}
"/=" {
    /**
     * If "/=" is found, print "SETDIV" and return the corresponding token.
     */
    printf("SETDIV\n");
    return SETDIV;
}
"%=" {
    /**
     * If "%=" is found, print "SETMOD" and return the corresponding token.
     */
    printf("SETMOD\n");
    return SETMOD;
}
"|=" {
    /**
     * If "|=" is found, print "SETOR" and return the corresponding token.
     */
    printf("SETOR\n");
    return SETOR;
}
"&=" {
    /**
     * If "&=" is found, print "SETAND" and return the corresponding token.
     */
    printf("SETAND\n");
    return SETAND;
}
"^=" {
    /**
     * If "^=" is found, print "SETXOR" and return the corresponding token.
     */
    printf("SETXOR\n");
    return SETXOR;
}
"<<=" {
    /**
     * If "<<=" is found, print "SETLSH" and return the corresponding token.
     */
    printf("SETLSH\n");
    return SETLSH;
}
">>=" {
    /**
     * If ">>=" is found, print "SETRSH" and return the corresponding token.
     */
    printf("SETRSH\n");
    return SETRSH;
}



"return" {
    /**
     * If "return" is found, print "RETURN" and return its corresponding token.
     */
    printf("RETURN\n");
    return RETURN;
}
"do" {
    /**
     * If "do" is found, print "DO" and return its corresponding token.
     */
    printf("DO\n");
    return DO;
}
"while" {
    /**
     * If "while" is found, print "WHILE" and return its corresponding token.
     */
    printf("WHILE\n");
    return WHILE;
}
"for" {
    /**
     * If "for" is found, print "FOR" and return its corresponding token.
     */
    printf("FOR\n");
    return FOR;
}
"switch" {
    /**
     * If "switch" is found, print "SWITCH" and return its corresponding token.
     */
    printf("SWITCH\n");
    return SWITCH;
}
"case" {
    /**
     * If "case" is found, print "CASE" and return its corresponding token.
     */
    printf("CASE\n");
    return CASE;
}
"default" {
    /**
     * If "default" is found, print "DEFAULT" and return its corresponding token.
     */
    printf("DEFAULT\n");
    return DEFAULT;
}
"if" {
    /**
     * If "if" is found, print "IF" and return its corresponding token.
     */
    printf("IF\n");
    return IF;
}
"else" {
    /**
     * If "else" is found, print "ELSE" and return its corresponding token.
     */
    printf("ELSE\n");
    return ELSE;
}
"continue" {
    /**
     * If "continue" is found, print "CONTINUE" and return its corresponding token.
     */
    printf("CONTINUE\n");
    return CONTINUE;
}
"break" {
    /**
     * If "break" is found, print "BREAK" and return its corresponding token.
     */
    printf("BREAK\n");
    return BREAK;
}
"goto" {
    /**
     * If "goto" is found, print "GOTO" and return its corresponding token.
     */
    printf("GOTO\n");
    return GOTO;
}


"unsigned" {
    /**
     * If "unsigned" is found, print "UNSIGNED" and return its corresponding token.
     */
    printf("UNSIGNED\n");
    return UNSIGNED;
}
"typedef" {
    /**
     * If "typedef" is found, print "TYPEDEF" and return its corresponding token.
     */
    printf("TYPEDEF\n");
    return TYPEDEF;
}
"struct" {
    /**
     * If "struct" is found, print "STRUCT" and return its corresponding token.
     */
    printf("STRUCT\n");
    return STRUCT;
}
"union" {
    /**
     * If "union" is found, print "UNION" and return its corresponding token.
     */
    printf("UNION\n");
    return UNION;
}
"const" {
    /**
     * If "const" is found, print "CONST" and return its corresponding token.
     */
    printf("CONST\n");
    return CONST;
}
"static" {
    /**
     * If "static" is found, print "STATIC" and return its corresponding token.
     */
    printf("STATIC\n");
    return STATIC;
}
"extern" {
    /**
     * If "extern" is found, print "EXTERN" and return its corresponding token.
     */
    printf("EXTERN\n");
    return EXTERN;
}
"auto" {
    /**
     * If "auto" is found, print "AUTO" and return its corresponding token.
     */
    printf("AUTO\n");
    return AUTO;
}
"register" {
    /**
     * If "register" is found, print "REGISTER" and return its corresponding token.
     */
    printf("REGISTER\n");
    return REGISTER;
}
"sizeof" {
    /**
     * If "sizeof" is found, print "SIZEOF" and return its corresponding token.
     */
    printf("SIZEOF\n");
    return SIZEOF;
}


{ID} {
    /**
     * If an identifier is matched, print "ID" and return its corresponding token.
     */
    printf("ID\n");
    return ID;
}



{INTVAL} {
    /**
     * If a C literal INTVAL value is found, print "INTVAL" and return the corresponding token.
     */
    printf("INTVAL\n");
    return INTVAL;
}

{FLTVAL} {
    /**
     * If a C literal FLTVAL value is found, print "FLTVAL" and return the corresponding token.
     */
    printf("FLTVAL\n");
    return FLTVAL;
}

{DBLVAL} {
    /**
     * If a C literal DBLVAL value is found, print "DBLVAL" and return the corresponding token.
     */
    printf("DBLVAL\n");
    return DBLVAL;
}

{STRVAL} {
    /**
     * If a C literal STRVAL value is found, print "STRVAL" and return the corresponding token.
     */
    printf("STRVAL\n");
    return STRVAL;
}

{CHARVAL} {
    /**
     * If a C literal CHARVAL value is found, print "CHARVAL" and return the corresponding token.
     */
    printf("CHARVAL\n");
    return CHARVAL;
}


[ \t\n\r] {
    /** 
     * Reduce any whitespace that is found.
     */
}

%%

/**************************************************************************
 * Make a call to yylex() recursively. Whenever yylex() is called, it scans
 * tokens from the global input file yyin (which defaults to stdin). It
 * continues until it either reaches an end-of-file (at which point it
 * returns the value 0) or one of its actions executes a return statement.
 *************************************************************************/
int main(int argc, const char* argv[]) {

    // Scan the input file until yylex determines it reaches end of file
    while(yylex() != 0) {}

    return 0;
}
