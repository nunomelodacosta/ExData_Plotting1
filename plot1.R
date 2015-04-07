library(dplyr)
library(tidyr)
library(lubridate)

file <- "household_power_consumption.txt"

# Reading table
## Before readin the full dataset, Checking variables classes 
## and interpreting "?" as NA
## Keeping date and time as character class with as.is = TRUE
df <- read.table(file, header = TRUE, sep = ";", nrows = 5, as.is = TRUE)
classes <- sapply(df, class)

## reading the full table, since no memeory constraints exist
## Assigning the right classes to df when reading with colClasses
df <- read.table(file, header = TRUE, sep = ";",
                 colClasses = classes, na.strings = "?")


# Cleaning and tyding data
## Converting data to tbl class
## Creating a new variable POSIXct class, by parsing date and time with 
## dmy_hms function from lubridate
## Filtering observations from 2007-02-01 and 2007-02-02 
## Arranging/sorting power by the new variable datetime
power <- tbl_df(df)
power <- power %>%
        mutate(datetime = dmy_hms(paste(Date, Time))) %>% 
        filter(datetime >= "2007-02-01", datetime < "2007-02-03") %>%
        arrange(datetime)

# Checking clean and tidy dataset
power

# Plot 1
png(filename = "plot1.png") ## Opening the PNG file device

par(mfrow = c(1, 1)) # 1 x 1 plots

with(power, hist(Global_active_power, col = "red",
                 main = "Global Active Power",
                 xlab = "Global Active Power (kilowatts)"))

dev.off()  # Closing the PNG file device