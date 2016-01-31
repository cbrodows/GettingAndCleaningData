
# #######################################################
#
#             Functions for reading the data
#
# #######################################################

read_file <- function(filename, read_option=1) {
  read_data <- data.frame()
  
  # Check for file existence
  # TODO: Obviously, this belongs in a tryCatch block in practice
  #       but we'll stick to what has been talked about in class
  if (file.exists(filename)) {
    if (read_option == 1) {
      read_data <- read.table(filename)
    }
    else {
      print("TODO!")
      quit
    }
  }
  else {
    out_string <- sprintf("Error: File \"%s\" does not exist; exiting...",
                          filename)
    quit
  }
  return(read_data)
}

get_data_dir <- function() {
  return("")
  #return("./data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")
}

read_y_train <- function() {
  print("Reading y_train...")
  #fname <- sprintf("%s/train/y_train.txt", get_data_dir())
  fname <- "y_train.txt" #, get_data_dir())
  return (read_file(fname))
}

read_y_test <- function() {
  print("Reading y_test...")
  #fname <- sprintf("%s/test/y_test.txt", get_data_dir())
  fname <- "y_test.txt" #, get_data_dir())
  return (read_file(fname))
}

read_x_train <- function() {
  print("Reading X_train...")
  #fname <- sprintf("%s/train/X_train.txt", get_data_dir())
  fname <- "X_train.txt" #, get_data_dir())
  return (read_file(fname))
}

read_x_test <- function() {
  print("Reading X_test...")
  #fname <- sprintf("%s/test/X_test.txt", get_data_dir())
  fname <- "X_test.txt" #, get_data_dir())
  return (read_file(fname))
}

read_subject_test <- function() {
  print("Reading subject_test...")
  #fname <- sprintf("%s/test/subject_test.txt", get_data_dir())
  fname <- "subject_test.txt" #, get_data_dir())
  return (read_file(fname))
}

read_subject_train <- function() {
  print("Reading subject_train_test...")
  #fname <- sprintf("%s/train/subject_train.txt", get_data_dir())
  fname <- "subject_train.txt" #, get_data_dir())
  return (read_file(fname))
}

# ##################################################
#
#           Function for merging the data
#
# ##################################################

get_merged_data <- function(subject_test, 
                            subject_train,
                            y_test,
                            y_train,
                            x_test,
                            x_train) {
  
  # 1) Vertical stack of test data
  print("Stacking Test set...")
  test_set <- cbind(subject_test, y_test, x_test)
  
  # 2) Vertical stack of train data
  print("Starting Train set...")
  train_set <- cbind(subject_train, y_train, x_train)
  
  # 3) Column stack of test/train data
  print("Combining test and train sets...")
  merged_set <- rbind(test_set, train_set)
  return(merged_set)
}

# Wrapper function to do all reading/merging in one call
# from main()
get_merged <- function() {
  return (get_merged_data(read_subject_test(),
                          read_subject_train(),
                          read_y_test(),
                          read_y_train(),
                          read_x_test(),
                          read_x_train()))
}

# ###################################################
#
#         Which columns are the mean and 
#              standard deviation?
#
# NOTE: As specified in the Markdown file, I do this
#       step immediately after Step 4, since it makes
#       more sense to do it that way in the first place.
#
# ###################################################

# I am choosing any columns that have mean() or std() in their
# names
valid_columns <- function(dframe) {
  
  # Strictly speaking, this should be checking that the string
  # starts with Subject or Activity, and then mean()/std()
  # can happen anywhere within, but in this case it still works
  # because of the names chosen.
  matches <- grep('Subject|Activity|mean\\(\\)|std\\(\\)', 
                  colnames(dframe))
  return(dframe[,matches])
}

# ##################################################
#
#       Replace activity key numbers with
#                activity names
#
# ##################################################

get_lookup_vector <- function() {
  print("Reading activity labels file...")
  filename = "activity_labels.txt" #,
             #        get_data_dir())
  return(read.table(filename))
}

apply_lookup_vector <- function(dframe, column_index,
                                lookup_vector) {
  print("Mapping the lookup vector...")
  named_column <- lookup_vector[dframe[, column_index],2]
  print("Inserting the mapped results to dframe...")
  dframe[, column_index] <- named_column
  return(dframe)
}

replace_w_lookup_vector <- function(merged_data,
                                    column_index=2) {
  lookup_vector <- get_lookup_vector()
  return(apply_lookup_vector(merged_data, column_index,
                             lookup_vector))
}

# ###############################################
#
# Label the data set with descriptive names
#
# ###############################################

read_features <- function() {
  print("Reading features.txt...")
  filename = "features.txt" #, get_data_dir())
  return(read.table(filename))
}

concat_features <- function(features) {
  print("Appending 'SubjectNumber' and 'ActivityLabel' to front of feature vector...") 
  first_feature_names <- c("SubjectNumber", "ActivityLabel")
  temp_vector <- c(first_feature_names, 
                   as.character(features[,2]))
  
  # TODO: Any other changes to the names would go here
  print("TODO: Any more changes?")
  return(temp_vector)
}

apply_colnames <- function(dframe, feature_names) {
  print("Applying column names to dframe...")
  colnames(dframe) <- feature_names
  return(dframe)
}

get_and_apply_colnames <- function(dframe) {
  feature_names <- read_features()
  return(apply_colnames(dframe, concat_features(feature_names)))
}

# #################################################
#
#             Create new data set
#
# #################################################

remove_unneeded_columns <- function(dframe) {
  return(valid_columns(dframe))
}

remove_and_sort_data <- function(dframe) {
  print("Ignoring data that aren't mean() or std()...")
  dframe_small <- remove_unneeded_columns(dframe)
  print("Ordering data by Subject Number and Activity Label...")
  return(dframe_small[order(dframe_small$SubjectNumber, 
                           dframe_small$ActivityLabel),])
}

# I know there are a better ways to do this but this works
# and I don't have time to change it right now.
make_tidy_data <- function(dframe) {
  subjects <- unique(dframe$SubjectNumber)
  activities <- unique(dframe$ActivityLabel)
  
  # Make copy of data using first row, attempting to preserve
  # data type
  data_copy <- dframe[1,1]
  
  print("")
  for (subject in subjects) {
    print(sprintf("    Subject '%s'", subject))
    for (activity in activities) {
      print(sprintf("        Activity '%s'", activity))
      
      # Extract the subset for this user/activity
      subset <- dframe[(dframe$SubjectNumber == subject & dframe$ActivityLabel == activity),]
      
      # "Start" a vector containing two fields that aren't numeric
      template_vec <- c(as.character(subject), 
                        as.character(activity))
      
      # Take the column mean of each numeric column, remembering
      # that R starts indices at 1
      print("        Taking column means...")
      means_vec <- colMeans(subset[,3:68])
      
      # Concatenate the two together
      single_row <- c(template_vec, as.numeric(means_vec))
      
      # Append the new row to the output structure
      data_copy = rbind(data_copy, single_row)
    }
  }
  
  # Force data copy into data frame, removing the first "row"
  # in the process
  copy_frame = suppressWarnings(data.frame(
    data_copy[2:length(data_copy[,1]),]))
  
  # Force the same column names
  colnames(copy_frame) <- colnames(dframe)
  return(copy_frame)
}

write_tidy_data <- function(df, filename) {
  if (file.exists(filename)) {
    print(sprintf("*** Warning: File '%s' is being overwritten",
                  filename))
  }
  write.table(df, filename, quote=FALSE, row.name=FALSE)
  print("----------- DONE -------------")
}

# #################################################
#
#                 MAIN
#
# #################################################

main <- function(outputfilename="tidyDataOutputSet.txt") {
  merged_data <- get_merged()
  lookup_data <- replace_w_lookup_vector(merged_data)
  lookup_w_colnames <- get_and_apply_colnames(lookup_data)
  sorted_data <- remove_and_sort_data(lookup_w_colnames)
  tidy_data <- make_tidy_data(sorted_data)
  write_tidy_data(tidy_data, outputfilename)
}