
# Script for ...


######## 0. Set the working environemnt, load the survival package and "extramarital.csv" data

# Remove all variables from the R environment to create a fresh start
rm(list=ls())

# Set the working folder
# getwd()
# setwd("/Volumes/DATA/Teaching/SUTD/Courses/2018/The Analytics Edge/week 11/Data/Class 2")

# Install the "survival" package, which includes functions for running the Tobit model
if(!require(survival)){
  install.packages("survival")
  library(survival)
}

# Read the "extramarital.csv" file
exm <- read.csv("extramarital.csv")
str(exm)
# The dataset consists of 6366 observations of 7 variables:
# marriage_rating: 5 = very good, 1 = very poor
# age: 17.5 = under 20, 22 = 20 to 24, ..., 42 = 40 or over 
# yrs_married: 0.5 = less than 1 year, 2.5 = 1 to 4 years ...
# religiosity: 4 = strong, ..., 1 = not
# education: 
# occupation: 6 = professional with advanced degree, 5 = managerial, administration, ... 1 = student
# time_in_affairs: amount of time spent in extra-marital affairs
# The dataset was collected in a survey by Redbbok.


######## 1. Modelling 

# Let's take a better look at the data
table(exm$time_in_affairs>0)
# FALSE  TRUE 
# 4313  2053 
# About 32% of the people are in an affair 
#
# Let's look at the distribution of time_in_affairs
hist(exm$time_in_affairs,100)
#
# Note that in this dataset there is a large number of zeros for the affair variable. If someone
# is not having an affair, a small decrease in one of the predictors may not change his/her
# chances of having an affair in comparison to a person having an affair. One thus needs to account
# for possibly two types of people: those who are unlickely to be moved away from 0 by modest changes
# in the predictors, and those who are not 0 and likely to change by modest change in predictors.
# To do this, we use the Tobit model.

# Create training and test dataset
set.seed(100)
spl <- sample(nrow(exm),0.7*nrow(exm))
train <- exm[spl,]
test <- exm[-spl,]
str(train)
str(test)

# Fit the Tobit model
?Surv     # Create a survival object, usually used as a response variable in a model formula.
?survreg  # Fit a parametric survival regression model.
model1 <- survreg(Surv(time_in_affairs,time_in_affairs>0,type="left")~.,data=train,dist="gaussian")
# This fits a Tobit model where the data are left censored at zero. The error terms are assumed to be gaussian.
summary(model1)
# Let's look at the parameters:
# marriage_rating: negative, meaning that as the marriage rating increases, the chances/length of an affair decrease.
# occupation: positive, meaning that there are greater chances of an affair with a better occupation.
# yrs_married: positive
# religiosity: negative
# Also, note that all coefficients are significant. The model has a log likelihhod of -5436.9.
#
# Prediction
predict1 <- predict(model1,newdata=test) # Prediction provides the latent predicted values of the variables (positive and negative)
# plot(predict1)

# Benchmark model: linear regression
model2 <- lm(time_in_affairs~.,data=train)
summary(model2)
predict2 <- predict(model2,newdata=test)
# plot(predict2)

# Let's compare the two models
table(predict1 <= 0, test$time_in_affairs==0)
#       FALSE TRUE
# FALSE    92   43
# TRUE    523 1252
#
table(predict2 <= 0, test$time_in_affairs==0)
#       FALSE  TRUE
# FALSE   582 1175
# TRUE    33   120
#
# The Tobit model has better accuracy in terms of accounting for 
# the large number of individuals for whom the extramarital affairs variable was 0.



