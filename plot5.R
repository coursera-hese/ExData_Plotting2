#
# plot 5
#
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "NEI_data.zip")
unzip("NEI_data.zip")
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

##
## Prepare Data
##
library(dplyr)
# convert `SCC`column to character for joining the tables
NEI <- transform(NEI, SCC = as.character(SCC))
SCC <- transform(SCC, SCC = as.character(SCC))
# join tables and filter
df <- left_join(NEI, SCC) %>% 
  filter(grepl("Vehicle", EI.Sector, fixed = TRUE)) %>%
  filter(fips=="24510") %>%
  filter(year == 1999 | year == 2008) %>%
  arrange(year, EI.Sector) %>%
  select(fips, Emissions, year, type, SCC, EI.Sector)

# split dataset for 1999 and 2008
pm0 <- df %>% filter(year == 1999)
pm1 <- df %>% filter(year == 2008)

##
## Plotting
##
png(filename = "plot5.png")

# plotting-canvas: 1 row and 1 column
par(mfrow = c(1, 1))
## init plot (base-plotting system)
plot(pm0$Emissions, log = "y", col = "steelblue", pch = 19,
#plot(pm0$Emissions, data = pm0, log = "y", col = "steelblue", pch = 19,
     main = "Motor Vehicles Emissions in Baltimore City (1999 and 2008)",
     xlab = "", ylab = "PM2.5 Emissions [tons]",
     axes = FALSE, frame.plot = TRUE)
## Axis only on y-axis
#Axis(side = 1, labels = FALSE)
Axis(side = 2, labels = TRUE)
## plot second dataset
points(pm1$Emissions, data = pm1, log = "y", col = "violet", pch = 19)
## average for datasets
abline(h = mean(pm0$Emissions), col = "steelblue", lwd = 3, lty = 2)
abline(h = mean(pm1$Emissions), col = "violet", lwd = 3, lty = 2)
## median for datasets
#abline(h = median(pm0$Emissions), col = "steelblue", lwd = 3, lty = 3)
#abline(h = median(pm1$Emissions), col = "violet", lwd = 3, lty = 3)
## add a legend
legend(120, 50, legend = c("1999 PM2.5 Average", "2008 PM2.5 Average"), col = c("steelblue", "violet"), lwd = 1, lty = 2, cex = 0.8)


## ALTERNATIVE: boxplot
#par(mfrow = c(1, 2))
## left plot
#boxplot(pm0$Emissions, data = pm0, log = "y", ylim = c(0.0001, 50), col = "grey")
#abline(h = median(pm1$Emissions), col = "red", lwd = 3, lty = 2)
## right plot
#boxplot(pm1$Emissions, data = pm1, log = "y", ylim = c(0.0001, 50), col = "grey")
#abline(h = median(pm0$Emissions), col = "blue", lwd = 3, lty = 2)

dev.off()
