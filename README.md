# Merge step of DBSCAN algorithm using Prolog

## Instructions

1. Start terminal and `cd` into the directory OR open SWI-Prolog
2. Write `swipl` (if using the terminal)
3. Write `consult("import.pl").`
4. Write `import.`
5. Write `mergeClusters(L),open('clusters.txt',write,F),write(F,L),close(F).`

## Description

This implementation focuses on the third step of the parallel DBSCAN algorithm. We will merge intersecting clusters from adjacent partitions.
The parallel DBSCAN algorithm extracts the clusters of a set by subdividing the region into a number of
overlapping partitions. If the partitions overlap with each other, it implies that some points (at the periphery of the partitions) might belong to more than one partition. Consequently, some clusters may contain the same point(s) and are then said to intersect. In this case, these clusters must be merged
because they should in fact constitute one large cluster covering more than one partition. The merging can be simply done by changing the label of one of the clusters to the one of the second. 

## Algorithm explanation

<p align="center">
  <img src="https://user-images.githubusercontent.com/71091659/161274255-009e603e-bf05-40c9-8aee-fca4c2aa1870.jpg"
</p>

Suppose we have the 5 points of cluster A and the 8 points of cluster C in current ClusterList. We
are now processing the partition containing clusters B and D. We first consider cluster D; it has no
intersection with the points in ClusterList so its 4 points will simply be added to the list. Now if
we consider cluster B, it has 3 points intersecting with cluster A and 4 points intersecting with cluster C.
These 7 points will constitute the intersection set I and the labels of I are A and C. Consequently, the
cluster label of all points in ClusterList having label A will be changed to B and same for the
points having label C. Finally, the points in B are inserted into the ClusterList. 
  
## Results
Here is the list of groups obtained after merging.
There were 25 groups initially, after the merge step there are 21 left.

Cluster ID before merge step:
  
[65000001,65000002,65000003,65000004,74000001,74000002,74000003,75000001,75000002,
 76000001,76000002,76000004,76000003,84000001,84000003,84000002,84000004,85000004,
 85000001,85000002,85000003,85000007,85000005,85000006,86000001]

Cluster ID after merge step:
  
[65000001,65000002,65000003,65000004,74000001,74000002,75000002,76000001,76000002,
 76000004,76000003,84000003,84000002,84000004,85000004,85000001,85000002,85000003,  
  85000007,85000005,86000001]

Clusters ID that were removed: 74000003,75000001,84000001,85000006.
  
___________________________________________________________________
  
From CSI2520 (Programming Paradigms) Course - Prolog Project
