:- use_module('db.pro').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRICE FINDING LOGIC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Naive pathfinding algorithm.
% Thing1 is the item the user has.
% Thing2 is the type of item the user wants their item valued in.
% TODO: Keep track of route taken.
appraise(Thing1, Price, Thing1) :- Price is 1.
appraise(Thing1, Price, Thing2) :- value(Thing1, Price, Thing2).
appraise(Thing1, Price, Thing2) :- value(Thing2, BackPrice, Thing1), Price is 1 rdiv BackPrice, set_value(Thing1, Price, Thing2).
appraise(Thing1, Price, Thing2) :- inferred_value(Thing1, Price, Thing2).
appraise(Thing1, Price, Thing2) :- inferred_value(Thing2, BackPrice, Thing1), Price is 1 rdiv BackPrice, set_value(Thing1, Price, Thing2).
appraise(Thing1, Price, Thing2) :- appraise(Thing1, Price1, Thing3), appraise(Thing2, Price2, Thing3), Price is Price1 rdiv Price2, set_value(Thing1, Price, Thing2).

appraise_float(Thing1, Price, Thing2) :-
	appraise(Thing1, RPrice, Thing2),
	Price is float(RPrice).

% Simple user-friendly function to find cost of n things in terms of something else.
find_cost(Quantity, Thing1, Cost, Thing2) :-
	appraise(Thing1, Price, Thing2),
	Cost is Quantity*Price.
















