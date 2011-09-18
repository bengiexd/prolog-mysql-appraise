%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HELPER FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Database connection routines.
% Creates a global variable named db that can be used
% anywhere in the program to interact with the database.
%
connect :- odbc_connect('mysql.prolog_appraise', _,
		[ user(database_username),
		  alias(db),
		  password(database_password),
		  open(once)
		]).

% Disconnects from the database.
disconnect :- odbc_disconnect(db).

% Extracts the values from a row in the Value table.
parse_value(Row, Thing1, Price, Thing2, Inferred) :- row(Thing1, Price, Thing2, Inferred) = Row.

% Finds the value of Thing1 in terms of Thing2.
generic_value(Thing1, Price, Thing2, Inferred) :-
	connect,
	odbc_prepare(db, 'select * from value where ((thing1 = ? and thing2 = ?) or (thing2 = ? and thing1 = ?)) and inferred = ?', [default, default, default, default, integer], Statement, [fetch(fetch), types([atom, float, atom, integer])]),
	odbc_execute(Statement, [Thing1, Thing2, Thing2, Thing1, Inferred]),
	odbc_fetch(Statement, Row, next),
	parse_value(Row, _, Price, _, _),
	disconnect.

value(Thing1, Price, Thing2) :- generic_value(Thing1, Price, Thing2, 0).
inferred_value(Thing1, Price, Thing2) :- generic_value(Thing1, Price, Thing2, 1).

% Finds the appraised value of Thing1 in terms of Thing2.

% Sets the value of Thing1 in terms of Thing2.
% If inferred is not specified, defaults to true.
set_value(Thing1, Price, Thing2) :- set_value(Thing1, Price, Thing2, 1).
set_value(Thing1, Price, Thing2, Inferred) :-
	connect,
	odbc_prepare(db, 'insert into value(thing1, price, thing2, inferred) values (?, ?, ?, ?)', [default, float > decimal, default, integer], Statement),
	odbc_execute(Statement, [Thing1, Price, Thing2, Inferred]),
	disconnect.

% Clears all inferred values from the database.
clear_inferrences :-
	connect,
	odbc_query(db, 'delete from value where inferred').




