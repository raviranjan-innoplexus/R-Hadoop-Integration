Sys.setenv(HADOOP_CMD="/home/hadoopuser/hadoop/bin/hadoop")
Sys.setenv("HADOOP_STREAMING"="~/hadoop/share/doc/hadoop/hadoop-mapreduce/hadoop-streaming-2.6.0.jar")
library(rJava)
library(rhdfs)
hdfs.init()
library(rmr2)
rmr.options(backend = "hadoop")
taxi.format = make.input.format("csv",sep =",", colClasses = "character", stringsAsFactors = FALSE)
taxi.hdp1 = "/user/hadoopuser/trip_data_1_sample.csv"
x1 = from.dfs(taxi.hdp1, format = taxi.format)
str(x1)
head(
  values(x1)
)
headerInfo1 = read.csv("~/dictionary_trip_data.csv", stringsAsFactors = FALSE)
headerInfo1
colClasses1 = as.character(as.vector(headerInfo1[1, ]))
names(headerInfo1)
taxi.format1 = make.input.format(format = "csv", sep = ",", col.names = names(headerInfo1),colClasses = colClasses1, stringsAsFactors = FALSE)
x1 = from.dfs(taxi.hdp1, format = taxi.format1)
str(values(x1))
m1 = mapreduce(taxi.hdp1,input.format = taxi.format1)
m1
m1()
head(
  values(from.dfs(m1))
)