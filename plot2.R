f = "household_power_consumption.txt"
setwd("~/Desktop")
readfile = read.table(f, sep=";", header=TRUE, na.strings="?")
library(lubridate)
library(dplyr)
readfile <- readfile %>% 
  filter(Date == "1/2/2007"|Date == "2/2/2007") %>%
  select(Date, Time, Global_active_power)
readfile <- mutate(readfile, completetime = paste(Date, Time))
readfile$completetime <- dmy_hms(readfile$completetime)

#plot 2
png("plot2.png", width = 480, height = 480)
with(readfile, plot(completetime, Global_active_power, type="l",
    ylab = "Global Active Power (kilowatts)"))
dev.off()