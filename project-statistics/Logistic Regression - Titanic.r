# -*- coding: utf-8 -*-

# -- Sheet --

# # Logistic Regression
# ## Titanic


# install packages
install.packages("titanic")
library(titanic)
library(tidyverse)

# ## Review Dataset


head(titanic_train)
glimpse(titanic_train)

# ## Drop NA


titanic_train <- na.omit(titanic_train)
nrow(titanic_train)

# ## Split Data to Train and Test


set.seed(99)
n <- nrow(titanic_train)
id <- sample(1:n, size=n*0.7) #70% train 30% test
train_data <- titanic_train[id,]
test_data <- titanic_train[-id,]

cat("n :", n,
    "\nnrow(train_data) :", nrow(train_data),
    "\nnrow(test_data) :", nrow(test_data)
)

# ## Train and Test Model


## Train_model
train_model <- glm(Survived ~ Pclass + Age,
                   data = train_data,
                   family = "binomial")
p_train <- predict(train_model,
                      type = "response")
train_data$pred_Survived <- ifelse(p_train>=0.5,1,0)
mean(train_data$Survived == train_data$pred_Survived)
summary(train_model)

## Test_model
p_test <- predict(train_model,
                     newdata = test_data,
                     type = "response")
test_data$pred_Survived <- ifelse(p_test >=0.5,1,0)
mean(test_data$Survived == test_data$pred_Survived)

# # Accuracy
# ## Confusion Metrix & Model Evaluation Train & Test


## Confusion Metrix
conM_train <- table(train_data$pred_Survived, train_data$Survived ,
              dnn = c("Predicted", "Actual"))
conM_test <- table(test_data$pred_Survived, test_data$Survived ,
              dnn = c("Predicted", "Actual"))
## Model Evaluation Train
acc_train <-(conM_train[1,1]+conM_train[2,2])/sum(conM_train)
precision_train <- (conM_train[2,2]/(conM_train[2,1]+conM_train[2,2]))
recall_train <- (conM_train[2,2]/(conM_train[1,2]+conM_train[2,2]))
f1_train <- 2*((precision_train*recall_train)/(precision_train+recall_train))

## Model Evaluation Test
acc_test <-(conM_test[1,1]+conM_test[2,2])/sum(conM_test)
precision_test <- (conM_test[2,2]/(conM_test[2,1]+conM_test[2,2]))
recall_test <- (conM_test[2,2]/(conM_test[1,2]+conM_test[2,2]))
f1_test <- 2*((precision_test*recall_test)/(precision_test+recall_test))

cat("Train Confusion Matrix:\n")
print(conM_train)
cat("\n\nTest Confusion Matrix:\n")
print(conM_test)

## Create Dataframe and Summary Model Evaluate
modelEv <- data.frame(Model_name = c("Train model","Test model"),
                     Accuracy = c(acc_train,acc_test),
                     Precision = c(precision_train,precision_test),
                     Recall = c(recall_train,recall_test),
                     F1_Score = c(f1_train,f1_test)
)

cat("Summary Model Evaluate:\n")
modelEv



