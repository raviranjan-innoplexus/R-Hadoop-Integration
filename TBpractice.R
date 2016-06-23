Sys.setenv("HADOOP_CMD"="/home/hadoopuser/hadoop/bin/hadoop")
Sys.setenv("HADOOP_STREAMING"="~/hadoop/share/doc/hadoop/hadoop-mapreduce/hadoop-streaming-2.6.0.jar")
library(rJava)
library(rhdfs)
hdfs.init()
data = hdfs.file("/user/hadoopuser/TB_Burden_Country.csv","r")
data1 = hdfs.read(data)
data2 = rawToChar(data1)
data3 = read.table(textConnection(data2),sep=",",fill=TRUE,header=TRUE)
#data7 = read.table(pipe("hadoop dfs -cat '/user/hadoopuser/TB_Burden_Country.csv'"), sep=",", header=TRUE)
#### method 1 end  #####
TB_Burden_Country <- read.csv("~/TB_Burden_Country.csv")
str(TB_Burden_Country)
summary(TB_Burden_Country)
#####  method 2 begins  #####
library(rmr2)
data4 = from.dfs("/user/hadoopuser/TB_Burden_Country.csv",format = make.input.format("csv",sep=","))
library(plyr)
data5 = ldply(data4,data.frame)
#data10 = data.frame(lNames = rep(names(data4), lapply(data4,length)), lVal = unlist(data4))
data10 = as.data.frame(data4$val)
str(data5)
data7 = data5[ ,-1]
colnames(data7)=as.character(unlist(data7[1,]))
data7 = data7[-1, ]

##### method 3 #######
reader = hdfs.line.reader("/user/hadoopuser/TB_Burden_Country.csv")
x = reader$read()
###### CONVERTING FACTOR TO NUMERIC####
indx = sapply(data10, is.factor)
data10[indx] = lapply(data10[indx], function(x) as.numeric(as.character(x)))
##### problem with the above method is that it only converts numeric and gives NA for FACTORS)
####getting back exact integral value from factors #######
a = as.numeric(paste(data10$V6[-1]))
mean(a)







########reading the file all over again#########
r.file = hdfs.file("/user/hadoopuser/TB_Burden_Country.csv","r")
mapreduce(input = "/user/hadoopuser/TB_Burden_Country.csv",input.format =make.input.format(format="csv",sep=","),map...)


#########mapreduce code#################
small.ints = to.dfs(1:10)
calc = mapreduce(
  input = small.ints, 
  map = function(k, v) cbind(v, v^2))
from.dfs(calc)



