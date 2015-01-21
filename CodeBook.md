#Code Book Final Project
============================

##Variables
============================

* Subject
  * Experimental Subjects # 1 to 30
* Activity
  * Physical Activity
  * laying, sitting, standing, walking, walking downstairs, walking upstairs
* Signals
  * Type of Signal Measured
  * t is a time and f is a frequency measurement
  * BodyAcc, GravityAcc, BodyAccJerk, BodyGyro, BodyGyroJerk, BodyAccMag, GravityAccMag, BodyAccJerkMag, BodyGyroMag
  * BodyGyroJerkMag, BodyAcc, BodyAccJerk, BodyGyro, BodyAccMag, BodyAccJerkMag, BodyGyroMag, BodyGyroJerkMag
  * Different types signals from different types of movements, sometimes BodyBody is included but undefined
  * std() is standard deviation, mean() and meanFreq() is mean
  * X, Y, Z are coordinantes
* Mean
  * Mean of Signals grouped by Subject and Activity
 
##What was done
===========================
1. Libraries dplyr and reshape2 were used
2. Activity and Feature Labels are read, Feature labels that contain std and mean are extracted as these are the measurements used
3. The test subjects, the test labels, and the test data is brought in, combined and and reduced to only the one's used
4. The training subjects, the training labels, and the training data is brought in, combined and and reduced to only the one's used
5. Test and training are combined, factors are created and the data is melted and summarized for the cleaned table.
6. The table is saved as clean.txt