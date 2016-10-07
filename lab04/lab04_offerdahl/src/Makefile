LEX=lex
YACC=yacc
CC=gcc

LFLAGS=
CFLAGS=-Wall -Wno-unused-label -Wno-unused -g

all: lexer

lexer: lexer.lex.o
	$(CC) -o $@ $+

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.lex.c: %.l
	$(LEX) $(LFLAGS) -o $@ $<
	
%.txt: %.c lexer
	./lexer < $<

test: lexer test.txt

clean:
	$(RM) *.o
	$(RM) *.lex.c
	$(RM) lexer

.PHONY: clean all test
