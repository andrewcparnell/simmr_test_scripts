# Script to compare SIAR and simmr

# Run the geese data through SIAR and look at the posterior credible intervals
rm(list=ls())
library(siar)
data(geese1demo,sourcesdemo,correctionsdemo,concdepdemo)
out_siar = siarmcmcdirichletv4(geese1demo,sourcesdemo,correctionsdemo)
siarhdrs(out_siar)
#              Low 95% hdr High 95% hdr       mode       mean
# Zostera       0.50786171    0.8211434 0.67527455 0.66464603
# Grass         0.03663433    0.1484141 0.08935460 0.09180801
# U.lactuca     0.00000000    0.2375883 0.02742048 0.10073990
# Enteromorpha  0.00000000    0.3121979 0.05829187 0.14280606
# SD1           0.00000000    1.3005495 0.12328536 0.49437182
# SD2           0.00000000    2.1489704 0.92087412 0.99450112
siarmatrixplot(out_siar)

######
# Now run through simmr
library(simmr)
in_simmr = simmr_load(mixtures=geese1demo,
                     source_names=as.character(sourcesdemo[,1]),
                     source_means=sourcesdemo[,c(2,4)],
                     source_sds=sourcesdemo[,c(3,5)],
                     correction_means=correctionsdemo[,c(2,4)],
                     correction_sds=correctionsdemo[,c(3,5)],
                     concentration_means = concdepdemo[,c(2,4)])
plot(in_simmr)
out_simmr = simmr_mcmc(in_simmr)
summary(out_simmr,type='quantiles')
#               2.5%   25%   50%   75% 97.5%
# Zostera      0.423 0.546 0.614 0.687 0.812
# Grass        0.033 0.060 0.074 0.088 0.120
# U.lactuca    0.020 0.072 0.123 0.191 0.320
# Enteromorpha 0.022 0.085 0.153 0.242 0.422
# sd_d15NPl    0.014 0.167 0.360 0.645 1.441
# sd_d13CPl    0.061 0.506 0.869 1.290 2.400
# Broadly comparable
plot(out_simmr,type='matrix')
