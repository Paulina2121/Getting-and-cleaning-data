
#getwd() #to check working directry
filename <- "./Dataset.zip" #zippedfile name

## check whether file exists and download the file:
if (!file.exists(filename)){
     fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
     download.file(fileURL, filename, method="curl")
}

# Unzip folder
if (!file.exists("UCI HAR Dataset")) { 
     unzip(filename) 
}

## POINT 1:

# read necessary data: activity labels and features
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features[,2] <- as.character(features[,2])


# Load the datasets: train and test
train <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainlabel <- read.table("./UCI HAR Dataset/train/Y_train.txt")
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubject, trainlabel, train)

test <- read.table("./UCI HAR Dataset/test/X_test.txt")
testlabels <- read.table("./UCI HAR Dataset/test/Y_test.txt")
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubject, testlabels, test)


#Merge the training and the test sets to create one data set

joinedset <- rbind(train, test) #one data set
dim(joinedset) # check the dimension
joinedlabel <- rbind(trainlabel, testlabels)
dim(joinedlabel) 
joinSubject <- rbind(trainSubject, testSubject)
dim(joinSubject) 


# POINT 2: Extract only the measurements on the mean & standard deviation
# for each measurement

featuresmean_sd <- grep(".*mean.*|.*std.*", features[,2])
joinedset <- joinedset[, featuresmean_sd]
names(joinedset) <- gsub('-mean', 'Mean', features[featuresmean_sd, 2]) #remove '-mean'
names(joinedset) <- gsub('-std', 'Std', names(joinedset)) #remove '-sd'
names(joinedset) <- gsub("\\(\\)", "", names(joinedset)) #remove ()


#POINT 3: Use descriptive activity names to name the activities in data set

activityLabels[, 2] <- tolower(gsub("_", "", activityLabels[, 2]))
substr(activityLabels[2, 2], 8, 8) <- toupper(substr(activityLabels[2, 2], 8, 8))
substr(activityLabels[3, 2], 8, 8) <- toupper(substr(activityLabels[3, 2], 8, 8))
activity <- activityLabels[joinedlabel[, 1], 2]
joinedlabel[, 1] <- activity
names(joinedlabel) <- "activity"

# POINT 4: Label the data set with descriptive activity names
 
names(joinSubject) <- "subject"
cleanedData <- cbind(joinSubject, joinedlabel, joinedset)
dim(cleanedData) # check if dimensions are correct
write.table(cleanedData, "newdata.txt") # write out the 1st dataset







