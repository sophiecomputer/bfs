class Node: 
    def __init__(self, value): 
        self.value = value 
    

    def __repr__(self): 
        return self.value


# Maintain a queue. Each iteration of the bfs finds new things to add to the 
# queue (ensuring there are no cycles) and adds them, checking if the target 
# was reached along the way. 
def bfs(source, target):
    queue = [[source]]
    while len(queue) > 0: 
        # Poll the next item from the queue. 
        path = queue[0] 
        queue = queue[1:] 
        
        # Go through each neighbor, adding them as a new path to the queue. 
        for neighbor in path[-1].neighbors: 
            new_path = path + [neighbor]

            # If we finished our goal. 
            if neighbor == target: 
                return new_path 

            # Else, add to the queue (only if non-circular). 
            elif neighbor not in path: 
                queue.append(new_path) 

    # No path exists (the queue is empty), so return nothing. 
    return [] 


a = Node('a') 
b = Node('b') 
c = Node('c') 
d = Node('d') 
e = Node('e') 
f = Node('f') 

a.neighbors = [f] 
b.neighbors = [c, d, f] 
c.neighbors = [b, d, e] 
d.neighbors = [b, c] 
e.neighbors = [c, f] 
f.neighbors = [a, b, c] 

print(bfs(a, d)) 
