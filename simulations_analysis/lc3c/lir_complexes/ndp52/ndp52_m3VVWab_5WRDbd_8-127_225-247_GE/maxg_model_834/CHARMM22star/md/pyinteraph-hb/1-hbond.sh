source /usr/local/gromacs-5.1.5/bin/GMXRC.bash 
gmx editconf -f ../../9-md/Mol_An/update.gro -o ini.pdb
#!/bin/bash
traj="../../9-md/Mol_An/center_traj.xtc"
pdb="ini.pdb"



# start trying 5.5 ang. as --sb-co
#ff-masses set to charmm27 is fine for charmm22star too
#if you want to define other modes for the analysis: --sb-mode {different_charge,same_charge,all}
pyinteraph -s ini.pdb -t ../../9-md/Mol_An/center_traj.xtc -r ini.pdb --hb-co 3.0 -y --hb-graph hb-graph.dat --ff-masses charmm27 -v --hb-ad-file hydrogen_bonds.ini
