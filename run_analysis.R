# 1,3,4. "full_data" - Fully merged & labeled dataframe
#     2. "mean_dtd_data" - Subset dataframe of mean and standard deviation
#     5. "avg_by_subject_activity" - tidy dataframe with the average of each variable for each activity and each subject
#        "avg_by_subject_activity.txt" - file storing above dataframe

library("plyr")
library("dplyr")

#check if data source exists.  If not, download and unzip.  
if(!file.exists("./UCI HAR Dataset/")){
          fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
          download.file(fileUrl,destfile="UCI HAR Dataset.zip",method="curl")
          unzip("UCI HAR Dataset.zip")
      }

# Read in activity_label and feature table to be used for mapping later
read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activityID","activity")) -> activity_label
read.table("UCI HAR Dataset/features.txt", col.names = c("featureID","feature")) -> feature_label

# Read in test data set.
read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject") -> subject_test
read.table("UCI HAR Dataset/test/X_test.txt") -> data_test
# Read in train data set.
read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject") -> subject_train
read.table("UCI HAR Dataset/train/X_train.txt") -> data_train

#Task 3 (for test data). Uses descriptive activity names to name the activities in the data set
# joined y_test.txt with activity_lables.txt 
read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activityID" ) -> activity_test
subset(join(activity_test,activity_label),select = activity) -> labeled_activity_test
# label test data set's column name 
colnames(data_test) <- feature_label$feature
# merge subject, activity, & train data set.
cbind(subject_test,labeled_activity_test,data_test) -> merged_data_test

#Task 3 (for train data). Uses descriptive activity names to name the activities in the data set
# joined y_train.txt with activity_lables.txt 
read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activityID" ) -> activity_train
subset(join(activity_train,activity_label),select= activity) -> labeled_activity_train
# label train data set's column name 
colnames(data_train) <- feature_label$feature
# merge subject, activity, & train data set.
cbind(subject_train,labeled_activity_train,data_train) -> merged_data_train

#Task 1. Merges the training and the test sets to create one data set.
# merge both test and train data to single data set
# results is stored in "full_data"
rbind(merged_data_test,merged_data_train) -> full_data
#handle duplicate column names: names() appends an incrementing numeric number.  
colnames(full_data) <- names(full_data[,])


# Task 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# only display column with names containing "mean()" or "std()".  Also include subject and activity.
# We could also just do "mean" or "std".  Obviouly, one will just clarify this in the real world. 
# # result is stored in 'mean_std_data' 
select(full_data, subject, activity, matches("mean\\(\\)"), matches("std\\(\\)"))-> mean_std_data

#Task 4. Appropriately labels the data set with descriptive variable names.
#minor cleanup of column names for readibilty. User preference really, as long as it's unique & functional.  Removing "()". 
gsub("\\(\\)","",names(mean_std_data)) ->names(mean_std_data)

# Task 5.  Group table (mean_std_data) by subject then activity.  Calculate the average of each variable (columns) using summarize_each(). 
# results is stored in "avg_by_subject_activity"
mean_std_data %>%
     group_by(subject,activity) %>%
     summarize_each(funs(mean)) -> avg_by_subject_activity
# rename column names with "AVG_" prefix
colnames(avg_by_subject_activity) <- paste("AVG",colnames(avg_by_subject_activity),sep="_")
# write results to file names "avg_by_subject_activity.txt"
write.table(avg_by_subject_activity,file = "avg_by_subject_activity.txt", row.names = FALSE)
View(avg_by_subject_activity)