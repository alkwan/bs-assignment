# Data Perspectives Graphs
library(plotly)
library(openxlsx)
library(dplyr)
library(tidyr)

# Read in data sets
child.mortality <- read.xlsx('./data/child_mortality.xlsx')
life.expectancy <- read.xlsx('./data/life_expectancy.xlsx')

# Rename the columns to organize the data better
col.names <- colnames(life.expectancy)
col.names <- c('country', col.names[2:17])
colnames(life.expectancy) <- col.names
colnames(child.mortality) <- col.names

united.states.life <- life.expectancy %>%
  filter(country == "United States") %>%
  gather("year", "life.expectancy", 4:17) %>%
  select(year, life.expectancy)

united.states.child.mortality <- child.mortality %>%
  filter(country == "United States") %>%
  gather("year", "child.mortality", 2:17) %>%
  select(year, child.mortality)

# write.csv(united.states.life, file = './data/united_states_life_expectancy.csv', row.names = FALSE)
# write.csv(united.states.child.mortality, file = './data/us_child_mortality.csv', row.names = FALSE)

names <- c('Kuwait', 'Seychelles', 'Guyana')

smaller.life.expectancy <- life.expectancy %>%
  filter(country %in% names) %>%
  gather("year", "life.expectancy", 2:17) %>%
  spread(key = country, value = life.expectancy)

smaller.life.expectancy <- smaller.life.expectancy[3:16,]

yr <- list(title = "Years", showticklabels = TRUE, showgrid = FALSE)
life <- list(title = "Life Expectancy in Years", showticklabels = TRUE, showgrid = FALSE)

plot_ly(x = smaller.life.expectancy$year, y = smaller.life.expectancy$Guyana,
  name = 'Guyana', type = "scatter", mode = "lines") %>%
  add_trace(y = smaller.life.expectancy$Kuwait, name = 'Kuwait', mode = "lines") %>%
  add_trace(y = smaller.life.expectancy$Seychelles, name = 'Seychelles', mode = "lines") %>%
  add_trace(y = united.states.life$life.expectancy, name = 'United States', mode = "lines") %>%
  layout(title = "Life Expectancy", xaxis = yr, yaxis = life)
  
