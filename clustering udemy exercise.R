attach(iris)
testdata = iris[,1:3]
kclust = kmeans(testdata,centers=3,nstart=15)
plot(testdata,col=kclust$cluster)
kclust$cluster
testdata$whichcluster= kclust$cluster
str(testdata)
x = testdata$Sepal.Length
y = testdata$Sepal.Width
z = testdata$Petal.Length
plotdata = cbind(x,y,z)
scatterplot3d(x,y,z,highlight.3d = T,col.axis = "blue",col.grid="lightblue",main = "scatterplot 3D",pch=20)
library(rgl)
plot3d(plotdata,col = kclust$cluster)
cluster3 = which(kclust$cluster==3)
cluster3
