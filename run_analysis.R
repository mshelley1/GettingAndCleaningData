# Script for Corusera "Getting and Cleaning Data" final project.
# This script implements the requirements of the final project, including:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average
#    of each variable for each activity and each subject.

#
# Prior to conduting the above, read in the data and explore
#

# Read in data files
## Main directory
#setwd("D:\\Libraries\\Documents\\DataScienceCourse\\03 Getting and Cleaning Data\\week 4\\")

#list.files()
activity_label<-read.table("activity_labels.txt")
features<-read.table("features.txt") #561 features

## "test" directory
setwd(".\\test")
#list.files()            
test_subj<-read.table("subject_test.txt")
test_label<-read.table("y_test.txt")
test_dat<-read.table("X_test.txt")

## "train" directory
setwd(".\\train")
#list.files()            
train_subj<-read.table("subject_train.txt")
train_label<-read.table("y_train.txt")
train_dat<-read.table("X_train.txt")

## Data in "test" directory
#table(test_label) #these correspond to the values in the "activity_lables" file in the main diretory
#head(test_label)
#dim(test_subj)
#head(test_subj)
#dim(test_dat)
#head(test_dat)
#dim(test_subj)

## Data in "train" directory
#table(train_label) #these correspond to the values in the "activity_lables" file in the main diretory
#head(train_label)
#dim(train_subj)
#head(train_subj)
#dim(train_dat)
#head(train_dat)
#dim(train_subj)

#
# 1. Merge the training and the test sets to create one data set.
#

# This needs to be done in two directions. First, create data frames separately for test and train by
# combining columns. Then, since training and test observations are independent, stack rows.

# The three files in test folder all have same number of rows->assume these can be comined using cbind
# to make a dataframe with 2947 rows, subject id, activity id, and the 561 features. First, rename vars,
# using info in "features.txt" for the 561 variables.
names(test_label)<-c("activityLabel")
names(test_subj)<-c("subjectID")
names(test_dat)<-features$V2
dfTest<-cbind(test_subj, test_label, test_dat)
#head(dfTest)
#dim(dfTest)
#str(dfTest)

# Similarly, the three files in train folder have same number of rows -> assume these can be combined wiht cbind
names(train_label)<-c("activityLabel")
names(train_subj)<-c("subjectID")
names(train_dat)<-features$V2
dfTrain<-cbind(train_subj, train_label, train_dat)
#head(dfTrain)
#dim(dfTrain)
#str(dfTrain)

# Combine rows of test and train to create single data set, since documentation said:
# "The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected
#  for generating the training data and 30% the test data"
df<-rbind(dfTrain, dfTest)
#dim(df) #10299 - this is the number of observations expected based on the documentaion

#
# 2. Extract only the measurements on the mean and standard deviation for each measurement.
#

# Use regex to look for variable names with "mean" or "sd" 
meanVars<-grep("mean",names(df))
sdVars<-grep("sd",names(df))

# Subset df to keep only the vars with mean or sd in their names as well as the first two variables which are ids.
df2<-df[,c(1,2,meanVars,sdVars)]
#dim(df2)

#
# 3. Use descriptive activity names to name the activities in the data set
#

# rename the variables in the activity_label data set to merge with activityLabel variable in the main data set
names(activity_label)<-c("activityLabel","activityDesc")

# merge the two dataframes by activityLabel
df3<-merge(x=df2,y=activity_label, by.x="activityLabel", by.y="activityLabel")

# reorder the variiables so activity desctipion is near the begining and drop the activityLabel ID
df3a<-df3[,c(2,ncol(df3),4:ncol(df3)-1)]
#head(df3a)

#
# 4. Appropriately labels the data set with descriptive variable names.
#
# This was done previously in the script by assigning lables from the "features" file to
# the 561 numeric/measurement variables in the data (on or around lines 65 and 74)

#
# 5. From the data set in step 4, creates a second, independent tidy data set with the average
#    of each variable for each activity and each subject.
#

# use dplyr to group and then summarize the data by activity and subject
library(dplyr)

byActSubj<-group_by(df3a, activityDesc, subjectID)
df5<-summarize_each(byActSubj, funs(mean))
#dim(df3a)
#dim(df5)
#head(df5)
#tail(df5)

# write out tidy data set of means
setwd("D:\\Libraries\\Documents\\DataScienceCourse\\03 Getting and Cleaning Data\\week 4\\")
write.table(df5, file="wk4_tidyMeans.txt", row.names=F)
