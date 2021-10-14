#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
new_var <- "New variable value"
shinyServer(function(input, output,session) {
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- zest_data[[input$column]]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # draw the histogram with the specified number of bins
    hist(x, main=paste("Histogram of ",input$column), breaks = bins, col = 'darkgray', border = 'white',freq = !as.logical(input$density))
  })
  output$twoDHist <- renderPlot({
    req(input$columns)
    y =  input$columns[1]
    x =  input$columns[2]
    if (!is.null(x) && !is.null(y)){
      df <- data.frame(zest_data[[x]],zest_data[[y]])
      colnames(df) <- c(x, y)
      h <- hexbin(df)
      plot(h, colramp=rf)
    }
  })
  
  output$scatterplot <- renderPlot({
    req(input$columns)
    y =  input$columns[1]
    x =  input$columns[2]
    if (!is.null(x) && !is.null(y)){
      ggplot(data = zest_data, aes_string(x = x, y = y)) +
        geom_point()
    }
  })
  
  output$pcaplot <- renderPlot({
    req(input$pcacolumns)
    if (!is.null(input$pcacolumns)){
      zest_data.pca <- prcomp(zest_data[input$pcacolumns], center = TRUE,scale. = TRUE)
      fviz_eig(zest_data.pca)
    }
  })
  
  ##### add galaxy output code here
  
})
