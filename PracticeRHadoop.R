Sys.setenv(HADOOP_CMD="/home/hadoopuser/hadoop/bin/hadoop")
Sys.setenv("HADOOP_STREAMING"="~/hadoop/share/doc/hadoop/hadoop-mapreduce/hadoop-streaming-2.6.0.jar")
library(rJava)
library(rhdfs)
hdfs.init()
gd = hdfs.file("/user/hadoopuser/Rate_PUF.csv","r")
fd = hdfs.read(gd)
chardata = rawToChar(fd)
library(rmr2)
data = read.table(textConnection(chardata),quote="",sep = ",", header=T,fill = TRUE)
dim(data)  #getting far less data than there is
str(data)
summary(data)
View(data)
dat = hdfs.line.reader("/user/hadoopuser/Rate_PUF.csv")
x = dat$read()
class(x)
datarate = from.dfs("/user/hadoopuser/Rate_PUF.csv",format = make.input.format("csv",sep = ","))
library(plyr)
datafr = as.data.frame(datarate$val)
dataldply = ldply(datarate, data.frame)
#dataldply = as.data.frame(dataldply)
datacolrem = dataldply[ ,-1]
colnames(datacolrem) = as.character(unlist(datacolrem[1,]))
datacolrem = datacolrem[-1, ]






#data1 = read.hdfs("/user/hadoopuser/Rate_PUF.csv")
#data11 = as.matrix(data1$val)
#dim(data11)
#data11 = data11[-1,]
#str(data11)
#colnames(data11) = data11[1,]
#str(data11)

Rate_PUF <- read.csv("~/Rate_PUF.csv")

#########http://htmlpreview.github.io/?https://github.com/andrie/RHadoop-tutorial/blob/master/2-Taxi-analysis-with-RHadoop.html#/8##########

datarate = from.dfs("/user/hadoopuser/Rate_PUF.csv",format = make.input.format("csv",sep = "," , colClasses = "character" , stringsAsFactors = FALSE))
str(datarate)
head(
  values(datarate)
)
headerInfo  = read.csv("/user/hadoopuser/Rate_PUF.csv",stringsAsFactors = FALSE)
headerInfo
colClasses = as.character(as.vector(headerInfo[1, ]))
names(headerInfo)
colClasses
dataratefinal = from.dfs("/user/hadoopuser/Rate_PUF.csv",format = make.input.format("csv",sep = "," ,col.names = names(headerInfo), colClasses = colClasses , stringsAsFactors = FALSE))
