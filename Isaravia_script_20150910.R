

#devtools::install_github('andrewcparnell/simmr')
library(simmr)
library(RCurl)

x <- getURL("https://raw.githubusercontent.com/AndrewLJackson/SIAR-examples-and-queries/master/siar-mixing-models/sourcesdemo.txt")
sources <- read.table(text=x,header=TRUE,stringsAsFactors = F)
x <- getURL("https://raw.githubusercontent.com/AndrewLJackson/SIAR-examples-and-queries/master/siar-mixing-models/geese1demo.txt")
consumers <- read.table(text=x,header=TRUE)
x <- getURL("https://raw.githubusercontent.com/AndrewLJackson/SIAR-examples-and-queries/master/siar-mixing-models/correctionsdemo.txt")
corr <- read.table(text=x,header=TRUE,stringsAsFactors = F)

sm1 <- simmr_load(mixtures=as.matrix(consumers),
                  source_names=sources$Means,
                  source_means = sources[,c(2,4)],
                  source_sds = sources[,c(3,5)],
                  correction_means = corr[,c(2,4)],
                  correction_sds = corr[,c(3,5)]
)

print(sm1)

plot(sm1)

sm1_out = simmr_mcmc(sm1)

require(coda)

traceplot(sm1_out$output[[1]])

is.mcmc.list(sm1_out$output[[1]])

colnames(as.matrix(sm1_out$output[[1]]))


x = getURL("https://raw.githubusercontent.com/AndrewLJackson/SIAR-examples-and-queries/master/siar-mixing-models/geese2demo.txt")
consumers <- read.table(text=x,header=TRUE,stringsAsFactors = FALSE)
x = getURL("https://raw.githubusercontent.com/AndrewLJackson/SIAR-examples-and-queries/master/siar-mixing-models/concdepdemo.txt")
concs <- read.table(text=x,header=TRUE,stringsAsFactors = FALSE)

sm2 <- simmr_load(mixtures=as.matrix(consumers[,c(3,2)]),
                  source_names=sources$Means,
                  source_means = sources[,c(4,2)],
                  source_sds = sources[,c(5,3)],
                  correction_means = corr[,c(4,2)],
                  correction_sds = corr[,c(5,3)],
                  concentration_means = concs[,c(4,2)],
                  group=consumers[,1]
)

print(sm2)

plot(sm2,group=c(3,5))
