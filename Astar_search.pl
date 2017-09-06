%Returns cost to node M when given node N and a seed
arc2(N,M,Seed,Cost) :- M is N*Seed, Cost=1.
arc2(N,M,Seed,Cost) :- M is N*Seed + 1, Cost=2.

%Is true if at goal node
isgoal(N,Target) :- 0 is N mod Target.

%Heuristic function
h(N,Hvalue,Target) :- isgoal(N,Target), !, Hvalue is 0
;
Hvalue is 1/N.

%Least cost first search
less-than([Node1,Cost1],[Node2,Cost2],Target) :-
h(Node1,Hvalue1,Target), h(Node2,Hvalue2,Target),
F1 is Cost1+Hvalue1, F2 is Cost2+Hvalue2,
F1 =< F2.

%Takes a list of nodes and adds them to the frontier
%Adds them based on the cost in ascending order
%The frontier acts as a list of nodes in ascending cost 
%Given a list of children it takes one child node a time and steps through frontier
%Until is finds it place in the frontier (childCost<frontierNCost) or reaches the end of frontier.

%Reached end of frontier- Add Children to end of the frontier
addtofront([[C1,C1cost]|Crest],[],_Target,[[C1,C1cost]|Crest]).
%All children have been added to the frontier - Return the frontier as is
addtofront([],[[S,Scost]|Rest],_Target,[[S,Scost]|Rest]).
%if c1<S c1 becomes new head of sub-frontier
addtofront([[C1,C1cost]|Crest],[[S,Scost]|Srest],Target,[[C1,C1cost]|Fnew]):-
           less-than([C1,C1cost],[S,Scost],Target),addtofront(Crest,[[S,Scost]|Srest],Target,Fnew). 
%else front of sub-frontier stays the head.
           addtofront([[C1,C1cost]|Crest],[[S,Scost]|Srest],Target,[[S,Scost]|Fnew]):-
           addtofront([[C1,C1cost]|Crest],Srest,Target,Fnew). 

%Takes a list of nodes and adds a cost to each node.
addCostToNodes([],_Nc,[]).
addCostToNodes([[C,Ccost]|Crest],Nc,[[C,Newcost]|Nf]):- Newcost is Ccost+ Nc,
    addCostToNodes(Crest,Nc,Nf).
    
%Searches for the target

%If at goal return the node [N,NC]
searchA([[N,NC]|_Rest],_Seed,Target,[N,NC]):- isgoal(N,Target).
%else get and then add children to frontier in correct order, recur call searchA
searchA([[N,NC]|Rest],Seed,Target,Found):-
    setof([X,CC],arc2(N,X,Seed,CC),Children),
    addCostToNodes(Children,NC,Children2),
    addtofront(Children2,Rest,Target,NewF),
    searchA(NewF,Seed,Target,Found).

%Returns the found node [Node,Cost] in Found    
a-star(Start,Seed,Target,Found):-
    searchA([[Start,0]],Seed,Target,Found).




