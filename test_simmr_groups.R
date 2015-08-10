# Code to test simmr's grouping functions

# Clear the workspace if required
# rm(list=ls())

# Choice of installations:
# Cran version
install.packages('simmr')
# github master
devtools::install_github('andrewcparnell/simmr')
# github develop
devtools::install_github('andrewcparnell/simmr',ref='develop')

# Load in
library(simmr)

## Check the vignette if required (doesn't work if installing from github)
#vignette('simmr')

# Note that you can source individual scripts from github via, e.g.
# devtools::source_url("https://raw.githubusercontent.com/andrewcparnell/simmr/develop/R/simmr_mcmc.R")

#####################################################################################

# Use the Geese data from SIAR
#devtools::install_github('andrewljackson/siar')
library(siar)
data(geese2demo,sourcesdemo,correctionsdemo,concdepdemo)

# Now load this with a grouping variable into simmr_load
simmr_in = simmr_load(mixtures=geese2demo[,2:3],
                      source_names=as.character(sourcesdemo[,1]),
                      source_means=sourcesdemo[,c(2,4)],
                      source_sds=sourcesdemo[,c(3,5)],
                      correction_means=correctionsdemo[,c(2,4)],
                      correction_sds=correctionsdemo[,c(3,5)],
                      concentration_means = concdepdemo[,c(2,4)],
                      group=as.integer(geese2demo[,1]))

# Print
simmr_in

# Plot
plot(simmr_in,group=8)

# Run MCMC for each group
simmr_out = simmr_mcmc(simmr_in)


