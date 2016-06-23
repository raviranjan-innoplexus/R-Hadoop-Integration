Sys.setenv(HADOOP_CMD="/home/hadoopuser/hadoop/bin/hadoop")
Sys.setenv("HADOOP_STREAMING"="~/hadoop/share/doc/hadoop/hadoop-mapreduce/hadoop-streaming-2.6.0.jar")
library(rJava)
library(rhdfs)
hdfs.init()
library(rmr2)
rmr.options(backend = "hadoop")
gd = hdfs.file("/user/hadoopuser/Rate_PUF.csv","r")
fd = hdfs.read(gd)
rate.format = make.input.format("csv", sep = ",",colClasses = "character",stringsAsFactors=FALSE)
rate.hdp = "/user/hadoopuser/Rate_PUF.csv"
x = from.dfs("/user/hadoopuser/Rate_PUF.csv", format = rate.format)
str(x)
head(
  values(x)
)
headerInfo = read.csv("~/rate_pufdatatype.csv",stringsAsFactors = FALSE)
colClasses = as.character(as.vector(headerInfo[1, ]))
names(headerInfo)
colClasses
x = x$val[-1,]
colnames(x) = names(headerInfo)


######bekaar#########
write.csv(x,"x.csv")
rate.format = make.input.format(format = "csv", sep=",",col.names = names(headerInfo), stringsAsFactors = FALSE)
x1 = from.dfs("/user/hadoopuser/Rate_PUF.csv",format = rate.format)


######### ab modified file pe suru se sab karo ########## koi kaam ka nahi hua
rate1.format = make.input.format("csv",sep = ",",colClasses = "character", stringsAsFactors = FALSE)
rate1.hdp = "/user/hadoopuser/x.csv"
y = from.dfs(rate1.hdp, format=rate1.format)
str(y)

########### naya ######## koi kaam ka nhi hua
rate2.format = make.input.format("csv", sep = ",",colClasses = "character", stringsAsFactors = FALSE)
rate2.hdp  = "/user/hadoopuser/x1.csv"
z = from.dfs(rate2.hdp, format = rate2.format)

##############aage badte hain##########
m = mapreduce(rate.hdp, input.format = rate.format)
head(
  values(from.dfs(m))
)


