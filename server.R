if(!("shiny" %in% rownames(installed.packages()))) {
  install.packages("shiny")
}
if(!("caret" %in% rownames(installed.packages()))) {
  install.packages("caret")
}
if(!("tidyverse" %in% rownames(installed.packages()))) {
  install.packages("tidyverse")
}
if(!("randomForest" %in% rownames(installed.packages()))) {
  install.packages("randomForest")
}
if(!("datasets" %in% rownames(installed.packages()))) {
  install.packages("datasets")
}
if(!("e1071" %in% rownames(installed.packages()))) {
  install.packages("e1071")
}


library(shiny)
library(caret)
library(tidyverse)
library(randomForest)
library(e1071)
library(datasets)

## explore the data
data(mpg)
mydata <- mpg
mydata <- mydata %>%
  select(displ:class) %>%
  select(displ, cyl, cty, hwy, class)
mydata$class <- factor(mydata$class)

## create data partitions
seed <- set.seed(12)
set.seed(seed)
in_train <- createDataPartition(y = mydata$hwy,
                                p = 0.8,list = FALSE)
training <- mydata[in_train,]
testing <- mydata[ -in_train,]

## setup train control
control <- trainControl(method = "cv",
                        number = 5)
metric <- "Accuracy"

##  train random forest model
set.seed(seed)
fit.rf <- train(class ~.,
                 data = training,
                 method = "rf",
                 metric = metric,
                 trControl = control)

shinyServer(
  function(input, output) {

    model1pred <- reactive({
      displInput <- input$sliderDIS
      cylInput <- input$sliderCYL
      ctyInput <- input$numCTY
      hwyInput <- input$numHWY
      entry <- data.frame(displ = displInput, cyl = cylInput,
                          cty = ctyInput, hwy = hwyInput)
      predict(fit.rf, newdata = entry, type = "prob")
    })

    output$prediction <- renderTable(model1pred())

    output$plot1 <- renderPlot({

      ggplot(mydata, aes(x = displ,
                       group = class,
                       fill = as.factor(class))) +
        geom_density(position = "identity", alpha = 0.5) +
        scale_fill_discrete(name = "Class") +
        theme_bw() +
        xlab("Displacement") +
        geom_vline(xintercept = input$sliderDIS,
                   color = "orange",
                   size = 1.5) +
        scale_x_continuous(limits = c(round(min(mydata$displ) / 2, 1),
                                      round(max(mydata$displ) * 1.25, 1)))

    })

    output$plot2 <- renderPlot({

      ggplot(mydata, aes(x = cyl,
                         group = class,
                         fill = as.factor(class))) +
        geom_density(position = "identity", alpha = 0.5) +
        scale_fill_discrete(name = "Class") +
        theme_bw() +
        xlab("Cylinder") +
        geom_vline(xintercept = input$sliderCYL,
                   color = "orange",
                   size = 1.5) +
        scale_x_continuous(limits = c(round(min(mydata$cyl) / 2, 1),
                                      round(max(mydata$cyl) * 1.25, 1)))

    })

    output$plot3 <- renderPlot({

      ggplot(mydata, aes(x = cty,
                         group = class,
                         fill = as.factor(class))) +
        geom_density(position = "identity", alpha = 0.5) +
        scale_fill_discrete(name = "Class") +
        theme_bw() +
        xlab("City mileage") +
        geom_vline(xintercept = input$numCTY,
                   color = "orange",
                   size = 1.5) +
        scale_x_continuous(limits = c(round(min(mydata$cty) / 2, 1),
                                      round(max(mydata$cty) * 1.25, 1)))

    })

    output$plot4 <- renderPlot({

      ggplot(mydata, aes(x = hwy,
                         group = class,
                         fill = as.factor(class))) +
        geom_density(position = "identity", alpha = 0.5) +
        scale_fill_discrete(name = "Class") +
        theme_bw() +
        xlab("Highway mileage") +
        geom_vline(xintercept = input$numHWY,
                   color = "orange",
                   size = 1.5) +
        scale_x_continuous(limits = c(round(min(mydata$hwy) / 2, 1),
                                      round(max(mydata$hwy) * 1.25, 1)))

    })

  })
