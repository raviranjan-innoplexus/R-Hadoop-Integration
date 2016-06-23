Sys.setenv(HADOOP_CMD="/home/hadoopuser/hadoop/bin/hadoop")
Sys.setenv("HADOOP_STREAMING"="~/hadoop/share/doc/hadoop/hadoop-mapreduce/hadoop-streaming-2.6.0.jar")
library(rJava)
library(rhdfs)
hdfs.init()
library(rmr2)
rmr.options(backend = "local")
taxi.format = make.input.format("csv",sep =",", colClasses = "character", stringsAsFactors = FALSE)
taxi.hdp = "~/trip_data_1_sample.csv"
x = from.dfs(taxi.hdp, format = taxi.format)
str(x)
head(
  values(x)
)
headerInfo = read.csv("~/dictionary_trip_data.csv", stringsAsFactors = FALSE)
headerInfo
colClasses = as.character(as.vector(headerInfo[1, ]))
names(headerInfo)
taxi.format = make.input.format(format = "csv", sep = ",", col.names = names(headerInfo),colClasses = colClasses, stringsAsFactors = FALSE)
x = from.dfs(taxi.hdp, format = taxi.format)
str(values(x))
m = mapreduce(taxi.hdp,input.format = taxi.format)
m
m()
head(
  values(from.dfs(m))
)
####mapreduce with a simple mapper####
taxi.map = function(k,v){
  original = v[[6]]
  original
}
m = mapreduce(taxi.hdp,input.format=taxi.format, map = taxi.map)
head(
  values(from.dfs(m))
)
#######mapreduce showing key value pair #########
taxi.map = function(k,v){
  original=v[[6]]
  date = as.Date(original, origin = "1970-01-01")
  wkday = weekdays(date)
  keyval(wkday, 1)
}
m = mapreduce(taxi.hdp, input.format = taxi.format, 
              map = taxi.map
)
head(
  keys(from.dfs(m)),
  20
  )
head(
  values(from.dfs(m)),
  20
)

###########mapreduce with a reducer############
taxi.map = function(k,v){
  original = v[[6]]
  date = as.Date(original, origin = "1970-01-01")
  wkday = weekdays(date)
  keyval(wkday,1)
}
taxi.reduce = function(k,v){
  keyval(k,sum(v))
}
m = mapreduce(taxi.hdp,input.format = taxi.format, map =taxi.map, reduce = taxi.reduce)
head(
  keys(from.dfs(m))
)
head(
  values(from.dfs(m))
)
###########mapreduce with a sensible mapper#######
taxi.map = function(k,v){
  original = v[[6]]
  date = as.Date(original, origin = "1970-01-01")
  wkday = weekdays(date)
  dat = data.frame(date,wkday)
  z = aggregate(date ~ wkday, dat, FUN = length)
  keyval(z[[1]],z[[2]])
}
taxi.reduce = function(k,v){
  data.frame(weekday = k,trips = sum(v), row.names = k)
}
m = mapreduce(taxi.hdp,input.format = taxi.format,map=taxi.map,reduce = taxi.reduce)
keys(from.dfs(m))
values(from.dfs(m))
#########doing analysis by hour#########
taxi.map = function(k,v){
  original = v[[6]]
  date = as.Date(original, origin = "1970-01-01")
  wkday = weekdays(date)
  hour = format(as.POSIXct(original), "%H")
  dat = data.frame(date, hour)
  z = aggregate(date~hour,dat, FUN = length)
  keyval(z[[1]], z[[2]])
}
taxi.reduce = function(k,v){
  data.frame(hour = k, trips = sum(v), row.names = k)
}
m = mapreduce(taxi.hdp, input.format = taxi.format, map=taxi.map, reduce = taxi.reduce)
keys(from.dfs(m))
dat = values(from.dfs(m))
dat
#######plotting the results#############
library("ggplot2")
p = ggplot(dat,aes(x=hour, y=trips, group=1))+geom_smooth(method=loess,span = 0.5,col ="grey50",fill = "yellow")+geom_line(col="blue")+expand_limits(y=0)+ggtitle("sample of taxi trips in  New York")
p