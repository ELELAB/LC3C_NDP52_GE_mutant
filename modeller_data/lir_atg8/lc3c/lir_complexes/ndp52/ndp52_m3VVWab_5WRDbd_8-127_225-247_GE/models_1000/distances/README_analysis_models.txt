#first get a merged pdb file with theseus
#I did it in the folder theseus
#then copy it here 
cp ../theseus/theseus_x86/merged_models.pdb .
#copy model 1 as a reference
cp ../lc3c_ndp52_extend.B99990001.pdb .
#prepare the plumed.dat file writing the atom number of ARG76 CZ and GLY240 CA (to be checked on the pdb file)
#run driver to calculate the distance between the two atoms in the models
/usr/local/plumed-2.3b/bin/plumed driver --plumed plumed.dat --mf_pdb merged_models.pdb 
#open with vim colvar file and remove the first commented line
#run this awk command to find the min distance (i.e. min value of column 2 in the file)
 awk 'min=="" || $2 < min {min=$2; minline=$0}; END{ print minline}' colvar

#in our example is 444.000000 1.242304

since plumed renumber the models from 0 this means that this should be model 445 - open it with pymol to verify the distance and the rest of the model
