equal(X,Y):- X = Y.

zip([], [], []):-!.
zip([], [Y|T], [Z|U]):- equal(Y,Z),zip([],T,U),!.
zip([X|H], [], [Z|U]):- equal(X,Z),zip(H,[],U),!.
zip([X|H], [Y|T], [Z|U]):- (var(Z)->(equal(X,Z),zip(H,[Y|T],U);equal(Y,Z),zip([X|H],T,U)));(equal(X,Z),zip(H,[Y|T],U),!;equal(Y,Z),zip([X|H],T,U),!).
