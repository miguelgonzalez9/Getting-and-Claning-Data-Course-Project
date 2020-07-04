library(data.table)
library(dplyr)
library(plyr)
library(readr)
#Tidying Data. 
##Download Data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./pojdata.zip")

## Getting Test Data
test_labels <- readLines("/Users/miguel/Desktop/Data\ Science/Getting\ and\ Cleaning\ Data/Getting-and-Claning-Data-Course-Project/UCI\ HAR\ Dataset/test/y_test.txt")
test_subject <- readLines("/Users/miguel/Desktop/Data\ Science/Getting\ and\ Cleaning\ Data/Getting-and-Claning-Data-Course-Project/UCI\ HAR\ Dataset/test/subject_test.txt")
datafile <- "/Users/miguel/Desktop/Data\ Science/Getting\ and\ Cleaning\ Data/Getting-and-Claning-Data-Course-Project/UCI\ HAR\ Dataset/test/X_test.txt"
testraw <- fread(text = readLines(datafile), header = F)
class <- rep("test", 2947) #Creating new variable indicaing class; test or train.
test <-tbl_df(mutate(testraw, label = factor(test_labels), subject = factor(test_subject, levels = c(1:30)), class = class))


## Getting Train Data
train_labels <- readLines("/Users/miguel/Desktop/Data\ Science/Getting\ and\ Cleaning\ Data/Getting-and-Claning-Data-Course-Project/UCI\ HAR\ Dataset/train/y_train.txt")
train_subject <- readLines("/Users/miguel/Desktop/Data\ Science/Getting\ and\ Cleaning\ Data/Getting-and-Claning-Data-Course-Project/UCI\ HAR\ Dataset/train/subject_train.txt")
df <- "/Users/miguel/Desktop/Data\ Science/Getting\ and\ Cleaning\ Data/Getting-and-Claning-Data-Course-Project/UCI\ HAR\ Dataset/train/X_train.txt"
trainraw <- fread(text = readLines(df), header = F) 
class_train <- rep("train", 7352) #Creating new variable indicaing class; test or train.
train <- mutate(trainraw, label = factor(train_labels), subject = factor(train_subject, levels = c(1:30)), class = class_train)


## Merging Both Datasets by Rows.
all(colnames(train) == colnames(test)) # Checking if all colnames are the same.
test_train <- bind_rows(train, test) # Binding both datasets by rows.
test_train$class <- factor(test_train$class, levels = c("test", "train"))# Converting class variable into a factor variable.


## Adding features names.
features <- readLines("/Users/miguel/Desktop/Data\ Science/Getting\ and\ Cleaning\ Data/Getting-and-Claning-Data-Course-Project/UCI\ HAR\ Dataset/features.txt")
features <- features %>%  
        sub(pattern = "[0-9]* +", "", .) %>% 
        gsub("\\()", "", .)
features <- make.unique(features, sep = "-")## Avoide having repeated variable names.
features
colnames(test_train) <- c(features, "label", "subject", "class")
View(test_train[,461:502])

## Adding descriptive Acvtivity Names.
activity <- read.table("/Users/miguel/Desktop/Data\ Science/Getting\ and\ Cleaning\ Data/Getting-and-Claning-Data-Course-Project/UCI\ HAR\ Dataset/activity_labels.txt")[,2]
activity <- tolower(activity)
test_train$label <-  mapvalues(test_train$label, from = c(1:6), to = activity)# Changing level names.

##The next code dives the dataset into a list called ls containing one dataframe for each signal.
## It's important to say that in the features_info.txt file the signal names fBodyAccJerkMag
##fBodyGyroMag and fBodyGyroJerkMag where changed to fBodyBodyAccJerkMag,fBodyBodyGyroMag 
## and fBodyBodyGyroJerkMag in order to match the varnames in the data.
path <- "/Users/miguel/Desktop/Data\ Science/Getting\ and\ Cleaning\ Data/Getting-and-Claning-Data-Course-Project/UCI\ HAR\ Dataset/features_info.txt"
varnames <- read_lines(path, skip = 12, n_max = 17) # Reading the signal names
varnames <- gsub("-XYZ", "", x = varnames) #Cleaning the names from unwanted characters.
varnames <- gsub("\t", "", x = varnames)
ls <- vector("list", length = length(varnames)+1) # One more element for the angle signal, which isn't included in varnames.
### This for loop identifies the variables that correspond to each signal and appends them as a 
### data frame to ls. 
for (i in 1:length(varnames)) {
        y <- select(.data = test_train, grep(paste0(varnames[i], "-"), colnames(test_train), value = T))
        colnames(y) <- gsub(paste0(varnames[i], "-"), replacement = "", x = colnames(y))
        ls[[i]] <- mutate(y, label = test_train$label, class = test_train$class, subject = test_train$subject)
}
w <- select(.data = test_train, grep("angle", colnames(test_train), value = T))# Adding angle variable.  
colnames(w) <- gsub("angle", "", x = colnames(w))
ls[[18]] <- mutate(w, label = test_train$label, class = test_train$class, subject = test_train$subject)
names(ls) <- c(varnames, "angle") ## Naming each signal in ls. 

## This part of the code selects mean and std variables and creates a list called mean_std_data containig
## a dataframe of the mean varibales and a dataframe of std variables.
mean <- select(.data = test_train, grep("mean[^Freq]", x = colnames(test_train)))
m <- mean
colnames(mean) <- sub("mean", "", colnames(mean))
std <- select(.data = test_train, grep("std", x = colnames(test_train)))
s <- std
colnames(std) <- sub("std", "", colnames(std))
mean_std_data <- list(mean = mean,std = std)
msdat <- cbind.data.frame(m, s)## Getting all std and mean data in one data frame.

## Grouping by activity and subject and summarizing by mean in both test_train and ls datasets. 
###Sumamrizing in test_train.
avg <- test_train %>%  group_by(subject, label) %>% summarise_all(funs(mean))
### Summarizing in ls.
sum_list <- vector("list", length = 18)
for (i in 1:18) {
        sum_list[[i]] <- ls[[i]][,-"class"] %>% group_by(subject, label) %>% summarise_all(funs(mean)) 
}
names(sum_list) <- c(varnames, "angle")