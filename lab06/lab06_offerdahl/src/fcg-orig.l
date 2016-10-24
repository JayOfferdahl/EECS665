%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <fcg.yacc.h>

#ifndef NDEBUG
#    define DEBUGF(...) printf(__VA_ARGS__)
#else
#    define DEBUGF(...)
#endif
%}

%option       noyywrap nounput yylineno
%x            COMMENT

whitesp       [ \t\n\r]
nonwhitesp    [^ \t\n\r]
ident         [a-zA-Z][a-zA-Z0-9_]*
digit         [0-9]
hexdigit      [0-9a-fA-F]
octdigit      [0-7]

%%

%{ 
 /**************************************************************************
  * Scan miscellaneous C punctuation. 
  *************************************************************************/
%}

"("         { DEBUGF( "(\n" ); return '('; }
")"         { DEBUGF( ")\n" ); return ')'; }
"{"         { DEBUGF( "{\n" ); return '{'; }
"}"         { DEBUGF( "}\n" ); return '}'; }
"["         { DEBUGF( "[\n" ); return '['; }
"]"         { DEBUGF( "]\n" ); return ']'; }
","         { DEBUGF( ",\n" ); return ','; }
";"         { DEBUGF( ";\n" ); return ';'; }

%{ 
 /**************************************************************************
  * Scan C identifiers.
  *************************************************************************/
%}

{ident}         { DEBUGF( "ID\n" ); yylval.id = strdup(yytext); return ID; }

%{ 
 /**************************************************************************
  * Scan C literal values including strings, character literals, integer
  * literals, and floating point literals.
  *************************************************************************/
%}

"0x"{hexdigit}+ { DEBUGF( "INTVAL\n" ); return INTVAL; }
"0"{octdigit}*  { DEBUGF( "INTVAL\n" ); return INTVAL; }
[1-9]{digit}*   { DEBUGF( "INTVAL\n" ); return INTVAL; }

%{
 /**************************************************************************
  * Scan a multi-line C comment using left context or a C single line
  * comment to the end of the line.
  *************************************************************************/
%}

"//".*                      { /* ignored */ }

"/*"                        { BEGIN COMMENT; }
<COMMENT>"*/"               { BEGIN 0; }
<COMMENT>([\n](\r)?)|.      { /* ignored */ } 

%{
 /**************************************************************************
  * Scan white space in-between tokens and ignore it.
  *************************************************************************/
%}

{whitesp}+ { /* ignored */  }

%{
 /**************************************************************************
  * Anything else that matches is unexpected so print an error.
  *************************************************************************/
%}

. {
    fprintf( stderr, "Unexpected input at line %d: '%s'\n", yylineno, yytext );
    exit( 1 );
}
