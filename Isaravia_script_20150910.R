

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
