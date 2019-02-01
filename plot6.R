#
# plot 6
#
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "NEI_data.zip")
unzip("NEI_data.zip")
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Prepare Data
#library(dplyr)


# Plotting
#library(ggplot2)
png(filename = "plot6.png")



dev.off()
