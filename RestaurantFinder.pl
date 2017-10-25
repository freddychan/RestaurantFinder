% Program to find restaurant on campus that accepts natural language queries.

% ---------------------------------
% |Natural Language Interpretation|
% ---------------------------------

% question(C0, C2, O, T0, T2) is true if:
%	C0 is an ordered list of words to form a question.
%	C2 is the ending of C0.
%	O is the Subject in the question.
%	T0 is the list of terms of constraints O has to answer.
%	T2 is the ending of T0.

question([what,is|C0],C2,O,T0,T2) :-
	noun_phrase(C0,C1,O,T0,T1),
	mod_phrase(C1,C2,O,T1,T2).
question([what|C0],C2,O,T0,T2) :-
	noun_phrase(C0,C1,O,T0,T1),
	mod_phrase(C1,C2,O,T1,T2).
question([which|C0],C2,O,T0,T2) :-
	noun_phrase(C0,C1,O,T0,T1),
	mod_phrase(C1,C2,O,T1,T2).
question([where|C0],C2,O,T0,T2) :-
	noun_phrase(C0,C1,O,T0,T1),
	mod_phrase(C1,C2,O,T1,T2).
question([where,is|C0],C2,O,T0,T2) :-
	noun_phrase(C0,C1,O,T0,T1),
	mod_phrase(C1,C2,O,T1,T2).


% from CPSC 312 2017 - Lecture 13, nl_intergace_dl.pl
% noun_phrase(C0,C3,O,T0,T3) is true if 
% C0 - C3 is difference list of words forming a noun phrase
% noun phrase refers to individual O
% T0 - T3 is difference list of constraints on individual O by the noun phrase
% A noun phrase is a determiner followed by adjectives followed
% by a noun followed by an optional modifying phrase:

noun_phrase(C0,C3,O,T0,T3):-
	det(C0,C1,O,T0,T1),
    adjectives(C1,C2,O,T1,T2),
    noun(C2,C3,O,T2,T3).

% Determiners used:
% det(C1, C2, _, _, _) true if :
%	First element of C1 is determiner i.e.('the', 'a', or none).
%	C2 is end of C1 or if determiner is none then C2 is same as C1.
%	Other variables are for passing on data.

det([the | C],C,_,T,T).
det([a | C],C,_,T,T).
det([an | C],C,_,T,T).
det(C,C,_,T,T).

% Adjectives 
%  adj(C0, C2, Sub, T0, T2) true if:
%	C0 - C2 is difference list of words that make up the adjectives
%	or an empty list.
%	O is the subject described by the adjective.
%	T0 - T2 is difference list of constraints on O from
%	adjectives.

adjectives(C0,C2,O,T0,T2) :-
    adj(C0,C1,O,T0,T1),
    adjectives(C1,C2,O,T1,T2).
adjectives(C,C,_,T,T).

% Modifying Phrase
%  mod_phrase(T0, T2, O, C0, C2) true if:
%	T0 - T2 is difference list of words forming a modifying 
%	phrase or empty list.
%	O,O1 is the subject of the modifying phrase.
%	C0 - C2 is difference list of constraints on O,O1 from
%	modifying phrase.

mod_phrase([is|C0],C2,O,T0,T2) :-
	adj(C0,C1,O,T0,T1),
	adjectives(C1,C2,O,T1,T2).
mod_phrase([that,is|C0],C2,O,T0,T2) :-
	adj(C0,C1,O,T0,T1),
	adjectives(C1,C2,O,T1,T2).
mod_phrase([that,is|C0],C2,O1,T0,T2) :-
	reln(C0,C1,O1,O2,T0,T1),
	noun_phrase(C1,C2,O2,T1,T2).
mod_phrase(C0,C3,O1,T0,T3) :-
	reln(C0,C1,O1,O2,T0,T1),
	noun_phrase(C1,C2,O2,T1,T2),
	mod_phrase(C2,C3,O1,T2,T3).
mod_phrase(C,C,_,T,T).

% ------------
% |Dictionary|
% ------------

% Nouns
% noun([noun|C0],C0, O, [restaurant(O)|T0], T0).
% noun([noun|C0],C0, O, [location(O)|T0], T0).
% noun([noun|C0],C0, O, [restaurant(noun)|T0], T0).
% noun([noun|C0],C0, O, [location(noun)|T0], T0).

noun([restaurant|C0],C0, O, [restaurant(O)|T0],T0).
noun([location|C0],C0, O, [location(O)|T0],T0).
noun([O|C],C,O,T,T) :- restaurant(O).
noun([O|C],C,O,T,T) :- location(O).
noun([the, nest|C],C,the_nest,T,T).
noun([david, lam, research, centre|C],C,david_lam_research_centre,T,T).
noun([marine, residence|C],C,marine_residence,T,T).


noun([H|CO],CO,O,[in(H,O)|T0],T0) :- restaurant(H).
noun([H|CO],CO,O,[in(O,H)|T0],T0) :- location(H).

noun([bento, sushi|C0],C0,O,[in(bento_sushi,O)|T0],T0).
noun([flip, side|C0],C0,O,[in(flip_side,O)|T0],T0).
noun([grand, noodle, emporium|C0],C0,O,[in(grand_noodle_emporium,O)|T0],T0).
noun([honour, roll|C0],C0,O,[in(honour_roll,O)|T0],T0).
noun([ikes, cafe|C0],C0,O,[in(ikes_cafe,O)|T0],T0).
noun([loop, cafe|C0],C0,O,[in(loop_cafe,O)|T0],T0).
noun([the, point, grill|C0],C0,O,[in(the_point_grill,O)|T0],T0).
noun([triple, o|C0],C0,O,[in(triple_o,O)|T0],T0).

noun([the, nest|C0],C0,O,[in(O,the_nest)|T0],T0).
noun([david, lam, research, centre|C0],C0,O,[in(O,david_lam_research_centre)|T0],T0).
noun([marine, residence|C0],C0,O,[in(O,marine_residence)|T0],T0).

% Adjectives
% adj([adj|C0],C0,O,[adj(O)|T0], T0).

adj([american|C0],C0,O, [american(O)|T0],T0).
adj([cafe|C0],C0,O, [cafe(O)|T0],T0).
adj([chinese|C0],C0,O, [chinese(O)|T0],T0).
adj([italian|C0],C0,O, [italian(O)|T0],T0).
adj([japanese|C0],C0,O, [japanese(O)|T0],T0).

adj([cheap|C0],C0,O, [cheap(O)|T0],T0).
adj([expensive|C0],C0,O, [expensive(O)|T0],T0).

adj([bad|C0],C0,O, [bad(O)|T0],T0).
adj([good|C0],C0,O, [good(O)|T0],T0).
adj([excellent|C0],C0,O, [excellent(O)|T0],T0).


% Relations
% reln([reln|C],C,O1,O2,[reln(O1,O2),T],T).

reln([in|C],C,O1,O2,[in(O1,O2)|T],T).


% ----------
% |Database|
% ----------

% restaurant(name, cuisine, location, price, rating, close_to)

restaurant(bento_sushi).
restaurant(flip_side).
restaurant(grand_noodle_emporium).
restaurant(honour_roll).
restaurant(ikes_cafe).
restaurant(loop_cafe).
restaurant(mercante).
restaurant(the_point_grill).
restaurant(triple_o).

american(flip_side).
american(the_point_grill).
american(triple_o).
cafe(ikes_cafe).
cafe(loop_cafe).
chinese(grand_noodle_emporium).
italian(mercante).
japanese(bento_sushi).
japanese(honour_roll).

location(david_lam_research_centre).
location(the_nest).
location(irving).
location(cirs).
location(ponderosa).
location(marine_residence).

location(angus).
location(hennings).
location(eosc).

in(bento_sushi, david_lam_research_centre).
in(flip_side, the_nest).
in(grand_noodle_emporium, the_nest).
in(honour_roll, the_nest).
in(ikes_cafe, irving).
in(loop_cafe, cirs).
in(mercante, ponderosa).
in(the_point_grill, marine_residence).
in(triple_o, david_lam_research_centre).

cheap(bento_sushi).
cheap(flip_side).
cheap(honour_roll).
cheap(ikes_cafe).
cheap(loop_cafe).
cheap(triple_o).
expensive(mercante).
expensive(the_point_grill).
expensive(grand_noodle_emporium).

rating(bento_sushi, 3).
rating(flip_side, 4).
rating(grand_noodle_emporium, 4).
rating(honour_roll, 1).
rating(ikes_cafe, 3).
rating(loop_cafe, 2).
rating(mercante, 3).
rating(the_point_grill, 2).
rating(triple_o, 5).

% Ratings on a 5 point-scale

bad(R) :- rating(R, S), S < 3.
good(R) :- rating(R, S), S = 3.
excellent(R) :- rating(R, S), S > 3.


% -----------
% |Interface|
% -----------

% from CPSC 312 2017 - Lecture 13, nl_intergace_dl.pl
% prove_all(L) proves all elements of L against the database

prove_all([]).
prove_all([H|T]) :-
    call(H),      % built-in Prolog predicate calls an atom
    prove_all(T).

% from CPSC 312 2017 - Lecture 13, nl_intergace_dl.pl
% ask(Q,A) gives answer A to question Q

ask(Q,A) :-
    question(Q,[],A,T,[]),
    prove_all(T).

	
% ------------
% |Test Cases|
% ------------

% Question: ask([what,is,a,cheap,restaurant],A).
% Ans: A = bento_sushi,flip_side,honour_roll,ikes_cafe,loop_cafe,triple_o

% Question: ask([what,is,an,expensive,restaurant],A).
% Ans: A = mercante,the_point_grill,grand_noodle_emporium

% Question: ask([what,is,an,american,restaurant],A).
% Ans: A = flip_side,the_point_grill,triple_o

% Question: ask([what,is,a,cafe,restaurant],A).
% Ans: A = ikes_cafe,loop_cafe

% Question: ask([what,is,a,chinese,restaurant],A).
% Ans: A = grand_noodle_emporium

% Question: ask([what,is,a,japanese,restaurant],A).
% Ans: A = bento_sushi,honour_roll

% Question: ask([where,is,flip,side],A).
% Ans: A = the_nest


% Question: ask([what,is,a,bad,restaurant],A).
% Ans: A = honour_roll,loop_cafe,the_point_grill

% Question: ask([what,is,a,good,restaurant],A).
% Ans: A = bento_sushi,ikes_cafe,mercante

% Question: ask([what,is,an,excellent,restaurant],A).
% Ans: A = flip_side,grand_noodle_emporium,triple_o

% Question: ask([what,is,a,restaurant,in,the,nest],A).
% Ans: A = flip_side,grand_noodle_emporium,honour_roll

% Question: ask([what,is,a,restaurant,that,is,in,the,nest],A).
% Ans: A = flip_side,grand_noodle_emporium,honour_roll

% Question: ask([what,is,a,restaurant,in,angus],A).
% Ans: false

% Question: ask([where,is,starbucks],A).
% Ans: false

% Question: ask([what,is,a,restaurant],A).
% Ans: A = bento_sushi,flip_side,grand_noodle_emporium,honour_roll,
% 		ikes_cafe,loop_cafe,mercante,the_point_grill,triple_o

% Question: ask([where,is,mercante],A).
% Ans: A = ponderosa

% Question: ask([what,is,near,mercante],A).
% Ans: A = angus

% Question: ask([what,is,a,restaurant,in,irving],A).
% Ans: A = ikes_cafe

