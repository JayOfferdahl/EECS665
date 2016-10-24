%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <fcg.yacc.h>

#ifndef NDEBUG
#    define DEBUGF(...) DEBUGF(__VA_ARGS__)
#else
#    define DEBUGF(...)
#endif

int list_type;
%}

%option noyywrap nounput yylineno
ID [a-zA-Z][a-zA-Z0-9_]*
INTVAL [a-fA-F0-9]*
FLTVAL [0-9]*"."[0-9]*"f"
DBLVAL [0-9]*"."[0-9]*
STRVAL "\""[^\"]*"\""
CHARVAL "\'"(.|"\\".)"\'"
%x COMMENT MULTICOMMENT

%%

"//" { BEGIN COMMENT; }
"/*" { BEGIN MULTICOMMENT; }
<COMMENT>[\n](\r)? { BEGIN 0; }
<MULTICOMMENT>"*/" { BEGIN 0; }
<MULTICOMMENT>[\n] {}
<COMMENT,MULTICOMMENT>. {}

"("         { DEBUGF("(\n");        return '('; }
")"         { DEBUGF(")\n");        return ')'; }
"{"         { DEBUGF("{\n");        return '{'; }
"}"         { DEBUGF("}\n");        return '}'; }
"["         { DEBUGF("[\n");        return '['; }
"]"         { DEBUGF("]\n");        return ']'; }
","         { DEBUGF(",\n");        return ','; }
";"         { DEBUGF(";\n");        return ';'; }

"void"      { DEBUGF("VOID\n");     return VOID; }
"char"      { DEBUGF("CHAR\n");     return CHAR; }
"short"     { DEBUGF("SHORT\n");    return SHORT; }
"int"       { DEBUGF("INT\n");      return INT; }
"long"      { DEBUGF("LONG\n");     return LONG; }
"float"     { DEBUGF("FLOAT\n");    return FLOAT; }
"double"    { DEBUGF("DOUBLE\n");   return DOUBLE; }

"=="        { DEBUGF("EQ\n");       return EQ; }
"!="        { DEBUGF("NE\n");       return NE; }
">="        { DEBUGF("GE\n");       return GE; }
"<="        { DEBUGF("LE\n");       return LE; }
">"         { DEBUGF("GT\n");       return GT; }
"<"         { DEBUGF("LT\n");       return LT; }
"+"         { DEBUGF("ADD\n");      return ADD; }
"-"         { DEBUGF("SUB\n");      return SUB; }
"*"         { DEBUGF("MUL\n");      return MUL; }
"/"         { DEBUGF("DIV\n");      return DIV; }
"%"         { DEBUGF("MOD\n");      return MOD; }
"|"         { DEBUGF("BITOR\n");    return BITOR; }
"&"         { DEBUGF("BITAND\n");   return BITAND; }
"^"         { DEBUGF("BITXOR\n");   return BITXOR; }
"<<"        { DEBUGF("LSH\n");      return LSH; }
">>"        { DEBUGF("RSH\n");      return RSH; }
"="         { DEBUGF("SET\n");      return SET; }

"return"    { DEBUGF("RETURN\n");   return RETURN; }
"while"     { DEBUGF("WHILE\n");    return WHILE; }
"if"        { DEBUGF("IF\n");       return IF; }
"else"      { DEBUGF("ELSE\n");     return ELSE; }

{ID}        { DEBUGF("ID\n");       yylval.id = strdup(yytext); return ID; }
{INTVAL}    { DEBUGF("INTVAL\n");   return INTVAL; }
{FLTVAL}    { DEBUGF("FLTVAL\n");   return FLTVAL; }
{DBLVAL}    { DEBUGF("DBLVAL\n");   return DBLVAL; }
{STRVAL}    { DEBUGF("STRVAL\n");   return STRVAL; }
{CHARVAL}   { DEBUGF("CHARVAL\n");  return CHARVAL; }

[ \t\n\r] {}
%%