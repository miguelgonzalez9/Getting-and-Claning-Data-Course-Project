# Code Book for Human Activity Recognition Using Smartphones Dataset 
## ls dataset
This data set divides the Human Activity Recognition into the different signals specified in the features_info file. Each element of the list 'ls' corresponds to the data for the signals listed below. Each signal has X, Y and Z values.\
1 tBodyAcc\
2 tGravityAcc\
3 tBodyAccJerk\
4 tBodyGyro\
5 tBodyGyroJerk\
6 tBodyAccMag\
7 tGravityAccMag\
8 tBodyAccJerkMag\
9 tBodyGyroMag\
10 tBodyGyroJerkMag\
11 fBodyAcc\
12 fBodyAccJerk\
13 fBodyGyro\
14 fBodyAccMag\
15 fBodyBodyAccJerkMag\
16 fBodyBodyGyroMag\
17 fBodyBodyGyroJerkMag\
18 angle
### Angle
The angle element is divided into the following variables:\
1 (tBodyAccMean,gravity)\
2 (tBodyAccJerkMean),gravityMean)\
3 (tBodyGyroMean,gravityMean)\
4 (tBodyGyroJerkMean,gravityMean)\
5 (X,gravityMean)\
6 (Y,gravityMean)\
7 (Z,gravityMean)

Each of the prevous signals, except 'angle', is divded into the following variables. Each variable is applied to X, Y and Z components of each signal.\
mean(): Mean value\
std(): Standard deviation\
mad(): Median absolute deviation\
max(): Largest value in array\
min(): Smallest value in array\
sma(): Signal magnitude area\
energy(): Energy measure. Sum of the squares divided by the number of values.\
iqr(): Interquartile range\
entropy(): Signal entropy\
arCoeff(): Autorregresion coefficients with Burg order equal to 4\
correlation(): correlation coefficient between two signals\
maxInds(): index of the frequency component with largest magnitude\
meanFreq(): Weighted average of the frequency components to obtain a mean frequency\
skewness(): skewness of the frequency domain signal\
kurtosis(): kurtosis of the frequency domain signal\
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
### Label Varible
The label variable specifies the activity that the subject was doing. It is a factor variable.\
1 WALKING\
2 WALKING_UPSTAIRS\
3 WALKING_DOWNSTAIRS\
4 SITTING\
5 STANDING\
6 LAYING
### Subject
Factor variable with levels 1-30, specifying the subject that performed the activity.
### Class
Factor variable with levels "test" and "train" indicating wheather the observation was in the test data or in the train data.

## The test_train dataset
This dataset contains the same data from ls, the difference is that the data isn't divided into signal groups but it's rather presented as a whole.\
The list of variables can be found on the test_train_variables file.\
This data set contains 10299 observation and 564 variables. 
## 'mean_std_data'
These data set takes from the mean and std variables from 'test_train' and stores them in a list containing a dataframe with the mean variables as the first element and a dataframe with the standard deviation variables as the second element. 
## 'avrg' and 'sum_list' Datasets
These datasets summarise the data from the test_train and ls datasets respectively. These datasets contain the average of each variable for each label (activity) and each subject. 
The difference is that avrg presents this as a whole like 'test_train', and 'sum_list' for each signal, like 'ls'. 