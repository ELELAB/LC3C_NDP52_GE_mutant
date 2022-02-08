. /usr/local/gromacs-2019.4/bin/GMXRC

# create necessary files
cp ../models/lc3c_ndp52.B99990001.pdb .
theseus ../models/lc3c_ndp52.B99990*.pdb
mv theseus_sup.pdb merged_models.pdb
rm theseus_*

# generate required index file
gmx make_ndx -f lc3c_ndp52.B99990001.pdb  -o index.ndx <<eof
ri 1-120
ri 121-137
ri 129 & 8
ri 132 & 8
ri 1-120 | ri 129-132
q
eof

# calculate radius of gyration of the NDP52 peptide
gmx gyrate -f merged_models.pdb -s lc3c_ndp52.B99990001.pdb  -n index.ndx -o gyrate.xvg <<eof
11
eof

# calculate SAS of the side-chains of residues 1 and 4 of the core LIR motif
# this is standard for all motifs, 
gmx sasa -f merged_models.pdb  -s lc3c_ndp52.B99990001.pdb  -o sasa_residues.xvg -n index.ndx -surface -output <<eof
14
12
13
eof

# calculate dihedrals for all residues - we are just interested in the X1 of residues 1
# and 4 of the core LIR motif in this case
mkdir dihedrals; cd dihedrals
gmx chi -f ../merged_models.pdb -s ../lc3c_ndp52.B99990001.pdb  -all -phi -psi -omega -maxchi 6
cd ..

# perform ranking
Rscript rank_models.R gyrate.xvg sasa_residues.xvg 0.0 0.75 0.0 0.5 dihedrals/chi1ILE129.xvg 0 360 dihedrals/chi1VAL132.xvg 0 360

