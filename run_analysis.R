
## Setting directory for getting training data
## Reading training data for x, y and subject

setwd("J:/Coursera/Getting and cleaning data/FinalProject/Dataset/UCI HAR Dataset/train")
training_x<-read.table("X_train.txt")
training_y<-read.table("y_train.txt")
training_subject<-read.table("subject_train.txt")

## Setting directory for getting testing data
## Reading testing data for x, y and subject

setwd("J:/Coursera/Getting and cleaning data/FinalProject/Dataset/UCI HAR Dataset/test")
testing_x<-read.table("X_test.txt")
testing_y<-read.table("y_test.txt")
testing_subject<-read.table("subject_test.txt")

## Setting directory for getting feature and activity dataset
## Reading training data for x, y and subject
setwd("J:/Coursera/Getting and cleaning data/FinalProject/Dataset/UCI HAR Dataset")
features <- read.table("features.txt")
activityLabels = read.table("activity_labels.txt")

## Assigning the required column names to the respective table values
colnames(training_x) <- features[,2] 
colnames(training_y) <-"activityId"
colnames(training_subject) <- "subjectId"
colnames(testing_x) <- features[,2] 
colnames(testing_y) <-"activityId"
colnames(testing_subject) <- "subjectId"
colnames(activityLabels) <- c('activityId','activityType')


# Merging the required feuture of x (training_x), training-y and training_subject
# Similarly doing for testing data.
#  Binding them together to make full data
training_data_merged <- cbind(training_y, training_subject, training_x)
testing_data_merged <- cbind(testing_y, testing_subject, testing_x)
Full_data <- rbind(training_data_merged, testing_data_merged)
Full_data_names<-colnames(Full_data)

#Calculating mean and std for each row
mean_and_std <- (grepl("activityId" , Full_data_names) | 
                   grepl("subjectId" , Full_data_names) | 
                   grepl("mean.." , Full_data_names) | 
                   grepl("std.." , Full_data_names) 
)

#Making necessary subset
MeanAndStd <- Full_data[ , mean_and_std == TRUE]
#Naming the activities in the dataset
ActivityNames <- merge(MeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

#Creating other dataset with the average of each variable for each activity and each subject
second_TidySet <- aggregate(. ~subjectId + activityId, ActivityNames, mean)
second_TidySet <- second_TidySet[order(second_TidySet$subjectId, second_TidySet$activityId),]
# Writing that dataset to table
write.table(second_TidySet, "second_TidySet.txt", row.name=FALSE)
