Computational Biology Laboratory, Danish Cancer Society Research Center, Strandboulevarden 49, 2100, Copenhagen, Denmark

Repository associated to the publication:

XXXX

contact person for the repository: Elena Papaleo, elenap@cancer.dk


The repository contains the input data for modeling and simulations, outputs from analyses and associated scripts 
to reproduce our data. 

The MD trajectories have been deposited in OSF due to space limitation. They can be downloaded from here: XXX

More detailed README files are in each subfolder to guide the user.

Please cite our publication if you use the material in this repository.


The XXX main folders in the repository contains:

pdb -> a folder with the initial pdb structures (from PDB) used in the study
modeller_runs -> the files and scripts to generate the models of the complexes
modeller_data -> the files and scripts to reproduce the model selection for simulations 
simulations -> templates files for gromacs to run preparation, md and metaD simulations + bash scripts for the preparation steps
simulations_analysis -> folders, scripts, input and outputs to reproduce the analyses of md simulations or metadynamics

NOTES

The numbering of the PDB and GRO file of the complex LC3C-NDP52 G->E mutant has been shifted of 100 amino acids with respect
to what reported in UNIPROT for practical purposes. Thus E140 will be E240 in the PDB, XTC and GRO files, as an example to orient the reader.
 

