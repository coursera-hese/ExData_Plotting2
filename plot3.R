#
# plot 3
#
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "NEI_data.zip")
unzip("NEI_data.zip")
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# filter for "Baltimore City" (fips == "24510")
library(dplyr)
df <- NEI  %>% filter(fips == "24510") %>% mutate(type = as.factor(type)) %>% select(fips, Emissions, year, type)
dim(df)
# contingency table (optional)
xtabs(Emissions ~ year + type, data = df)

# Plotting
library(ggplot2)
png(filename = "plot3.png")

ggplot(df, aes(year, Emissions)) +
  labs(title = "Emissions by Type and Year (Baltimore City, 1999 to 2008)",
       x = "Year", y = "PM2.5 Emissions [tons]") +
  geom_point(color = "black", size = 3, alpha = 1/2) + 
  coord_cartesian(ylim = c(0, 70)) +  # include outliers (see 'qqplot2'-PDF, "Axis Limits")
  facet_grid(. ~ type) +
  geom_smooth(method = "lm")

dev.off()

# The smooth-line of the PM2.5 emissions has decreased for all types.
