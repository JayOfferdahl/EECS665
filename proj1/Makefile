all: nfa2dfa

nfa2dfa: main.o
	g++ -g -std=c++11 main.o -o nfa2dfa

main.o: main.cpp
	g++ -g -std=c++11 -c main.cpp

test: nfa2dfa
	./nfa2dfa < input.txt

clean:
	$(RM) *.o *.exe nfa2dfa

.PHONY: clean all test