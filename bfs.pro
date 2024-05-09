% === TODO change this  
% bfs_map_without_cycle(List, Path, Node, NewList): creates a new list of paths 
% given the current path and a node to append. The Path is a list of nodes, and 
% we want to append Node to the end of Path. If this new path contains a cycle, 
% then NewList is equivalent to List. Otherwise, NewList is equal to List with 
% the addition of a single new path. 
% === 

% The Node already exists within the Path, so adding it would create a cycle. 
% Returns the unmodified list. 
bfs_map_without_cycle(Path, Node, []) :- 
    member(Node, Path). 

% The Node is not within the Path, so we can add it to the list.
bfs_map_without_cycle(Path, Node, [Node|Path]) :- 
    not(member(Node, Path)). 

% TODO: Explain this. Removes empty tails.
remove_empty([], []). 
remove_empty([Head|Tail], NewList) :- 
    Head == [], 
    remove_empty(Tail, NewList). 
remove_empty([Head|Tail], NewList) :- 
    Head \== [], 
    remove_empty(Tail, NewTail), 
    NewList = [Head|NewTail]. 

% Given a path, finds a list of new paths that extend the first node in the 
% path to each neighboring node. Removes paths that are cyclical. 
bfs_obtain_new_paths(Path, NewPaths) :- 
    [Node|_] = Path,

    % Returns a list of terms that match the "neighbor" property (e.g., if 
    % node "a" has two neighbors named "q" and "z", then returns [q, z]). 
    findall(NeighborNode, neighbor(Node, NeighborNode), Neighbors), 

    % Construct a list of paths. If the Path parameter is a list of nodes, then
    % we create a new list with each item in the list being identical to Path 
    % except for the last element, which equals something in Neighbors. This 
    % calls bfs_map_without_cycle(List=[], Path=Path, Node=X, NewList=Y). 
    maplist(bfs_map_without_cycle(Path), Neighbors, NewPathsWithEmpty), 

    % Remove empty elements. 
    remove_empty(NewPathsWithEmpty, NewPaths). 


% Given a list of paths, reduces the list of paths into 0 or 1 results. If one
% of the paths contains Target as the head, then that path is returned;
% otherwise, Result is the empty list. 

% If the PathList is empty, then there's nothing to return.
bfs_reduce(_, [], []). 

% If the PathList's head contains the target as its head, then return that. 
bfs_reduce(Target, PathList, Result) :- 
    [HeadPath|_] = PathList, 
    [HeadNode|_] = HeadPath, 
    HeadNode == Target, 
    Result = HeadPath. 

% The PathList's head is not the target, so skip it and try again on the next
% element of the path list. 
bfs_reduce(Target, PathList, Result) :- 
    [_|Tail] = PathList, 
    bfs_reduce(Target, Tail, Result).


% === TODO: remove mention of Source. 
% bfs_helper(Target, Queue, Path): does the work for a BFS. The queue 
% initially holds the source node. If a path was found, the path should have 
% Source as the first node and Target as the last. If a path was not found, an 
% empty list is given in Path. 
% === 

% If the queue is empty, then the path should also be empty. A path between the 
% source and target nodes was not found. 
bfs_helper(_, [], []). 

% If the queue is not empty, then obtain each of the new paths. Pop the first 
% item off of the queue, get the list of new paths, and check if any of them 
% are the solution.
bfs_helper(Target, Queue, Path) :- 
    [Attempt|_] = Queue, 
    bfs_obtain_new_paths(Attempt, NewPaths), 
    
    % Attempts to reduce the new paths into a single value.
    bfs_reduce(Target, NewPaths, ReducedPath), 

    % First scenario: ReducedList is not an empty list; this means it contains 
    % the final path, so we can return that. 
    ReducedPath \== [], 
    Path = ReducedPath. 

% TODO: can we do this without duplicating?
bfs_helper(Target, Queue, Path) :- 
    [Attempt|Tail] = Queue, 
    bfs_obtain_new_paths(Attempt, NewPaths), 
    
    % Attempts to reduce the new paths into a single value. 
    bfs_reduce(Target, NewPaths, ReducedPath), 

    % Second scenario: ReducedList is an empty list; this means it does not 
    % contain the final path, so Path should be the result of a recursive call. 
    ReducedPath == [], 
    append(Tail, NewPaths, NewQueue), 
    bfs_helper(Target, NewQueue, Path). 


% === TODO: maybe this changed.  
% bfs(Source, Target, Path): finds a path from Source to Target with a 
% breadth-first search. Path may be an empty list [] if there is no path that 
% exists between Source and Target. 
% === 

% If the path between Source and Target does not exist (the queue is empty), 
% the path is also empty. 
bfs(Source, Target, Path) :- 
    bfs_helper(Target, [[Source]], Path). 

node(a). 
node(b). 
node(c). 
node(d). 
node(e). 
node(f). 

/*
neighbor(a, f). 
neighbor(b, c). 
neighbor(c, d). 
neighbor(c, e). 
neighbor(d, b). 
neighbor(e, f). 
neighbor(f, b). 
*/

neighbor(a, f). 
neighbor(b, c). 
neighbor(b, d). 
neighbor(b, f). 
neighbor(c, b). 
neighbor(c, d). 
neighbor(c, e). 
neighbor(d, b). 
neighbor(d, c). 
neighbor(e, c). 
neighbor(e, f). 
neighbor(f, a). 
neighbor(f, b). 
neighbor(f, e).
