if(!("shiny" %in% rownames(installed.packages()))) {
  install.packages("shiny")
}
if(!("markdown" %in% rownames(installed.packages()))) {
  install.packages("markdown")
}

library(shiny)
library(markdown)

shinyUI(
  navbarPage(
    "Car class predictor",

    tabPanel(
      "Use app",
      fluidPage(
        titlePanel("Car class prediction"),
        sidebarLayout(
          sidebarPanel(
            width = 4,
            sliderInput("sliderCYL", "How many cylinders does the car have?", 4, 8, value = 6),
            numericInput("sliderDIS", "What is the displacement of the car?", 2.5, min = 1.6, max = 7.0, step = 0.1),
            numericInput("numCTY", "What is city mileage of the car?", 13, min = 9, max = 35, step = 0.1),
            numericInput("numHWY", "What is highway mileage of the car?", 18, min = 12, max = 44, step = 0.1),
            submitButton("Submit")
          ),
          mainPanel(
            tabsetPanel(
              type = "tabs",
              tabPanel(
                "Classify your car",
                h1("Prediction"),
                h3("Show probabilities for each class"),
                p("Choose your parameters and hit 'Submit'"),
                tableOutput("prediction"),
                h1("Density plots"),
                p("Density of parameters per class"),
                fluidRow(
                  splitLayout(cellWidths = c("50%", "50%"),
                              plotOutput("plot1", height = "180px", width = "400px"),
                              plotOutput("plot2", height = "180px", width = "400px"))
                ),
                fluidRow(
                  splitLayout(cellWidths = c("50%", "50%"),
                              plotOutput("plot3", height = "180px", width = "400px"),
                              plotOutput("plot4", height = "180px", width = "400px"))
                )
              ),
              tabPanel(
                "Model description",

                h1("Model description"),
                p("Random forest model predictions trained on
                  'mpg' dataset from 'ggplot' package. More details at GitHub:"),
                a(href = "https://github.com/GeorgyMakarov/Shiny-car-predictor",
                  "https://github.com/GeorgyMakarov/Shiny-car-predictor", target = "_blank"),

                h1("Dataset"),
                p("More infromation on dataset used for training the model is here:"),
                a(href = "http://ggplot2.tidyverse.org/reference/mpg.html",
                  "http://ggplot2.tidyverse.org/reference/mpg.html", target = "_blank")

              )
            )
          )
        )
      )


    ),

    tabPanel(
      "About",
      mainPanel(includeMarkdown("about.Rmd"))

    )
  )
)
