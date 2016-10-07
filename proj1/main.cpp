///////////////////////////////////////////////////////////////////////////////////////////////////
///
///     Program:    nfa2dfa
///     Class:      Compiler Construction (EECS 665)
///     Author:     Jay Offerdahl
///     Lab Time:   4:00pm - 5:50pm, Friday
///     Desc.:      Converts an input NFA to DFA by capturing the initial/final states of the NFA,
///                 as well as the transitions (including epsilon transitions) taken by the states.
///
///////////////////////////////////////////////////////////////////////////////////////////////////

#include <iostream>
#include <sstream>

#include <queue>
#include <set>
#include <unordered_map>
#include <vector>

using namespace std;

/**
 * Removes the '{' '}' characters from a the input string --> A copy is made
 * from substr(), but is fed directly back into the referenced string.
 * @param line - the input string to be trimmed
 * @post       - param line is set to the new string
 */
void trimBrackets(string &line) {
    line = line.substr(line.find("{") + 1, line.find("}") - line.find("{") - 1);
}

/**
 * Tokenizes a string in the format using commas as deliminators, for example,
 * input {1,3,9,2} would be returned as a set containing 1, 2, 3, and 9.
 * @param line - the input string to be tokenized
 * @return     - a list of the tokens extracted
 */
set<int> strTok(string line) {
    set<int> result;
    int temp;

    while(!line.empty()) {
        if(line.find(",") != string::npos) {
            temp = stoi(line.substr(line.find_last_of(",") + 1));
            line.erase(line.find_last_of(","));
        }
        else {
            temp = stoi(line);
            line = "";
        }

        result.insert(temp);
    }
    return result;
}

/**
 * Prints the contents of an set containing integers as comma separated tokens
 * @param s - the set to be printed
 */
void print(set<int> s) {
    int i = 0;
    for(int state : s) {
        cout << state;
        if(i != s.size() - 1)
            cout << ",";
        i++;
    }
}

/**
 * Calculates the set of states that can be obtained from the input symbol 'input'
 * @param transitions   - the transition matrix of the nfa
 * @param states        - the input state to be visited
 * @param input         - the input string over which we intend to move
 */
set<int> move(unordered_map<int, set<int>> transitions, set<int> states, string input) {
    set<int> result, transition;

    for(int state : states) {
        transition = transitions.find(state)->second;
        result.insert(transition.begin(), transition.end());
    }

    if(!result.empty()) {
        cout << "{";
        print(states);
        cout << "} --" << input << "--> {";
        print(result);
        cout << "}\n";
    }

    return result;
}

/**
 * Parses the input adjacency matrix to determine the states connected to this state by the epsilon
 * transition. Recursively checks epsilon transitions to obtain full state list, but doesn't add
 * previously added states by keeping track of the full result in a set as a parameter.
 * @param e_transitions - the adjacency matrix 
 * @param states        - the input state to evaluated
 * @param result        - the running set of epsilon transitions through the recursion
 * @post                - result is populated with states connected to the input set of states by
 *                        the epsilon transition
 */
void e_closure(unordered_map<int, set<int>> e_transitions, set<int> states, set<int> &result) {
    for(int state : states) {
        if(result.find(state) == result.end()) {
            result.insert(state);
            e_closure(e_transitions, e_transitions.find(state)->second, result);
        }
    }
}

/**
 * Prints out a line of text for the e-closure procedure
 * @param e_transitions - the adjacency matrix 
 * @param states        - the input state to evaluated
 * @return              - a set of the states contained in the e-closure of the input states
 */
set<int> e_closure_print(unordered_map<int, set<int>> e_transitions, set<int> states) {
    set<int> result;
    e_closure(e_transitions, states, result);
    cout << "E-closure{";
    print(states);
    cout << "} = {";
    print(result);
    cout << "} = ";
    return result;
}

/**
 * The main function of nfa2dfa --> reads file input, calculates DFA, prints output
 * @param  argc - the number of input arguments
 * @param  argv - the strings of input arguments (tokenized)
 * @return      - program execution status (0 = success, 1 = error)
 */
int main(int argc, char** argv) {
    ///////////////////////////////////////////////////////////////////////////////////////////////
    ///     Relevant Input Information Variables
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    // Each state/input combo goes to a list of states (a, 2) might go to (5, 9, 11), etc.
    unordered_map<string, unordered_map<int, set<int>>> nfa;
    vector<string> alphabet;
    set<int> nfaFinalStates;
    int initState;

    ///////////////////////////////////////////////////////////////////////////////////////////////
    ///     Collect input from file
    ///////////////////////////////////////////////////////////////////////////////////////////////

    string line;

    int lineNum = 1;
    string tempLine;

    while(getline(cin, line)) {
        // Parse for initial states
        if(lineNum == 1) {
            trimBrackets(line);
            initState = stoi(line);
        }
        // Parse for final states
        else if(lineNum == 2) {
            trimBrackets(line);
            nfaFinalStates = strTok(line);
        }
        // Get transition symbols
        else if(lineNum == 4) {
            stringstream stream(line);
            // Forget about "State" at the front
            stream >> tempLine;
            while(stream >> tempLine)
                alphabet.push_back(tempLine);
        }
        // Get transition diagram data
        else {
            stringstream stream(line);
            int stateNum;
            // Capture state number
            stream >> stateNum;
            // Fill transition matrix
            for(int i = 0; i < alphabet.size() && stream >> tempLine; i++) {
                trimBrackets(tempLine);
                pair<int, set<int>> inputTransitionPair(stateNum, strTok(tempLine));

                if(nfa.find(alphabet[i]) == nfa.end()) {
                    unordered_map<int, set<int>> emptyUMap;
                    nfa.insert(make_pair(alphabet[i], emptyUMap));
                }
                nfa.find(alphabet[i])->second.insert(inputTransitionPair);
            }
        }
        lineNum++;
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    ///     Relevant Output Information Variables
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    unordered_map<string, unordered_map<int, int>> dfa;
    unordered_map<int, set<int>> resultStates;
    queue<pair<int, set<int>>> q;
    set<int> dfaFinalStates;
    set<int> temp;
    int numDfaStates = 0;

    ///////////////////////////////////////////////////////////////////////////////////////////////
    ///     Calculate DFA
    ///////////////////////////////////////////////////////////////////////////////////////////////

    // Insert an empty unordered_map for each character in the alphabet to the DFA (instead of
    // doing so on the fly down below)
    for(int i = 0; i < alphabet.size() - 1; i++) {
        unordered_map<int, int> emptyUMap;
        dfa.insert(make_pair(alphabet[i], emptyUMap));
    }
    
    // Find E-closure of initial state and add it to the queue
    temp.insert(initState);
    temp = e_closure_print(nfa.find("E")->second, temp);
    cout << ++numDfaStates << "\n\n";
    q.push(make_pair(numDfaStates, temp));

    // Mark every state in the set of D-States
    while(!q.empty()) {
        // Grab the next closure to check
        pair<int, set<int>> currClosure = q.front();
        q.pop();

        // Print "Mark #" and mark this set by adding it to result states
        cout << "Mark " << currClosure.first << "\n";

        for(int i = 0; i < alphabet.size(); i++) {
            if(alphabet[i] != "E") {
                temp = move(nfa.find(alphabet[i])->second, currClosure.second, alphabet[i]);

                // If the move produced results besides {}, find the E-closure of it
                if(!temp.empty()) {
                    temp = e_closure_print(nfa.find("E")->second, temp);
                    pair<int, int> stateTransititon;

                    bool stateExists = false;
                    // Check if temp exists in current result set
                    for(pair<int, set<int>> state : resultStates) {
                        if(state.second == temp) {
                            stateExists = true;
                            // Finish printing the 'E-closure' line
                            cout << state.first << "\n";

                            // Add this connection to the dfa results
                            stateTransititon = make_pair(currClosure.first, state.first);
                            break;
                        }
                    }

                    // If we encounter a new state of the dfa, add it to the dfa data structure
                    if(!stateExists) {
                        // Finish printing the 'E-closure' line
                        cout << ++numDfaStates << "\n";
                        pair<int, set<int>> newResultState(numDfaStates, temp);
                        resultStates.insert(newResultState);
                        q.push(newResultState);

                        // If this new state contains a final state, add this to dfa final states
                        for(int state : nfaFinalStates) {
                            if(temp.find(state) != temp.end()) {
                                dfaFinalStates.insert(numDfaStates);
                                break;
                            }
                        }

                        // Add this connection to the dfa results
                        stateTransititon = make_pair(currClosure.first, numDfaStates);
                    }
                    dfa.find(alphabet[i])->second.insert(stateTransititon);
                }
            }
        }
        cout << "\n";
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////
    ///     Print Final Output
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    cout << "Initial State: {" << initState << "}\n";
    cout << "Final states: {";
    print(dfaFinalStates);
    cout << "}\n";
    cout << "State\t";

    // Print transition symbols (excluding "E")
    for(int i = 0; i < alphabet.size() - 1; i++) 
        cout << alphabet[i] << "\t";

    // Print out state transititon data
    for(int i = 1; i <= numDfaStates; i++) {
        cout << "\n" << i << "\t";

        for(int j = 0; j < alphabet.size() - 1; j++) {
            unordered_map<int, int> dfaTransition = dfa.find(alphabet[j])->second;
            // Check for a transition
            if(dfaTransition.find(i) == dfaTransition.end())
                cout << "{}\t";
            else {
                int stateData = dfaTransition.find(i)->second;
                cout << "{" << stateData << "}";
                cout << "\t";
            }
        }
    }
    cout << "\n";
    return 0;
}
