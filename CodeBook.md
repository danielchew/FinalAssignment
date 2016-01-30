---
title: "CodeBook.md"
output: html_document
---
##Variables in avg_by_subject_activity.txt file
* subject - The subject ID in the experiment.  Range from 1 to 30
* activity - The type of activities considered in the experiment (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)

* All the other variables with prefix of "AVG_" are  averages of each varibles grouped by activty and subject. The definition of the specific variables themself (ignoring the AVG prefixes) can be found in feature_info.txt.

##Data

### Key dataframes
* full_data - Fully merged & labeled dataframe (Task 1,3,4)
* mean_std_data - Subset dataframe of mean and standard deviation (Task 2)
* avg_by_subject_activity - tidy dataframe with the average of each variable for each activity and each subject (from mean_std_data table) (Task 5)

###Other temporary dataframes created:
* activity_label - Mapping table for activity and activity ID
* activity_test - test activity list
* activity_train - train activity list
* subject_test - test subject list
* subject_train - train subject list
* labeled_activity_test - labeled test activity list 
* labeled_activity_train - labeled train activity list 
* data_test - merged data with subject and activity for test subjects
* data_train - merged data with subject and activity for train subjects
* feature_label - list of all features
* merged_data_test - test dataset with activities and subjects combined.
* merged_data_train - train dataset with activities and subjects combined.

##Tranformation
* Test and training dataset are merged with thier respective subject IDs and activity IDs. 
* Activity IDs are mapped into activity description using 'join'  activity ID is discarded. 
* removed unnecessary strings (e.g. "()") from column names. 
* A subset ot the table is extracted using 'select' function.  Only column names with mean(), std(), activity and subject are kept
* group the above table by activity and subject, then calculated the average for each remaining variable. 
