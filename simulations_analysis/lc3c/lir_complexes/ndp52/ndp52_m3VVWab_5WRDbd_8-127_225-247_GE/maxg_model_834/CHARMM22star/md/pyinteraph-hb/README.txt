#first switch to pyinteraph working environment
workon pyinteraph
#run the script 1 -> read it to understand what is going on on the base of pyinteraph user guide
#we obtain the output called salt-bridges.dat
#it is a list of salt bridges and their persistence (% of frame they are formed according to the distance cutoff) in the ensemble
#we are interested to see if GLU240 of the LIR could make salt bridges with LC3C so you can use grep to figure that out
grep '240' salt-bridges.dat 
 
#NB we used here a large cutoff for salt bridges i.e. 5.5. Ang. just because we want to see if the glutamate even when the LIR is modelled in a extended state (no helix) can form electrostatic interactions - in a normal case with a well folded complex the cutoff could be better to 4.5 or 5
