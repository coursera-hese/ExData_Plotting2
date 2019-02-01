#
# plot 1
#
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "NEI_data.zip")
unzip("NEI_data.zip")
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Plotting
png(filename = "plot1.png")

with(NEI, 
     boxplot(Emissions ~ year, col = "steelblue", ylim = c(0.001, 1.0), log = "y",
             main = "Emissions by Year", xlab = "Year", ylab = "PM2.5 Emissions [tons]")
)

dev.off()

# The median (middle line) of the PM2.5 emissions has decreased.
