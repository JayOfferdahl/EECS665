%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int list_type;
%}

%option       noyywrap nounput yylineno
%x            COMMENT PARA LI

%%

"<h1>"[^<]*"</h1>" {
    /**************************************************************************
     * Matched an HTML H1 header so print it out as a LateX section title.
     * The beginning and ending tags need to be stripped off before the
     * title can be formatted in LateX.
     *************************************************************************/
    yytext[yyleng-5] = 0;
    printf( "\\section{%s}", yytext+4 );
}

"<h2>"[^<]*"</h2>" {
    /**************************************************************************
     * Matched an HTML H2 header so print it out as a LateX subsection title.
     * The beginning and ending tags need to be stripped off before the
     * title can be formatted in LateX.
     *************************************************************************/
    yytext[yyleng-5] = 0;
    printf( "\\subsection{%s}", yytext+4 );
}

"<h3>"[^<]*"</h3>" {
    /**************************************************************************
     * Matched an HTML H3 header so print it out as a LateX subsubsection title.
     * The beginning and ending tags need to be stripped off before the
     * title can be formatted in LateX.
     *************************************************************************/
    yytext[yyleng-5] = 0;
    printf( "\\subsubsection{%s}", yytext+4 );
}

"<pre>"[^<]*"</pre>" {
    /**************************************************************************
     * Matched an HTML pre header so print it out as a LateX verbatim title.
     * The beginning and ending tags need to be stripped off before the
     * title can be formatted in LateX.
     *************************************************************************/
    yytext[yyleng-6] = 0;
    printf( "\\begin{verbatim}%s\\end{verbatim}\n", yytext+5 );
}

"<p>" {
    BEGIN PARA;
}

"<ol>" {
    printf( "\\begin{enumerate}" );
    BEGIN LI;
}

"<ul>" {
    printf( "\\begin{itemize}" );
    BEGIN LI;
}

"<!--" {
    /**************************************************************************
     * Matched an HTML comment so print it out as a LateX comment. The
     * beginning and ending tags are stripped off before the LateX comment
     * is emitted.
     *************************************************************************/
    printf( "%% " );
    BEGIN COMMENT;
}

[ \t\n\r]+ {
    /**************************************************************************
     * Matched some whitespace that is not inside of an HTML tag. We
     * just ignore the whitespace.
     *************************************************************************/
}

. {
    /**************************************************************************
     * Matched something that we did not expect to see. Issue an error and
     * exit the program with a failure message.
     *************************************************************************/
    fprintf( stderr, "Unexpected input at line %d: '%s'\n", yylineno, yytext );
    exit( 1 );
}

<COMMENT>"-->" {
    /**************************************************************************
     * Matched an HTML end comment while parsing an HTML comment. Print out
     * a new line and resume normal parsing.
     *************************************************************************/
    printf( "\n" );
    BEGIN 0;
}

<COMMENT>[\n](\r)? {
    /**************************************************************************
     * Matched a newline and possible carriage return while parsing an HTML
     * comment. Print out a new line making sure to mark the next line as a
     * comment as well.
     *************************************************************************/
    printf( "\n%% " );
}

<COMMENT>[ \t] {
    /**************************************************************************
     * Matched some white space while parsing an HTML comment. Print out
     * the white space as is.
     *************************************************************************/
    printf( "%s", yytext );
}

<PARA>"</p>" {
    /**************************************************************************
     * Matched an HTML end p while parsing an HTML paragraph. Print out
     * a new line and resume paragraph parsing.
     *************************************************************************/
    printf( "\n\n" );
    BEGIN 0;
}

<LI>"<li>" {
    /**************************************************************************
     * Matched an HTML list item while parsing an HTML list. Print out
     * a new item tag and resume list parsing.
     *************************************************************************/
    printf( "\\item " );
}

<LI>"</li>" {
    /**************************************************************************
     * Matched an HTML end list item while parsing an HTML list. Print out
     * a new line and resume list parsing.
     *************************************************************************/
    printf( "\n" );
}

<LI>"</ol>" {
    /**************************************************************************
     * Matched an HTML end ordered list while parsing an HTML list. Print out
     * an end enumerate tag and print a new line and resume normal parsing.
     *************************************************************************/
    printf( "\\end{enumerate}\n" );
    BEGIN 0;
}

<LI>"</ul"> {
    /**************************************************************************
     * Matched an HTML end unordered list while parsing an HTML list. Print out
     * an end itemize tag and print a new line and resume normal parsing.
     *************************************************************************/
    printf( "\\end{itemize}\n" );
    BEGIN 0;
}

<PARA,LI>"<small>"[^<]*"</small>" {
    /**************************************************************************
     * Matched an HTML small while parsing an HTML paragraph. Print out
     * brackets around a scriptsize and resume paragraph/list parsing.
     *************************************************************************/
    yytext[yyleng-8] = 0;
    printf( "{\\scriptsize %s}", yytext+7 );
}

<PARA,LI>"<big>"[^<]*"</big>" {
    /**************************************************************************
     * Matched an HTML big while parsing an HTML paragraph/list. Print out
     * brackets around a Large and resume paragraph/list parsing.
     *************************************************************************/
    yytext[yyleng-6] = 0;
    printf( "{\\Large %s}", yytext+5 );
}

<PARA,LI>"<b>"[^<]*"</b>" {
    /**************************************************************************
     * Matched an HTML bold while parsing an HTML paragraph/list. Print out
     * a textbf and resume paragraph/list parsing.
     *************************************************************************/
    yytext[yyleng-4] = 0;
    printf( "\\textbf{%s}", yytext+3 );
}

<PARA,LI>"<i>"[^<]*"</i>" {
    /**************************************************************************
     * Matched an HTML end p while parsing an HTML paragraph/list. Print out
     * a textit and resume paragraph/list parsing.
     *************************************************************************/
    yytext[yyleng-4] = 0;
    printf( "\\textit{%s}", yytext+3 );
}

<PARA,LI>"<strong>"[^<]*"</strong>" {
    /**************************************************************************
     * Matched an HTML end p while parsing an HTML paragraph/list. Print out
     * a textmd and resume paragraph/list parsing.
     *************************************************************************/
    yytext[yyleng-9] = 0;
    printf( "\\textmd{%s}", yytext+8 );
}

<PARA,LI>"<em>"[^<]*"</em>" {
    /**************************************************************************
     * Matched an HTML end p while parsing an HTML paragraph/list. Print out
     * a emph and resume paragraph/list parsing.
     *************************************************************************/
    yytext[yyleng-5] = 0;
    printf( "\\emph{%s}", yytext+4 );
}

<PARA,LI>"<sup>"[^<]*"</sup>" {
    /**************************************************************************
     * Matched an HTML end p while parsing an HTML paragraph/list. Print out
     * a textsuperscript and resume paragraph/list parsing.
     *************************************************************************/
    yytext[yyleng-6] = 0;
    printf( "\\textsuperscript{%s}", yytext+5 );
}

<PARA,LI>"<sub>"[^<]*"</sub>" {
    /**************************************************************************
     * Matched an HTML end p while parsing an HTML paragraph/list. Print out
     * a textsubscript and resume paragraph/list parsing.
     *************************************************************************/
    yytext[yyleng-6] = 0;
    printf( "\\textsubscript{%s}", yytext+5 );
}

<COMMENT,PARA,LI>. {
    /**************************************************************************
     * Matched any other text while parsing an HTML comment, paragraph, or LI.
     * Print out the text as is.
     *************************************************************************/
    printf( "%s", yytext );
}

%%

/**************************************************************************
 * The main function for the HTML to LateX converter. Here we do three
 * things:
 *  1. Print out the LateX document header.
 *  2. Invoke the lexer to print out the LateX document
 *  3. Print out the LateX footer.
 *************************************************************************/
int main( int argc, const char *argv[] ) {
    printf( "\\documentclass[12pt]{article}\n" );
    printf( "\\usepackage{fixltx2e}\n" );
    printf( "\n" );
    printf( "\\setlength{\\parindent}{0.0in}\n" );
    printf( "\\setlength{\\parskip}{0.125in}\n" );
    printf( "\n\n" );
    printf( "\\begin{document}\n" );
    yylex();
    printf( "\\end{document}\n" );
    return 0;
}
