source /usr/local/gromacs-5.1.5/bin/GMXRC.bash 
gmx editconf -f ../../../9-md/Mol_An/update.gro -o ini.pdb
#!/bin/bash
traj="../../../9-md/Mol_An/center_traj.xtc"
pdb="ini.pdb"



# start trying 5.5 ang. as --sb-co
#ff-masses set to charmm27 is fine for charmm22star too
#if you want to define other modes for the analysis: --sb-mode {different_charge,same_charge,all}
pyinteraph -s $pdb -t $traj -r $pdb --sb-co 6.0 -b --sb-graph sb-graph.dat --ff-masses charmm27 -v --sb-cg-file charged_groups.ini
