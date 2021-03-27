#comparative modeling with multiple templates
from modeller import *              # Load standard Modeller classes
from modeller.automodel import *    # Load the automodel class

class MyModel(automodel):
     def select_atoms(self):
        # Select residues 1 and 2 (PDB numbering)
        #return selection(self.residue_range('1:', '2:'))

        # The same thing from chain A (required for multi-chain models):
        # return selection(self.residue_range('1:A', '2:A'))
        
        # Residues 4, 6, 10:
        # return selection(self.residues['4'], self.residues['6'],
        #                  self.residues['10'])
           return selection(self)
     def user_after_single_model(self):
        # Report on symmetry violations greater than 1A after building
        # each model:
        self.rename_segments(segment_ids=('A', 'B'), renumber_residues=[8, 225])
        # All residues except 1-5:
        #  return selection(self) - selection(self.residue_range('6:A', '28:A'), self.residue_range('42:A', '63:A'))

env = environ()
# directories for input atom files
env.io.atom_files_directory = ['.', '../atom_files']

env.io.hetatm = True
# selected atoms do not feel the neighborhood
# env.edat.nonbonded_sel_atoms = 2

a = MyModel(env,
            alnfile  = 'xxx.ali', # alignment filename
            knowns   = ('3vvw_lir_renum'),     # codes of the templates
            sequence = 'lc3c_ndp52')               # code of the target
a.starting_model= 1                 # index of the first model
a.ending_model  = 100                # index of the last model
                                    # (determines how many models to calculate)
a.make()                            # do the actual comparative modeling
