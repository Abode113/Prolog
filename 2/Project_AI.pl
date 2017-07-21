
% top(Col, Number).
% size(Col, Row).top(0,0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

initTop(0,Y):-!.
initTop(X,Y):- assert(top(X,Y)),X1 is X-1, initTop(X1,Y).

removeTop(X,Y):- retract(top(X, Y)).
removeAllTop():- top(X, Y),once(removeTop(X,Y)),fail.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addSize(X, Y):- assert(size(X,Y)).

removeSize():- size(X, Y), once(retract(size(X, Y))), fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

add(X, Y):- addSize(X,Y), initTop(X,0).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

remove():- addSize(0,0),assert(top(0,0)),assert(piece(0,0,0)),not(removeSize()),not(remove_All_piece()),not(removeAllTop()).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

canWeAdd(X):- size(_, Y), top(X, N), N<Y.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

removeLastTopAndAddNewOne(X,Y):- top(X,L),removeTop(X,L),Y is L+1,assert(top(X,Y)).

add_piece(X,Z):- canWeAdd(X),removeLastTopAndAddNewOne(X,Y),assert(piece(X,Y,Z)).
remove_piece(X,Y,Z):- top(X,T),Y=T,removeTop(X,T),T1 is T - 1,assert(top(X,T1)),retract(piece(X,Y,Z)).
remove_All_piece():- piece(X,Y,Z),once(retract(piece(X,Y,Z))),fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

writeLine(Y):- size(N,_),Y =< N, Y1 is Y + 1, write('======'), writeLine(Y1).

writeGame():- size(_,N), not(writeee(N+1)),writeLine(0).
writeee(X):- X1 is X - 1,X1 >= 1, write('|'), not(writee(X1, 1)),write('|\n'),writeee(X1).
writee(X, Y):- size(N,_),Y=<N,piece(Y,X,Z),write(Z),write('\t'),Y1 is Y + 1,writee(X, Y1),!;size(N,_),Y=<N,not(piece(Y,X,Z)),write('not\t'),Y1 is Y + 1,writee(X, Y1),!.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

choseColor(Player, Computer):- write('\nPlayer Color = '),read(Player),write('\nComputer Color = '),read(Computer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getFirst([X|T],X).
minTop(X):- findall(Here,top(A,Here),T),sort(T,T1),getFirst(T1,X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numberOfPiece(N):- findall(Here, piece(Other1, Other2, Here), X),length(X, N).

%c(Player):- numberOfPiece(N),not(computerTurn1(Player,1,4)),numberOfPiece(N1),N1 > N,!.

c(Computer):- numberOfPiece(N),not(computerTurn(Computer,1,4)),numberOfPiece(N1),N1 > N,!.
c(Computer):- numberOfPiece(N),not(computerTurn(Computer,1,3)),numberOfPiece(N1),N1 > N,!.
c(Computer):- numberOfPiece(N),not(computerTurn(Computer,1,2)),numberOfPiece(N1),N1 > N,!.
c(Computer):- computerTurn(Computer).


computerTurn(Computer,N,T):- top(N,X),add_piece(N, Computer),!,not(winn(N, Computer,T)),X1 is X + 1,remove_piece(N,X1,Computer),N1 is N + 1, computerTurn(Computer, N1,T),!;
						top(N,X),not(add_piece(N, Computer)),N1 is N + 1, computerTurn(Computer, N1,T).

computerTurn1(Player,N,T):- top(N,X),add_piece(N, Player),!,not(winn(N, Player,T)),X1 is X + 1,remove_piece(N,X1,Player),N1 is N + 1, computerTurn(Player, N1,T),!;
						top(N,X),not(add_piece(N, Player)),N1 is N + 1, Player(Player, N1,T).


computerTurn(Computer):- minTop(X),once(top(N,X)),add_piece(N, Computer),win(N, Computer).




%computerTurn(Color,N,T):- top(N,X),write('nn1'),add_piece(N, Color),write('nn2'),!,not(winn(N, Color,T)),write('nn3'),X1 is X + 1,remove_piece(N,X1,Color),write('nn4'),N1 is N + 1,write('nn5'), computerTurn(Color, N1,T),write('nn6\n'),!;
%add_piece(N, Color),not(winn(N, Color,4)),remove_piece(N,X,Color).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%win(Col, Player):- top(Col, Row),not(win(Col, Row, Player)),!;not(fail).
win(Col, Player):- top(Col, Row),not(win(Col, Row, Player,4)),!;write('win = '),write(Player),write('\n'),not(fail).
%winn(Col, Player,Num):- top(Col, Row),win(Col, Row, Player,Num).
winn(Col, Player,Num):- top(Col, Row),not(win(Col, Row, Player,Num)),!;write('win = '),write(Player),write('\n'),not(fail).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

getOut(z).

start(X,Y):-  remove(),add(X,Y),choseColor(Player, Computer),repeat,
			  not(writeGame()),
			  write('\nColumns = '),read(Col),add_piece(Col, Player),win(Col, Player),not(c(Computer)),
			  (getOut(Col),getOut(Coll);fail).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

checkLeft(0,Y,0,A):-!.
checkLeft(X,Y,Z,A):- piece(X,Y,B),A=B,X1 is X-1,checkLeft(X1,Y,Z1,A),Z is Z1+1,!;Z is 0.

checkRight(K,Y,1,A):-size(M,N),K=M,!.
checkRight(X,Y,Z,A):- piece(X,Y,B),A=B,X1 is X+1,checkRight(X1,Y,Z1,A),Z is Z1+1,!;Z is 0.

checkHorizontal(X,Y,Z,A):- checkLeft(X,Y,Z1,A),checkRight(X,Y,Z2,A),Z is Z1+Z2-1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

checkDown(X,0,0,A):-!.
checkDown(X,Y,Z,A):- piece(X,Y,B), A=B,Y1 is Y-1,checkDown(X,Y1,Z1,A),Z is Z1+1,!;Z is 0.


checkVertical(X,Y,Z,A):- checkDown(X,Y,Z1,A),Z is Z1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


checkUpLeft(X,Y,1,A):- size(M,N),X=M,Y=N,!.
checkUpLeft(X,Y,Z,A):- piece(X,Y,B),A=B,X1 is X+1,Y1 is Y-1,checkUpLeft(X1,Y1,Z1,A),Z is Z1+1,!;Z is 0.

checkDownRight(X,Y,1,A):- size(M,N),X=M,Y=N,!.
checkDownRight(X,Y,Z,A):- piece(X,Y,B),A=B,X1 is X-1,Y1 is Y+1,checkDownRight(X1,Y1,Z1,A),Z is Z1+1,!;Z is 0.

checkScale1(X,Y,Z,A):- checkUpLeft(X,Y,Z1,A),checkDownRight(X,Y,Z2,A),Z is Z1+Z2-1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

checkDownLeft(X,Y,1,A):- size(M,N),X=M,Y=N,!.
checkDownLeft(X,Y,Z,A):- piece(X,Y,B),A=B,X1 is X+1,Y1 is Y+1,checkDownLeft(X1,Y1,Z1,A),Z is Z1+1,!;Z is 0.

checkUpRight(X,Y,1,A):- size(M,N),X=M,Y=N,!.
checkUpRight(X,Y,Z,A):- piece(X,Y,B),A=B,X1 is X-1,Y1 is Y-1,checkUpRight(X1,Y1,Z1,A),Z is Z1+1,!;Z is 0.

checkScale2(X,Y,Z,A):- checkDownLeft(X,Y,Z1,A),checkUpRight(X,Y,Z2,A),Z is Z1+Z2-1.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

win(X,Y,A,Num):- checkHorizontal(X,Y,Z,A),Z >= Num,!;
             checkVertical(X,Y,Z,A),Z >= Num,!;
             checkScale1(X,Y,Z,A),Z >= Num,!;
             checkScale2(X,Y,Z,A),Z >= Num,!.


add():- add_piece(1, 'b'),add_piece(1, 'b'),add_piece(1, 'b'),add_piece(2, 'b'),add_piece(3, 'b'),add_piece(3, 'b'),add_piece(4, 'b'),writeGame().







           