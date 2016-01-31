# GettingAndCleaningData
Course Project for Getting and Cleaning Data

Enclosed is my submission for the "Getting And Cleaning Data" Course Project.

How to run:
1. Retrieve the "run\_analysis.R" script from the repository.  If you need to run it yourself, it is easiest to retrieve all the same data in the repo directory as well.
2. Add the directory containing both the R script and the input data to your R environment path.
  * Example: If you pulled everything to the /home/derp/RProject directory, enter "setwd \"/home/derp/RProject\"" in an RStudio terminal.
3. Source the R script so that it may be run:
  * "source \"run\_analysis.R\"" inside RStudio.
4. Execute the script by running the "main" method in an R/RStudio terminal:
  * "main()".  This will write a new, tidy data set to the directory containing the R script that is called \"tidyDataOutputSet.txt\".  If you want a different output name, you may specify that file name as the first function argument.

The general layout of the script is as follows:
1. Read the following files with read.table():
  1. "subject\_test.txt"
  2. "subject\_train.txt"
  3. "y\_test.txt"
  4. "y\_train.txt"
  5. "X\_test.txt"
  6. "X\_train.txt"
2. Perform a column-stack of the 3 test data sets to make a master test set
3. Perform a column-stack of the 3 train data sets to make a master train set
4. Perform a row-stack of the 2 master sets to create an entire merged set.
5. Read in the "activity\_levels.txt" file with read.table().  This generates the names of the activities corresponding to the numeric keys in the merged set.
6. Map the activity names to numeric indices in the 2nd column of the merged set and apply the mapping to the merged set.
7. Read the "features.txt" file to determine the name of each of the data fields.
8. Append \"SubjectNumber\" and \"ActivityLabel\" to the front of that data field name list.  This is because those fields appear first in the merged set.
9. Apply the name list to the merged set data frame using the colnames method.
10. Using regular expressions, discard from the merged set any data fields that do not contain \"mean()\" or \"std()\".  
11. Sort the data by \"SubjectNumber\" and \"ActivityLabel\".
12. For each subject/activity combination, compute the mean of each data field and concatenate all of those observations into a single data frame.  This represents your tidy data set.
13. Write the output data set to the output file.

