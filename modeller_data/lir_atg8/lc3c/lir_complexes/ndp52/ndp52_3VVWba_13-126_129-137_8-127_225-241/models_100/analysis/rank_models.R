#!/usr/bin/env Rscript 

# rank_models.R - rank and filter homology models according to selected criteria
#
#     Copyright (C) 2019 Matteo Tiberti <matteo.tiberti@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# load Peptides library, that we need for the xvg files parsing function
library("Peptides")

# function that returns TRUE if val is within the value range expressed by
# value_range, FALSE otherwise
single_between <- function(val, value_range) {
    return(val >= value_range[1] && val <= value_range[2])
}

# same as before, but supports angles including wrap-around. Angles and angle
# ranges must be expressed as degrees in the 0-360 range
single_between_ang <- function(ang, ang_range) {
    start = ang_range[1]
    end   = ang_range[2]
    if (start < end) {
        return(start <= ang && ang <= end)
    }
    return(start <= ang || ang <= end)
}

# vectorize the functions defined above, so that they work on vectors
between     = Vectorize(single_between,     vectorize.args=c("val"))
between_ang = Vectorize(single_between_ang, vectorize.args=c("ang"))

# parse command line arguments
args = commandArgs(trailingOnly=TRUE)

# rudimentary check of command line arguments and help 
if (length(args) != 12) {
    stop("Wrong number of arguments. Please provide XVG files and validity range 
limits as arguments, in the following order:\n\
    * Gyration radius
    * SAS residues HP1 and HP2
    * X1 dihedral of residue HP1
    * X1 dihedral of residue HP2
Each filename except the first should be followed by two numbers,
respectively the accepted minimum and maximum value for the property
written in the file. However, for the SAS file, four numbers should be
provided (as we are evaluating SAS for two residues): min HP1, max HP1, min HP2,
max HP2. The units are nm**2 (for sas) and degrees in the 0-360 range
(for dihedrals). For instance:

    ./rank_models.R gyrate.xvg \\
    sasa_residues.xvg 0.0 0.4 0.0 0.4\\
    all_dihedrals/chi1PHE129.xvg 90 180\\
    all_dihedrals/chi1LEU132.xvg 90 180\n\n

A total of 12 arguments are required.", call.=FALSE)
}

# define ranges from command-line arguments, converting them from strings to 
# numerics
sas1_range = as.numeric(args[3:4])
sas2_range = as.numeric(args[5:6])
dih1_range = as.numeric(args[8:9])
dih2_range = as.numeric(args[11:12])

# print out the collected arguments to allow double checking
message(sprintf("
Selected validity ranges:

data       range           file
--------------------------------------------------------------------------------
GyrR                           %s
SAS HP1    [%7.3f, %7.3f]  %s
SAS HP2    [%7.3f, %7.3f]  %s
X1 HP1     [%7.3f, %7.3f]  %s
X1 HP2     [%7.3f, %7.3f]  %s", args[1], sas1_range[1], sas1_range[2], 
args[2], sas2_range[1], sas2_range[2], args[2], dih1_range[1], dih1_range[2], 
args[7], dih2_range[1], dih2_range[2], args[10]))

# parse input files
sas   = readXVG(args[2])
gyrR  = as.numeric(readXVG(args[1])[[2]])
sas1  = as.numeric(sas[[3]])
sas2  = as.numeric(sas[[4]])
dih1  = as.numeric(readXVG(args[7])[[2]])+180
dih2  = as.numeric(readXVG(args[10])[[2]])+180

# check that all the parsed data has the same number of data points
if (! (length(gyrR) == length(sas1) && length(gyrR) == length(dih1) && length(gyrR) == length(dih2))) {
    stop("All files must contain the same number of elements")
}

# for every entry (=model), check if all the properties are within the assigned ranges.
# if they are, the respective value in the isok vector will be TRUE, otherwise FALSE.
isok = between(sas1, sas1_range) & between(sas2, sas2_range) & between_ang(dih1, dih1_range) & between_ang(dih2, dih2_range)

# create dataframe with the loaded values, including the isok vector
data = data.frame(gyrR, sas1, sas2, dih1, dih2, isok)

# sort the dataframe by gyration radius
data = data[order(data$gyrR), ]

# write dataframe as a csv file
write.csv(data, file='ranked_models.csv')

# keep in the dataframe only those entries for which isok is TRUE, meaning that
# all their parameters are within the assigned ranges
data = data[data$isok == TRUE, ]

# save this filtered dataframe as a different csv file
write.csv(data, file='ranked_filtered_models.csv')

