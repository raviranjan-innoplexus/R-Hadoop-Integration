library(ggplot2)
attach(diamonds)
library(tree)
str(diamonds)
mydata = diamonds[(1:500),]
train = mydata[(1:250),]
mytree = tree(data=train,color~price+x)
summary(mytree)
plot(mytree)
text(mytree)
test = mydata[(251:500),]
mytree.pred = predict(mytree,test,type="class")
table(mytree.pred,test$color)
sum(diag(table(mytree.pred,test$color)))/250
library(randomForest)
set.seed(12)
bagging = randomForest(formula = color~price+x,data=train,mtr=2)
plot(bagging)
randomFor = randomForest(formula = color~price+x,data=train,mtr=1)
importance(randomFor)
varImpPlot(randomFor)
predict.bagging = predict(newdata = test,bagging, type = "class")
predict.randomFor = predict(newdata=test,randomFor,type="class")
table(predict.bagging,test$color)
table(predict.randomFor,test$color)
sum(diag(table(predict.bagging,test$color)))/250
sum(diag(table(predict.randomFor,test$color)))/250