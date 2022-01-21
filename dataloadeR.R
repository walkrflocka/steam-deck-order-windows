# Dependencies
library(dplyr)
library(readr)
library(lubridate)
library(stringr)

# Read in file
redditResponses <- read_csv(
  file = 'data/deck responses 2022-01-20.csv',
  col_names = c('answerTime',
                'location',
                'capacity',
                'estimate',
                'orderTime',
                'linuxExperience',
                'windowsBoot'),
  skip = 1
  
)

# Cleaning
redditResponses <- redditResponses %>% 
  mutate(
    orderTime = as.numeric(orderTime)
  ) %>% 
  filter(str_length(orderTime) == 10) %>% 
  mutate(
    across(answerTime,
           ~ dmy_hms(.)),
    across(orderTime,
           ~ as.POSIXct(., origin = lubridate::origin)),
    linuxExperience = factor(linuxExperience,
                             levels = c("I have no Linux experience",
                                        "I have seen it before.",
                                        "I tried it once or twice before.",
                                        "I used Linux frequently in the past.",
                                        "I am still using Linux frequently.",
                                        "I run Linux on Servers, but not on my PC.")
                             ),
    estimate = factor(estimate,
                      levels = c("Q1 (Used to be December)",
                                 "Q1 (Still Q1)",
                                 "Q2 (Used to be Q1)",
                                 "Q2 (Still Q2)",
                                 "After Q2 (Used to be Q2)",
                                 "After Q2 (No change)")),
    capacity = factor(capacity,
                      levels = c('64 GB',
                                 '256 GB',
                                 '512 GB'))
  ) %>% 
  filter(orderTime >= ymd_hms('2021-07-16 13:00:00'))

save(redditResponses, file = 'data.R')
# SQUID GAMES !!