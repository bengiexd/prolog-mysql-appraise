% appraised holds all the values the computer figured out for itself.
% Useful if we ever want to force it to recalculate values based on 
% what we've entered by hand. A simple "retractall(appraised)" would
% clear that cache out quite nicely.
:- dynamic appraised/3.

% value holds all the values we've entered by hand.
% Assumed to be more reliable than "appraised" values,
% since real-world conversions are sometimes less
% efficient in one direction versus the other.
:- dynamic value/3.

% Some quick nonsense assertions to get you started. Feel free to delete these.
value(banana, 1 rdiv 4, bitcoin).
value(bitcoin, 1 rdiv 30, namecoin).
value(apple, 3 rdiv 4, banana).
value(orange, 1 rdiv 5, apple).

% Naive pathfinding algorithm.
% TODO: Keep track of route taken.
appraise(Thing1, Price, Thing2) :- value(Thing1, Price, Thing2).
appraise(Thing1, Price, Thing2) :- value(Thing2, BackPrice, Thing1), Price is 1 rdiv BackPrice, assert(appraised(Thing1, Price, Thing2)).
appraise(Thing1, Price, Thing2) :- appraised(Thing1, Price, Thing2).
appraise(Thing1, Price, Thing2) :- appraised(Thing2, BackPrice, Thing1), Price is 1 rdiv BackPrice, assert(appraised(Thing1, Price, Thing2)).
appraise(Thing1, Price, Thing2) :- appraise(Thing1, Price1, Thing3), appraise(Thing2, Price2, Thing3), Price is Price1 rdiv Price2, assert(appraised(Thing1, Price, Thing2)).

appraise_float(Thing1, Price, Thing2) :- appraise(Thing1, RPrice, Thing2), Price is float(RPrice).

% Simple user-friendly function to find cost of n things in terms of something else.
find_cost(Quantity, Thing1, Cost, Thing2) :- appraise(Thing1, Price, Thing2), Cost is Quantity*Price.

