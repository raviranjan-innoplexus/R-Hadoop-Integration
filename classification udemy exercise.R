library(datasets)
attach(iris)
summary(iris)
str(iris)

# test data set
Petal.Width = c(0.7,2.5)
Petal.Length= c(2.4,7)
Species = c("setosa","virginica")
test = data.frame(Petal.Width,Petal.Length,Species)

# LDA 
library(MASS)
mylda = lda(data=iris,Species~Petal.Length+Petal.Width)
#mylda 
plot(mylda)
mylda.prediction = predict(object = mylda, newdata = test[,c(1,2)])$class
mylda.prediction
table(mylda.prediction,test[,3])

#knn
attach(iris)
library(lattice)
with(iris,xyplot(Petal.Length~Petal.Width,group=Species,auto.key=T, pch=20, cex=3))  #grouping on the basis of species type
library(class)  #needed for knn
train = cbind(Petal.Width,Petal.Length)

#test set
Petal.Width1= c(0.7,2.5)
Petal.Length1= c(2.4,7)
Species = c("setosa","virginica")
test = matrix(c(0.7,2.5,2.4,7), nrow=2)


knn(train,test,cl=iris$Species,k=3,prob=T)
