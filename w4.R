NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#1
png("plot1.png", width = 480, height = 480)
plot(c(1999,2002,2005,2008),log10(tapply(NEI$Emissions, NEI$year, sum)), xlab="year",ylab="Emissions in Log10", main = " Total emissions from PM2.5 in the US")
dev.off()

#2
library(dplyr)
NEI_Balt<- NEI %>% filter(fips == "24510")
png("plot2.png", width = 480, height = 480)
plot(c(1999,2002,2005,2008),log10(tapply(NEI_Balt$Emissions, NEI_Balt$year, sum)), xlab = "year", ylab = "Emissions in Log10", main = "total emissions from PM2.5 in the Baltimore City")
dev.off()

#3
NEI_Balt$typeyear <- with(NEI_Balt, paste(type, year, sep=""))
tapply(NEI_Balt$Emissions, NEI_Balt$typeyear, sum)
NEIB_s <- NEI_Balt %>% select(Emissions, type, year)
NEIB_s$typeyear <- with(NEIB_s, paste(type, year, sep=""))
dat <- with(NEIB_s, tapply(Emissions, typeyear, sum))
df <- as.data.frame(dat)
df <- mutate(df, ty =rownames(df))
library(tidyr)
df <- separate(df,ty,into=c("type","year"),sep=-4)
df1 <- spread(df, type, dat)
library(ggplot2)
png("plot3.png", width = 480, height = 480)
g <- ggplot(df, aes(year, dat, col = type))
g + geom_point()+labs(x = "year", y = "Emissions", title = "Emissions in Baltimore City by TYPE")
dev.off()

#4
SCC_UScomb <- SCC %>% filter(SCC.Level.One == "External Combustion Boilers" |
                               SCC.Level.One == "Internal Combustion Boilers") %>%
              select(SCC, Data.Category, SCC.Level.One)
USdat <- merge(NEI, SCC_UScomb, by = "SCC")
png("plot4.png", width = 480, height = 480)
plot(c(1999,2002,2005,2008),log10(tapply(USdat$Emissions, USdat$year, sum)), xlab="year",ylab="Emissions in Log10", main = " Total comb emissions from PM2.5 in the US")
dev.off()

#5
SCC_Veh <- SCC %>% filter(SCC.Level.Three == "Motorcycles (MC)") %>%
  select(SCC,Data.Category, SCC.Level.Three)
Baldat<- merge(NEI_Balt, SCC_Veh, by = "SCC")
png("plot5.png", width = 480, height = 480)
plot(c(1999,2002,2005,2008),
     log10(tapply(Baldat$Emissions, Baldat$year, sum)),
     xlab="year",ylab="Emissions in Log10",
     main = " Total comb emissions from PM2.5 in Baltimore City")
dev.off()

#6
NEI_la<- NEI %>% filter(fips == "06037")
ladat <- merge(NEI_la,SCC_Veh, by = "SCC")
LA <- as.data.frame(tapply(ladat$Emissions, ladat$year, sum))
Balt <- as.data.frame(tapply(Baldat$Emissions, Baldat$year, sum))
lanbalt <- cbind(LA, Balt)
lanbalt <- mutate(lanbalt, rownames(lanbalt)) 
colnames(lanbalt) <- c("la", "balt", "year")
lanbalt <- gather(lanbalt, city, emissions, -year)
png("plot6.png", width = 480, height = 480)
g <- ggplot(lanbalt ,aes( year, log10(emissions), col = city))
g + geom_point() + labs(title = "Balt v. LA: mobile emissions")
dev.off()
