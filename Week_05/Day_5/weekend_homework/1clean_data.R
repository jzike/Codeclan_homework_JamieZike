library(tidyverse)
library(CodeClanData)
library(assertr)

# Data ----
game_sales <- game_sales %>% janitor::clean_names()

# Modify variables and add new variables needed for analysis ----


# Combine years before 2000 - there are too few games in the dataset in these years, so it makes sense to combine them

game_sales <- game_sales %>% 
  mutate(year_choices = if_else(
    year_of_release < 2000, 
    "Before 2000", 
    as.character(year_of_release))) %>% 
  mutate(year_choices = factor(year_choices, levels = c("Before 2000",
                                                        "2000",
                                                        "2001",
                                                        "2002",
                                                        "2003",
                                                        "2004",
                                                        "2005",
                                                        "2006",
                                                        "2007",
                                                        "2008",
                                                        "2009",
                                                        "2010",
                                                        "2011",
                                                        "2012",
                                                        "2013",
                                                        "2014",
                                                        "2015",
                                                        "2016"
    
  )))



#Change the user score to the same scale as critic score by multiplying by 10
game_sales <- game_sales %>% 
  mutate(user_score = user_score * 10)

#get the difference between critic score and user score
game_sales <- game_sales %>% 
  mutate(critic_user_diff = critic_score - user_score, .after = user_score) 

#create new column to pull out cases where critic and user scores are significantly different  (95% CI)
game_sales <- game_sales %>% 
  mutate(stat_diff = if_else(
    #95% of cases should be within 2 SDs of the mean if user and critic scores aren't significantly different
    abs(critic_user_diff) > (sd(game_sales$critic_user_diff) * 2),
    #assign "yes" to scores over 2 standard devs from the mean and no to those that aren't
    "Yes",
    "No"
  ))


summary(game_sales$user_score)

# Verify that user and critic scores are in the correct range ----
game_sales %>% 
verify(user_score <= 100 & user_score >=10) %>% 
verify(critic_score <= 100 & critic_score >= 10)

# Write clean data file ----
write_csv(game_sales, "data/game_sales_clean.csv")