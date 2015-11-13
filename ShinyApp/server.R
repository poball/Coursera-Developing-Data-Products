#loading Library
library(shiny)
library(datasets)
attach(mtcars)

#loading data
mpgData <- mtcars
mpgData$am <- factor(mpgData$am, labels = c("Automatic", "Manual"))

#funtion for shiny app
shinyServer(function(input, output) {

  #title text for model
  formulaText <- reactive({
    paste("mpg ~", input$variable)
  })
  
  formulaTextPoint <- reactive({
    paste("mpg ~", "as.integer(", input$variable, ")")
  })
  
  fit <- reactive({
    lm(as.formula(formulaTextPoint()), data=mpgData)
  })
  
  output$caption <- renderText({
    formulaText()
  })
  
  #box plot
  output$mpgBoxPlot <- renderPlot({
    boxplot(as.formula(formulaText()), 
            data = mpgData,
            outline = input$outliers)
  })
  
  #scatter plot
  output$scatterplot <- renderPlot({
    pairs(mpgData,panel = panel.smooth)
  })
  
  output$fit <- renderPrint({
    summary(fit())
  })
  
  output$mpgPlot <- renderPlot({
    with(mpgData, {
      plot(as.formula(formulaTextPoint()))
      abline(fit(), col=2)
    })
  })
  
  # subset dataset
  output$dTable <- renderDataTable({
    subset(mpgData, mpg>=input$MPG[1] & mpg<=input$MPG[2])
           
  })

})
