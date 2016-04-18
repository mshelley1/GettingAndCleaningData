The raw data for this project were spread across several files. The observations included a large variety of measures
derived from accelerometer data about subjects who wore smartphones while performing various tasks. The observations were broken
into a "test" and a "training" set. Each of these sets was further separated into three files containing, respectively,
subject ids, activity ids, and 561 derived measures. 

To process this data and create a single output data file containing the mean of a selelect subset of the 561 measures grouped by 
subject and activity, the following steps were taken:

1. Renamed the variables in the test and training data sets, respectively, to be descriptive. The 561 derived measures
were named using the information in "features" in the main zipped raw data archive. 
2. Created single, separate data sets of the training and test data, respectively, by joining the id columns and derived measures.
3. Created a single data set combining the training and test data by stacking the rows since the variables were the same.
4. Subset the data to keep the identifiers and derived measures which had "mean" or "sd" in their titles.
5. Replaced the numeric activity id with a descriptive label based on the activity file in the main directory of the zipped
raw data archive.
6. Summarized the data to take the average of each selected derived measure by subject and activity.

In the output data set, "subjectID" is the unique identifier of each subject that participated in the study. "activityDesc" is the
textual description of the activity performed. The remaining variables represent the mean of the specified measures for each
subject and activity, and full descriptions of those measures can be found in the original data.

