#Define the url first
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Define destination
destination <- "/Users/ihsanselcukyurttas/Documents/TestingGIT/getcleandata/data.zip"

#download file
download.file(url, destfile = destination, method = "curl")

#Unzip file

unzip(destination)

# Defining directories to variables

#Defining general directories
directory0 <- "/Users/ihsanselcukyurttas/Documents/TestingGIT/getcleandata/UCI HAR Dataset"
training <- file.path(directory0, "train")
test <- file.path(directory0, "test")

# Creating training variables

trainSubjects <- read.table(file=file.path(training,"subject_train.txt"))
trainValues <- read.table(file=file.path(training, "X_train.txt"))
trainActivity <- read.table(file= file.path(training, "y_train.txt"))

#Creating testing variables
testSubjects <- read.table(file=file.path(test, "subject_test.txt"))
testValues <- read.table(file=file.path(test, "X_test.txt"))
testActivity <- read.table(file.path(test, "y_test.txt"))

#Creating features variable
features <- read.table(file = file.path(directory0, "features.txt"))

#Creating activity label variable
activity <- read.table(file= file.path(directory0, "activity_labels.txt"))

#Load data.table package
library(data.table)

#Combine all

humanActivity <- rbind(
     cbind(trainSubjects, trainActivity, trainValues),
     cbind(testSubjects,testActivity, testValues)
)

#Rename column names
colnames(humanActivity) <- c("Subject", "Activity", features[,2])

#Create a logical vector to assess which columns will be selected
colExtract <- grepl(("Subject|Activity|mean|std"), colnames(humanActivity))

#Apply the logical vector to combined values dataset to extract the
#expected columns

humanActivity <- humanActivity[,colExtract]

#Activity Factors
humanActivity$Activity <- factor(humanActivity$Activity, 
                                 levels = activity[, 1], labels = activity[, 2])

#Take colnames of humanActivity
names <- colnames(humanActivity)

#Remove the special characters
names <- gsub("[\\(\\)-]", "", names)

#Rename all

names <- gsub("^f", "frequencyDomain", names)
names <- gsub("^t","timeDomain", names)
names <- gsub("Acc","Accelerometer", names)
names <- gsub("Gyro", "Gyroscope", names)
names <- gsub("Freq", "Frequency", names)
names <- gsub("mean", "Mean", names)
names <- gsub("std", "SD", names)

#Use new names list for humanActivity column names
colnames(humanActivity) <- names

#Create Tidy dataset
tidy_dataset <- humanActivity %>% 
     group_by(Subject, Activity) %>%
     summarize_all(funs(mean))

#Export Tidy Dataset

write.table(tidy_dataset, 
            file = "/Users/ihsanselcukyurttas/Documents/TestingGIT/getcleandata",
            row.names = FALSE)


