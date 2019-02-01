#
# plot 4
#
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "NEI_data.zip")
unzip("NEI_data.zip")
## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# filter for "Coal-Combustion Emissions"
library(dplyr)

# convert `SCC`column to character for joining the tables
#SCC <- SCC %>% mutate(SCC = as.character(SCC))
NEI <- transform(NEI, SCC = as.character(SCC))
SCC <- transform(SCC, SCC = as.character(SCC))

# join tables and filter "Coal-Combustion"
df <- left_join(NEI, SCC) %>% 
  filter(grepl("Coal", EI.Sector, fixed = TRUE)) %>%
  arrange(year, type, EI.Sector) %>%
  select(Emissions, year, type, SCC, EI.Sector)
#coal <- grepl("Coal", SCC$EI.Sector, fixed = TRUE)

pm0 <- df %>% filter(year == 1999)
pm1 <- df %>% filter(year == 2008)
sum0 <- with(pm0, tapply(Emissions, SCC, sum, na.rm = TRUE))
sum1 <- with(pm1, tapply(Emissions, SCC, sum, na.rm = TRUE))

summary(sum0)
summary(sum1)

d0 <- data.frame(scc = names(sum0), sum = sum0)
d1 <- data.frame(scc = names(sum1), sum = sum1)

head(d0)
head(d1)

mrg <- merge(d0, d1, by = "scc")
# 56  3
dim(mrg)

head(mrg)

# Plotting
png(filename = "plot4.png")

par(mfrow = c(1, 1))
#with(mrg, plot(rep(1999, 56),  mrg[, 2], xlim = c(1999, 2008), log = "y"))
with(mrg, 
     plot(rep(1999, 56),  mrg[, 2], xlim = c(1999, 2008), log = "y", 
     main = "Coal-Combustion Emissions (USA, 1999 vs. 2008)",
     xlab = "Year", ylab = "Emissions [tons]"))
with(mrg, points(rep(2008, 56),  mrg[, 3]))
segments(rep(1999, 56), mrg[,2], rep(2008, 56), mrg[,3])

dev.off()


# ALTERNATIVE: Plotting
library(ggplot2)
png(filename = "plot4.png")

ggplot(df, aes(year, Emissions)) +
  labs(title = "Coal-Combustion Emissions by Year (USA, 1999 to 2008)",
       x = "Year", y = "PM2.5 Emissions [tons]") +
  geom_point(color = "black", size = 5, alpha = 0.6) +
  #geom_point(aes(color = Emissions), size = 15, alpha = 1/2) + 
  #scale_y_log10() +
  coord_cartesian(ylim = c(0, 200)) +  # include outliers (see 'qqplot2'-PDF, "Axis Limits")
  #geom_line(y = 0.0, color = "red") +
  geom_smooth(method = "lm", size = 2) + 
  theme_bw()

dev.off()

# The smooth-line of the PM2.5 emissions has decreased for all types.
