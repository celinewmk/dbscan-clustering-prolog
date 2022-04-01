% CSI 2520 - Projet intégrateur partie Prolog
% Étudiante: Céline Wan Min Kee
% Numéro étudiant: 300193369

% import
% returns all the points in each partition with all their information
import:-
    csv_read_file('partition65.csv', Data65, [functor(partition)]),maplist(assert, Data65),
    csv_read_file('partition74.csv', Data74, [functor(partition)]),maplist(assert, Data74),
    csv_read_file('partition75.csv', Data75, [functor(partition)]),maplist(assert, Data75),
    csv_read_file('partition76.csv', Data76, [functor(partition)]),maplist(assert, Data76),
    csv_read_file('partition84.csv', Data84, [functor(partition)]),maplist(assert, Data84),
    csv_read_file('partition85.csv', Data85, [functor(partition)]),maplist(assert, Data85),
    csv_read_file('partition86.csv', Data86, [functor(partition)]),maplist(assert, Data86),listing(partition).


% mergeClusters/1
% merge the clusters and return the result in L
% mergeClusters(L)
mergeClusters(L):- findall([D,X,Y,C],partition(_,D,X,Y,C),LL),mergeClusters(LL,[],L),!. % [] = initialisation of clusterlist
% using global list LL with all the information on each point (minus partition id) to do the merging

% mergeClusters/3
% loops through all the points in the database LL of mergeClusters/3 and returns clusterlist L
% checks if the point is in the clusterlist
% if it is already in clusterlist, we relabel all the points with label of the point in clusertlist with the label of the point we're currently on
% else, we just add the point to clusterlist
% mergeClusters(LL,A,L)
mergeClusters([],L,L).  % case where we finished looping throught the whole list, we then assign the A to L
mergeClusters([T|Q],A,L):- nth0(0,T,H),not(idEstMembre(H,A,_)),
                                myInsert(T,A,AA),mergeClusters(Q,AA,L).     % case where the point is not in clusterlist
mergeClusters([T|Q],A,L):- nth0(0,T,H),nth0(3,T,L1),idEstMembre(H,A,LA), 
                                relabel(LA,L1,A,AA),mergeClusters(Q,AA,L).  % case where the point is already in the list meaning it's intersecting

% test predicate for mergeClusters (PS: we need to run import first)
% Expected output: [[1345,40.750304,-73.952031,65000001],[6017,40.760146,-73.957873,65000002],[17457,40.760213,-73.955471,65000003],[18582,40.750299,-73.952027,65000001],etc...]
testMerge(mergeClusters):- write("Test: mergeClusters(L)"),nl,mergeClusters(L),write(L).

% relabel/4
% relabel the points with label O with label R
% relabel is given an In list and will produce an Out list
% relabel(O,R,In,Out)
relabel(O,R,In,Out):- relabel(O,R,In,[],Out),!.

% relabel/5
% used in relabel/4
% loops through all the points in the In list of relabel/4
% and relabel the points with label O with label R
% relabel(O,R,In,A,Out) 
relabel(_,_,[],Out,Out). % case where we finished looping throught the whole list, we then assign the A to Out
relabel(O,R,[T|Q],A,Out):- T=[ID,X,Y,O],myInsert([ID,X,Y,R],A,N),
                            relabel(O,R,Q,N,Out).                    % case where the label is O and has to be changed to R
relabel(O,R,[T|Q],A,Out):- myInsert(T,A,N),relabel(O,R,Q,N,Out).     % case where the label doesn't need to be changed                

% test predicate for relabel
% Expected output for test 1: [[1,2.2,3.1,77], [2,2.1,3.1,22], [3,2.5,3.1,77], [4,2.1,4.1,77], [5,4.1,3.1,30]]
% Expected output for test 2: [[1,2.2,3.1,22], [2,2.1,3.1,21], [3,2.5,3.1,33], [4,2.1,4.1,22], [5,4.1,3.1,30],[6,9.1,2.1,22]]
testRelabel(relabel):- write('Test 1: relabel(33, 77,[[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33],[5,4.1,3.1,30]],Result)'),nl,
 write("Result = "), relabel(33, 77,[[1,2.2,3.1,33], [2,2.1,3.1,22], [3,2.5,3.1,33], [4,2.1,4.1,33], [5,4.1,3.1,30]],Result), write(Result),nl,
 write('Test 2: relabel(10, 22,[[1,2.2,3.1,10], [2,2.1,3.1,21], [3,2.5,3.1,33], [4,2.1,4.1,10], [5,4.1,3.1,30],[6,9.1,2.1,10]],Result1)'),nl,
 write("Result1 = "), relabel(10, 22,[[1,2.2,3.1,10], [2,2.1,3.1,21], [3,2.5,3.1,33], [4,2.1,4.1,10], [5,4.1,3.1,30],[6,9.1,2.1,10]],Result1), write(Result1). 

% myInsert/3
% insertion of element X at the end of list Y, gives the result Z
% myInsert(X,Y,Z)
myInsert(X,Y,Z):- append(Y,[X],Z). 
% using append, transforms Y into first argument and the element X as second argument
% then we're gonna append Y with X, reuslting into Y being at the head and X at the tail

% test predicate for myInsert
% Expected output: Z = [1,2,5,6,3]
testInsert(myInsert):- write('Test: myInsert(3,[1,2,5,6],Z)'), nl, write("Z = "), myInsert(3,[1,2,5,6],Z),write(Z).

% idEstMembre/3
% Check if element X is the first element of a sublist of the 2D list
% If X is first element of a sublist, return the label LA of the point (4th element of sublist) and true
% else, returns false
% idEstMembre(X,[T|Q],LA)
idEstMembre(X,[T|_],LA):- nth0(0,T,L),nth0(3,T,LL),L=:=X,LA=LL,!. % case where we found X to be first element of sublist, we then assign LA to be label LL of the corresponding sublist and return true
idEstMembre(X,[T|Q],LA):- nth0(0,T,L),L=\=X,idEstMembre(X,Q,LA).  % case where we X is not first element of the sublist, so we continue looping through 2D list

% test predicate for idEstMembre
% Expected output: L = 3 true.
testIdEstMembreVrai(idEstMembre):- write("Test: idEstMembre(1,[[0,2,3,4],[1,2,3,3],[2,1,3,9]],L)"),nl,idEstMembre(1,[[0,2,3,4],[1,2,3,3],[2,1,3,9]],L),write("L = "),write(L).
% Expected output: false.
testIdEstMembreFaux(idEstMembre):- write("Test: idEstMembre(3,[[0,2,3,4],[1,2,3,3],[2,1,3,9]],L)"),nl,idEstMembre(3,[[0,2,3,4],[1,2,3,3],[2,1,3,9]],L),write("L = "),write(L).