# ------------ READ THE README FILE FIRST! -----------------------
# Variables Used:

As described in the README, I used regular expressions to extract only the data fields that contained "mean()" or "std()" in their name, along with the subject number and activity label (converted from numeric key to string).  There were many other sets of variables in the data sets, but only those mentioned below were used.

I then proceeded to LABEL the data set using the actual variable names from the features.txt file.  

# Variables Included:
## The mean and standard deviation of each of the following:
1. tBodyAcc-XYZ
2. tGravityAcc-XYZ
3. tBodyAccJerk-XYZ
4. tBodyGyro-XYZ
5. tBodyAccMag
6. tGravityAccMag
7. tBodyAccJerkMag
8. tBodyGyroMag
9. tBodyGyroJerkMag
10. fBodyAcc-XYZ
11. fBodyAccJerk-XYZ
12. fBodyGyro-XYZ
13. fBodyAccMag
14. fBodyAccJerkMag
15. fBodyGyroMag
16. fBodyGyroJerkMag

Notes:

* all variables starting with "t" refer to time domain variables, while those starting with "f" have had Fast Fourier Transform applied to them and are in the frequency domain.
* Variables come from 3-axial raw signals from accelerometer and gyroscopes.
* Jerk is the time derivative of acceleration.
* X, Y, Z refer to dimensions in Euclidean space.
