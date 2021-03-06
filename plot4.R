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

# Plot 4
png(filename = "plot4.png") # Opening the PNG file device

par(mfrow = c(2, 2)) # 2 x 2 plots
## 4.1
plot(select(power, datetime, Global_active_power),
     main = "", type = "n",
     ylab = "Global Active Power", xlab = "")
lines(select(power, datetime, Global_active_power))

## 4.2
plot(select(power, datetime, Voltage),
     main = "", type = "n")
lines(select(power, datetime, Voltage))

## 4.3
plot(select(power, datetime, Sub_metering_1),
     main = "", type = "n",
     ylab = "Energy sub metering", xlab = "")
lines(select(power, datetime, Sub_metering_1))
lines(select(power, datetime, Sub_metering_2), col = "red")
lines(select(power, datetime, Sub_metering_3), col = "blue")
legend("topright", bty = "n",
       lty = c(1,1), lwd=c(2,2), col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## 4.4
plot(select(power, datetime, Global_reactive_power),
     main = "", type = "n")
lines(select(power, datetime, Global_reactive_power))

dev.off()  # Closing the PNG file device
