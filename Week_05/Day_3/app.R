#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(CodeClanData)
library(bslib)

#Fix names and calories variable
beer_data <- beer %>% 
  mutate(brewer = case_when(
    grepl("Yueng", brewer) ~ "D.G. Yuengling",
    grepl("Desno", brewer) ~ "Desnoes & Geddes (Jamaica)",
    TRUE                   ~ brewer)
  ) %>% 
  mutate(calories = as.numeric(calories))

brewer_selection <- beer_data %>% 
  group_by(brewer) %>% 
  summarise(count = n()) %>% 
  filter(count >= 5) %>% 
  pull(brewer)



# User Interface
ui <- fluidPage(
  
theme = bs_theme(bootswatch = 'darkly'),
  
  titlePanel(tags$h1("Compare brewers!")),
  
  
  fluidRow(
    
    column(4, offset = 2,
           
           
           selectInput(inputId = "brewer_1_input",
                       label = "Brewer 1?",
                       choices = brewer_selection
           )
    ),
    
    column( 4, 
            selectInput(inputId = "brewer_2_input",
                        label = "Brewer 2?",
                        choices = brewer_selection
            )
            
    )
  ),
  plotOutput("calorie_plot"),
  
  plotOutput("abv_plot")
)



server <- function(input, output) {
  
  output$calorie_plot <- renderPlot({
    beer_data %>% 
      filter(brewer == input$brewer_1_input |
               brewer == input$brewer_2_input) %>% 
      ggplot(aes(x = brewer,
                 y = calories)) +
      geom_boxplot() + 
      geom_jitter(colour = "grey0", size = 3) +
      coord_flip() +
      labs(x = "Brewer",
           y = "Number of calories")
    
  })
  
  output$abv_plot <- renderPlot({
    beer_data %>% 
      filter(brewer == input$brewer_1_input |
               brewer == input$brewer_2_input) %>% 
      ggplot(aes(x = brewer,
                 y = percent)) +
      geom_boxplot() + 
      geom_jitter(colour = "grey0", size = 3) +
      coord_flip() +
      labs(x = "Brewer",
           y = "Alcohol by volume (ABV)")
    
    
    
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)
