cost(beef,		6).
cost(mushroom,	3).
cost(fish,		8).
cost(chicken,	5).
cost(pickles,	1).
cost(corn,		2).
cost(ketchup,	1).
cost(onion,		1).
cost(pepper,	1).
cost(sauce,		3).
cost(cheese,	1).
cost(bechamel,	3).
cost(bread,		1).
cost(potato,	1).
cost(rice,		1).


ingredients(grilled_chicken,   			[bread,chicken,sauce,ketchup]							).
ingredients(grilled_fish,      			[bread,fish,sauce,ketchup]								).
ingredients(grilled_cheese_sandwish,   	[bread,cheese,corn,sauce,ketchup]						).
ingredients(beef_stew,         			[beef,sauce,bechamel]									).
ingredients(potato_corn,       			[potato,corn,sauce]										).
ingredients(roast_beef,        			[potato,beef,ketchup,onion]								).
ingredients(potato_salad,      			[potato,pickles,ketchup,onion,pepper]					).
ingredients(chicken_rice,      			[rice,chicken,ketchup,sauce,bechamel]					).
ingredients(mushroom_rice,     			[rice,mushroom,sauce,pepper,bechamel]					).
ingredients(jambo_beef,     			[corn,beef,onion,potato,pepper,sauce,ketchup,cheese]	).
ingredients(service_dish,     			[pickles,ketchup,onion,potato,pepper,cheese]			).


restaurant(		hardees,
           		[abo_abdo,abo_ahmad,tahseen],
           		[grilled_chicken,jambo_beef,grilled_cheese_sandwish,roast_beef]		).

restaurant(		subway,
           		[eftikar,tahseen,samer],
           		[potato_salad,chicken_rice,jambo_beef,service_dish]					).

restaurant(		mcDonalds,
				[amer,zaher,maher],
           		[service_dish,beef_stew,potato_corn,grilled_chicken,roast_beef]		).

restaurant(		kfc,
				[mufeed,mazen,izdihar,maher],
           		[mushroom_rice,service_dish,jambo_beef]								).

equal(X,Y):- X = Y.

%=======   1   ========

available_at(Dishe_name,Res_name):- restaurant(N,_,L), equal(Res_name,N), member(Dishe_name,L).

%=======   2   ========

ismember(Name, List, Value):- member(Name, List), Value is 1; Value is 0.

findRepitedDish(Dishe_name, [], 0):-!.
findRepitedDish(Dishe_name,[H|T], Repitedvalue):-findRepitedDish(Dishe_name, T, Repitedvalue1),ismember(Dishe_name,H,Repitedvalue2),Repitedvalue is Repitedvalue1 + Repitedvalue2.
multi_available(Dishe_name):-findall(Here, restaurant(Other1, Other2, Here), All_list), findRepitedDish(Dishe_name, All_list, Repitedvalue), Repitedvalue > 1.

%=======   3   ========

findRepitedEmp(Emp_name, [], 0):-!.
findRepitedEmp(Emp_name, [H|T], Repitedvalue):- findRepitedEmp(Emp_name, T, Repitedvalue1), ismember(Emp_name,H,Repitedvalue2),Repitedvalue is Repitedvalue1 + Repitedvalue2.
overworked(Emp_name):-findall(Here, restaurant(Other1, Here, Other2), All_list), findRepitedEmp(Emp_name, All_list, Repitedvalue), Repitedvalue > 1.

%=======   4   ========

getvalueofingredientlist([], 0):-!.
getvalueofingredientlist([H|T], Value):- cost(H,Value1), getvalueofingredientlist(T,Value2), Value is Value1 + Value2.

getvalueofingredients(IngredientsName,Value):- ingredients(IngredientsName,L), getvalueofingredientlist(L,Value).

total_cost(X, R):-getvalueofingredients(X,Z),R = Z.

%=======   5   ========

allmember1([], L).
allmember1([H|T], L):- member(H, L),allmember1(T, L).
allmember(List,IngredientsList):-once(allmember1(List,IngredientsList)).

has_ingredients(IngredientsName,List):- ingredients(IngredientsName,IngredientsList),allmember(List,IngredientsList).

%=======   6   ========

%allmembernot1([], L).
%allmembernot1([H|T], L):- member(H, L),allmembernot1(T, L).
%allmembernot(List,IngredientsList):-once(not(allmembernot1(List,IngredientsList))).

%avoid_ingredients(IngredientsName,List):- ingredients(IngredientsName,IngredientsList),allmembernot(List,IngredientsList).


allmembernot1([], L).
allmembernot1([H|T], L):- not(member(H, L)),allmembernot1(T, L);fail.
allmembernot(List,IngredientsList):-once(allmembernot1(List,IngredientsList)).

avoid_ingredients(IngredientsName,List):- ingredients(IngredientsName,IngredientsList),allmembernot(List,IngredientsList).

%=======   7   ========

find(IngredientsName, WantedIngredients, AvoidedIngredients):- ingredients(IngredientsName,IngredientsList),allmember(WantedIngredients,IngredientsList),allmembernot(AvoidedIngredients,IngredientsList).












