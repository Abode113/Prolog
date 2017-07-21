male(A).

checkifoperator(X, EXP):- atom(X),atom_string(X,R),U = R,O = EXP,equal(U,O).
equal(X,Y):- X = Y.

checkanyoperator(X):-checkifoperator(X, "+");checkifoperator(X, "-");checkifoperator(X, "*");checkifoperator(X, "^");checkifoperator(X, "sin");checkifoperator(X, "cos").

checklenghtmorethan([X|H], Z):- len([X|H], R),R >= Z.
checklenghtexact([X|H], Z):- len([X|H], R),R = Z.

checktherestofoperator([]):-!.
checktherestofoperator([X|H]):- is_list(X),checktherestofoperator(H);number(X),checktherestofoperator(H).

len([], 0).
len([H|T], S):- len(T, S1), S is S1+1.


evaluate([], 0):-!.
evaluate([X|H], Z):- is_list(X),evaluate(X, Z),!.
evaluate([X|H], X):- number(X),!.
evaluate([X|H], Z):- checkifoperator(X, "+"),checktherestofoperator(H),checklenghtmorethan([X|H], 3),exp1sol(H, Z),!.
evaluate([X|H], Z):- checkifoperator(X, "-"),checktherestofoperator(H),checklenghtmorethan([X|H], 3),exp2sol(H, Z),!.
evaluate([X|H], Z):- checkifoperator(X, "*"),checktherestofoperator(H),checklenghtmorethan([X|H], 3),exp3sol(H, Z),!.
evaluate([X|H], Z):- checkifoperator(X, "^"),checktherestofoperator(H),checklenghtexact([X|H], 3),exp4sol(H, Z),!.
evaluate([X|H], Z):- checkifoperator(X, "sin"),checktherestofoperator(H),checklenghtexact([X|H], 2),exp5sol(H, Z),!.
evaluate([X|H], Z):- checkifoperator(X, "cos"),checktherestofoperator(H),checklenghtexact([X|H], 2),exp6sol(H, Z),!.

check([]):- !.
check([X|H]):- checkanyoperator(X),evaluate([X|H], Z),check(H),!.
check([X|H]):- is_list(X),evaluate(X, Z),check(H),!.
check([X|H]):- number(X),check(H),!.


exp1sol([], 0).
exp1sol([X|H], Z):- is_list(X),evaluate(X, R),exp1sol(H, Z2),Z is R + Z2;exp1sol(H, Z1),Z is X + Z1.

exp2sol([], 0).
exp2sol([X|H], Z):- is_list(X),evaluate(X, R),exp2sol(H, Z2),Z is R - Z2;exp2sol(H, Z1),Z is X - Z1.

exp3sol([], 1).
exp3sol([X|H], Z):- is_list(X),evaluate(X, R),exp3sol(H, Z2),Z is R * Z2;exp3sol(H, Z1),Z is X * Z1.

tonumber(X,X):-number(X),!.
tonumber(X,Z):-is_list(X),evaluate(X,Z).
exp4sol([X|H], Z):- tonumber(X,R1),tonumber(H,R2),Z is R1 ** R2.

exp5sol([X|H], Z):- tonumber(X,R),Z is sin(R).
exp6sol([X|H], Z):- tonumber(X,R),Z is cos(R).



