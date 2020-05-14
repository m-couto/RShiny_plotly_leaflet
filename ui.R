
library(shiny)
library(shinyWidgets)   # for sliderTextInput
library(dplyr)

shinyUI(fluidPage(

    # Application title
    titlePanel("Predict plants' CO2 uptake"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            # slider for ambient CO2 concentration
            sliderInput("sliderconc",
                        "What is the ambient CO2 concentration?",
                        min = 95, max = 1000, value = 500),
            
            # slider for type of plant
            sliderTextInput("slidertype",
                        "What is the type of plant?",
                        choices=c("Quebec","Mississippi")),
            
            # slider for treatment
            sliderTextInput("slidertreat",
                            "What is the treatment?",
                            choices=c("chilled","nonchilled")),
            
            checkboxInput("Showlinreg", "Show linear regression model", value=TRUE),
            checkboxInput("Showquadreg", "Show quadratic regression model", value=TRUE),
            checkboxInput("Showpolreg", "Show polynomial regression model", value=TRUE),
            
            # the user must press before output changes
            submitButton("Submit")
        ),

        mainPanel(
            # I'll use 2 tabs:
                # tab1 for the app output: plots and predictions
                # tab2 for the app explanation
            tabsetPanel(type="tabs",
                tabPanel("Use the app", br(),
                         
                         # the plot
                         plotOutput("myplot"),
                         
                         # returning values of predictions of models
                         h4("Predicted CO2 uptake from linear regression model:"),
                         textOutput("linpred"),
                         
                         h4("Predicted CO2 uptake from quadratic regression model:"),
                         textOutput("quadpred"),
                         
                         h4("Predicted CO2 uptake from polynomial regression model:"),
                         textOutput("polpred")
                         
                         ),
                tabPanel("Documentation", br(),
                         textOutput("explained"),
                         textOutput("explained2"),
                         textOutput("explained3"),
                         textOutput("explained4"))
            )
            
        )
    )
))
