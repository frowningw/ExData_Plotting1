f = "household_power_consumption.txt"
setwd("~/Desktop")
readfile = read.table(f, sep=";", header=TRUE, na.strings="?")
library(lubridate)
readfile$Date <- dmy(readfile$Date)
library(dplyr)
readfile <- readfile %>% filter(Date == as.Date("2007-02-01") 
                                |Date == as.Date("2007-02-02"))
readfile$Time <- readfile$Time %>% hms
#plot 1 
png("plot1.png", width = 480, height = 480)
hist(readfile$Global_active_power, col = "red", 
     main="Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.off()