# Code to test simmr's various functions

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

# Data set 1: 10 obs on 2 isos, 4 sources, with tefs and concdep

# Code to simulate data
# Overall model is y_ij = inprod(p*q,s+c)/sum(p*q) + eps with eps ~ N(0,sigma^2)
# Set the seed
# set.seed(102)
# N = 10
# J = 2
# K = 4
# sigma = c(0.5,0.2)
# s_mean = matrix(c(runif(K,-22,-8),runif(K,2,14)),nrow=K,ncol=J)
# s_sd =matrix(runif(K*J,0.3,0.5),nrow=K,ncol=J)
# c_mean = matrix(runif(K*J,0.5,3.5),nrow=K,ncol=J)
# c_sd =matrix(runif(K*J,0.3,0.7),nrow=K,ncol=J)
# q = matrix(runif(K*J,0.01,0.12),nrow=K,ncol=J)
# s_names=c('Source A','Source B','Source C','Source D')
# p = c(0.5,0.2,0.2,0.1)
# y = matrix(ncol=J,nrow=N)
# y_mean = y_var = rep(NA,J)
# for(j in 1:J) {
#   y_mean[j] = (p*q[,j])%*%(s_mean[,j]+c_mean[,j])/(p%*%q[,j])
#   y_var[j] = ((p^2)*(q[,j]^2))%*%(s_sd[,j]^2+c_sd[,j]^2)/((p%*%q[,j])^2)+sigma[j]^2
#   y[,j] = rnorm(N,mean=y_mean[j],sd=sqrt(y_var[j])) 
# }  
#
# Load into simmr
# simmr_1 = simmr_load(mixtures=y,source_names=s_names,source_means=s_mean,source_sds=s_sd,correction_means=c_mean,correction_sds=c_sd,concentration_means = q)

# Run this with everything outputted propery as in a help file
mix = matrix(c(-10.13, -10.72, -11.39, -11.18, -10.81, -10.7, -10.54, 
-10.48, -9.93, -9.37, 11.59, 11.01, 10.59, 10.97, 11.52, 11.89, 
11.73, 10.89, 11.05, 12.3), ncol=2, nrow=10)
colnames(mix) = c('d13C','d15N')
s_names=c('Source A','Source B','Source C','Source D')
s_means = matrix(c(-14, -15.1, -11.03, -14.44, 3.06, 7.05, 13.72, 5.96), ncol=2, nrow=4)
s_sds = matrix(c(0.48, 0.38, 0.48, 0.43, 0.46, 0.39, 0.42, 0.48), ncol=2, nrow=4)
c_means = matrix(c(2.63, 1.59, 3.41, 3.04, 3.28, 2.34, 2.14, 2.36), ncol=2, nrow=4)
c_sds = matrix(c(0.41, 0.44, 0.34, 0.46, 0.46, 0.48, 0.46, 0.66), ncol=2, nrow=4)
conc = matrix(c(0.02, 0.1, 0.12, 0.04, 0.02, 0.1, 0.09, 0.05), ncol=2, nrow=4)

# Load into simmr
simmr_1 = simmr_load(mixtures=mix,
                     source_names=s_names,
                     source_means=s_means,
                     source_sds=s_sds,
                     correction_means=c_means,
                     correction_sds=c_sds,
                     concentration_means = conc)

# Print
simmr_1

# Plot
plot(simmr_1,xlab=expression(paste(delta^13, "C (\u2030)",sep="")), 
     ylab=expression(paste(delta^15, "N (\u2030)",sep="")), 
     title='Isospace plot of example data set 1')

# Print
simmr_1

# MCMC run
simmr_1_out = simmr_mcmc(simmr_1)

# Print it
print(simmr_1_out)

# Summary
summary(simmr_1_out,type='diagnostics')
summary(simmr_1_out,type='correlations')
summary(simmr_1_out,type='statistics')
ans = summary(simmr_1_out,type=c('quantiles','statistics'))

# Plot
plot(simmr_1_out,type='boxplot')
plot(simmr_1_out,type='histogram')
plot(simmr_1_out,type='density')
plot(simmr_1_out,type='matrix')

# Compare two sources
compare_sources(simmr_1_out,source_names=c('Source A','Source C'))

# Compare multiple sources
compare_sources(simmr_1_out)

#####################################################################################

# No try and get it working on just one observation
simmr_2 = simmr_load(mixtures=mix[1,,drop=FALSE], # Required to keep the mixtures as a matrix 
                     source_names=s_names,
                     source_means=s_means,
                     source_sds=s_sds,
                     correction_means=c_means,
                     correction_sds=c_sds,
                     concentration_means = conc)

# Plot
plot(simmr_2,xlab=expression(paste(delta^13, "C (\u2030)",sep="")), 
     ylab=expression(paste(delta^15, "N (\u2030)",sep="")), 
     title='Isospace plot of example data set 1')

# MCMC run
simmr_2_out = simmr_mcmc(simmr_2)

# Print it
print(simmr_2_out)

# Summary
summary(simmr_2_out)
summary(simmr_2_out,type='diagnostics')
ans = summary(simmr_2_out,type=c('quantiles'))

# Plot
plot(simmr_2_out)
plot(simmr_2_out,type='boxplot')
plot(simmr_2_out,type='histogram')
plot(simmr_2_out,type='density')
plot(simmr_2_out,type='matrix')

#####################################################################################

# Now try running through with three isotopes - two of which overlap on d13C and d15N
# Extra isotope is d34S
# set.seed(102)
# N = 30
# J = 3
# K = 4
# sigma = c(0.5,0.2,0.3)
# s_mean = matrix(c(runif(K,-22,-8),runif(K,2,14),runif(K,5,11)),nrow=K,ncol=J)
# s_sd =matrix(runif(K*J,0.3,0.5),nrow=K,ncol=J)
# c_mean = matrix(runif(K*J,0.5,3.5),nrow=K,ncol=J)
# c_sd =matrix(runif(K*J,0.3,0.7),nrow=K,ncol=J)
# q = matrix(runif(K*J,0.01,0.12),nrow=K,ncol=J)
# s_names=c('Source A','Source B','Source C','Source D')
# p = c(0.5,0.2,0.2,0.1)
# y = matrix(ncol=J,nrow=N)
# y_mean = y_var = rep(NA,J)
# for(j in 1:J) {
#   y_mean[j] = (p*q[,j])%*%(s_mean[,j]+c_mean[,j])/(p%*%q[,j])
#   y_var[j] = ((p^2)*(q[,j]^2))%*%(s_sd[,j]^2+c_sd[,j]^2)/((p%*%q[,j])^2)+sigma[j]^2
#   y[,j] = rnorm(N,mean=y_mean[j],sd=sqrt(y_var[j])) 
# }  
# 
# # Run this through simmr
# simmr_3 = simmr_load(mixtures=y,source_names=s_names,source_means=s_mean,source_sds=s_sd,correction_means=c_mean,correction_sds=c_sd,concentration_means = q)

# Run this with everything outputted propery as in a help file
mix = matrix(c(-11.67, -12.55, -13.18, -12.6, -11.77, -11.21, -11.45, 
               -12.73, -12.49, -10.6, -12.26, -12.48, -13.07, -12.67, -12.26, 
               -13.12, -10.83, -13.2, -12.24, -12.85, -11.65, -11.84, -13.26, 
               -12.56, -12.97, -12.18, -12.76, -11.53, -12.87, -12.49, 7.79, 
               7.85, 8.25, 9.06, 9.13, 8.56, 8.03, 7.74, 8.16, 8.43, 7.9, 8.32, 
               7.85, 8.14, 8.74, 9.17, 7.33, 8.06, 8.06, 8.03, 8.16, 7.24, 7.24, 
               8, 8.57, 7.98, 7.2, 8.13, 7.78, 8.21, 11.31, 10.92, 11.3, 11, 
               12.21, 11.52, 11.05, 11.05, 11.56, 11.78, 12.3, 10.87, 10.35, 
               11.66, 11.46, 11.55, 11.41, 12.01, 11.97, 11.5, 11.18, 11.49, 
               11.8, 11.63, 10.99, 12, 10.63, 11.27, 11.81, 12.25), ncol=3, nrow=30)
colnames(mix) = c('d13C','d15N','d34S')
s_names = c('Source A', 'Source B', 'Source C', 'Source D') 
s_means = matrix(c(-14, -15.1, -11.03, -14.44, 3.06, 7.05, 13.72, 5.96, 
                   10.35, 7.51, 10.31, 9), ncol=3, nrow=4)
s_sds = matrix(c(0.46, 0.39, 0.42, 0.48, 0.44, 0.37, 0.49, 0.47, 0.49, 
                 0.42, 0.41, 0.42), ncol=3, nrow=4)
c_means = matrix(c(1.3, 1.58, 0.81, 1.7, 1.73, 1.83, 1.69, 3.2, 0.67, 
                   2.99, 3.38, 1.31), ncol=3, nrow=4)
c_sds = matrix(c(0.32, 0.64, 0.58, 0.46, 0.61, 0.55, 0.47, 0.45, 0.34, 
                 0.45, 0.37, 0.49), ncol=3, nrow=4)
conc = matrix(c(0.05, 0.1, 0.06, 0.07, 0.07, 0.03, 0.07, 0.05, 0.1, 
                0.05, 0.12, 0.11), ncol=3, nrow=4)

# Load this in:
simmr_3 = simmr_load(mixtures=mix,
                     source_names=s_names,
                     source_means=s_means,
                     source_sds=s_sds,
                     correction_means=c_means,
                     correction_sds=c_sds,
                     concentration_means = conc)

# Get summary
print(simmr_3)

# Plot 3 times
plot(simmr_3,xlab=expression(paste(delta^13, "C (\u2030)",sep="")), ylab=expression(paste(delta^15, "N (\u2030)",sep="")))
plot(simmr_3,tracers=c(2,3),xlab=expression(paste(delta^15, "N (\u2030)",sep="")), ylab=expression(paste(delta^34, "S (\u2030)",sep="")))
plot(simmr_3,tracers=c(1,3),xlab=expression(paste(delta^13, "C (\u2030)",sep="")), ylab=expression(paste(delta^34, "S (\u2030)",sep="")))

# MCMC run
simmr_3_out = simmr_mcmc(simmr_3)

# Print it
print(simmr_3_out)

# Summary
summary(simmr_3_out)
summary(simmr_3_out,type='diagnostics')
summary(simmr_3_out,type='quantiles')
summary(simmr_3_out,type='correlations')

# Plot
plot(simmr_3_out)
plot(simmr_3_out,type='boxplot')
plot(simmr_3_out,type='histogram')
plot(simmr_3_out,type='density')
plot(simmr_3_out,type='matrix')

#####################################################################################

# Lastly create the square of Brian Fry and see what happens
# set.seed(123)
# N = 10
# J = 2
# K = 4
# sigma = c(0.5,0.2)
# s_mean = matrix(c(-25,-25,-5,-5,4,12,12,4),nrow=K,ncol=J)
# s_prec = matrix(1,nrow=K,ncol=J)
# s_sd = 1/sqrt(s_prec)
# s_names=c('Source A','Source B','Source C','Source D')
# p = c(0.25,0.25,0.25,0.25)
# y = matrix(ncol=J,nrow=N)
# y_mean = y_var = rep(NA,J)
# for(j in 1:J) {
#   y_mean[j] = p%*%s_mean[,j]
#   y_var[j] = (p^2)%*%(s_sd[,j]^2)+sigma[j]^2
#   y[,j] = rnorm(N,mean=y_mean[j],sd=sqrt(y_var[j])) 
# }  

# Run this through simmr
#simmr_4 = simmr_load(mixtures=y,source_names=s_names,source_means=s_mean,source_sds=s_sd)

# Run this with everything outputted propery as in a help file
mix = matrix(c(-14.65, -16.39, -14.5, -15.33, -15.76, -15.15, -15.73, 
               -15.52, -15.44, -16.19, 8.45, 8.08, 7.39, 8.68, 8.23, 7.84, 8.48, 
               8.47, 8.44, 8.37), ncol=2, nrow=10)
s_names = c('Source A', 'Source B', 'Source C', 'Source D') 
s_means = matrix(c(-25, -25, -5, -5, 4, 12, 12, 4), ncol=2, nrow=4)
s_sds = matrix(c(1, 1, 1, 1, 1, 1, 1, 1), ncol=2, nrow=4)

# Load this in:
simmr_4 = simmr_load(mixtures=mix,
                     source_names=s_names,
                     source_means=s_means,
                     source_sds=s_sds)

# Get summary
print(simmr_4)

# Plot 
plot(simmr_4)

# MCMC run
simmr_4_out = simmr_mcmc(simmr_4,mcmc.control=list(iter=100000,burn=10000,thin=100,n.chain=4))

# Print it
print(simmr_4_out)

# Summary
summary(simmr_4_out)
summary(simmr_4_out,type='diagnostics')
ans = summary(simmr_4_out,type=c('quantiles','statistics'))

# Plot
plot(simmr_4_out)
plot(simmr_4_out,type='boxplot')
plot(simmr_4_out,type='histogram')
plot(simmr_4_out,type='density')
plot(simmr_4_out,type='matrix')

#####################################################################################

# Use of simmr_elicit

# Data set: 10 observations, 2 tracers, 4 sources
mix = matrix(c(-10.13, -10.72, -11.39, -11.18, -10.81, -10.7, -10.54, 
               -10.48, -9.93, -9.37, 11.59, 11.01, 10.59, 10.97, 11.52, 11.89, 
               11.73, 10.89, 11.05, 12.3), ncol=2, nrow=10)
colnames(mix) = c('d13C','d15N')
s_names=c('Source A','Source B','Source C','Source D')
s_means = matrix(c(-14, -15.1, -11.03, -14.44, 3.06, 7.05, 13.72, 5.96), ncol=2, nrow=4)
s_sds = matrix(c(0.48, 0.38, 0.48, 0.43, 0.46, 0.39, 0.42, 0.48), ncol=2, nrow=4)
c_means = matrix(c(2.63, 1.59, 3.41, 3.04, 3.28, 2.34, 2.14, 2.36), ncol=2, nrow=4)
c_sds = matrix(c(0.41, 0.44, 0.34, 0.46, 0.46, 0.48, 0.46, 0.66), ncol=2, nrow=4)
conc = matrix(c(0.02, 0.1, 0.12, 0.04, 0.02, 0.1, 0.09, 0.05), ncol=2, nrow=4)


# Load into simmr
simmr_1 = simmr_load(mixtures=mix,
                     source_names=s_names,
                     source_means=s_means,
                     source_sds=s_sds,
                     correction_means=c_means,
                     correction_sds=c_sds,
                     concentration_means = conc)

# MCMC run
simmr_1_out = simmr_mcmc(simmr_1)

# Summary
summary(simmr_1_out,'quantiles')
# A bit vague:
#           2.5%   25%   50%   75% 97.5%
# Source A 0.029 0.115 0.203 0.312 0.498
# Source B 0.146 0.232 0.284 0.338 0.453
# Source C 0.216 0.255 0.275 0.296 0.342
# Source D 0.032 0.123 0.205 0.299 0.465

# Now suppose I had prior information that: 
# proportion means = 0.5,0.2,0.2,0.1 
# proportion sds = 0.08,0.02,0.01,0.02
prior=simmr_elicit(simmr_1,c(0.5,0.2,0.2,0.1),c(0.08,0.02,0.01,0.02))

simmr_1a_out = simmr_mcmc(simmr_1,prior.control=list(means=prior$mean,sd=prior$sd))

summary(simmr_1a_out,'quantiles')
# Much more precise:
#           2.5%   25%   50%   75% 97.5%
# Source A 0.441 0.494 0.523 0.553 0.610
# Source B 0.144 0.173 0.188 0.204 0.236
# Source C 0.160 0.183 0.196 0.207 0.228
# Source D 0.060 0.079 0.091 0.105 0.135
