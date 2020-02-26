library(dplyr)
library(reshape2)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file( url, destfile = "pojectdata.zip" )
dataPath <- "Dataset"
if (!file.exists(dataPath)) {
  unzip("pojectdata.zip")
}

#2. merge data set
directory <- "UCI HAR Dataset"
x_train <- read.table(paste(sep = "", directory, "/train/X_train.txt"))
y_train <- read.table(paste(sep = "", directory, "/train/y_train.txt"))
subject_train <- read.table(paste(sep = "", directory, "/train/subject_train.txt"))

x_test <- read.table(paste(sep = "", directory, "/test/X_test.txt"))
y_test <- read.table(paste(sep = "", directory, "/test/y_test.txt"))
subject_test <- read.table(paste(sep = "", directory, "/test/subject_test.txt"))

x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

#3. 
feature <- read.table(paste(sep = "", directory, "/features.txt"))

a_label <- read.table(paste(sep = "", directory, "/activity_labels.txt"))
a_label[,2] <- as.character(a_label[,2])

collums <- grep("-(mean|std).*", as.character(feature[,2]))
collumnames <- feature[collums, 2]
collumnames <- gsub("-mean", "Mean", collumnames)
collumnames <- gsub("-std", "Std", collumnames)
collumnames <- gsub("[-()]", "", collumnames)

#4.
x_data <- x_data[collums]
allData <- cbind(s_data, y_data, x_data)
colnames(allData) <- c("Subject", "Activity", collumnames)

allData$Activity <- factor(allData$Activity, levels = a_label[,1], labels = a_label[,2])
allData$Subject <- as.factor(allData$Subject)

#5. generate tidy data set
meltedD <- melt(allData, id = c("Subject", "Activity"))
tidyD <- dcast(meltedData, Subject + Activity ~ variable, mean)

write.table(tidyD, "./tidy_data.txt", row.names = FALSE, quote = FALSE)


