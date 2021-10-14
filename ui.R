#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


# For information on Layout
# https://shiny.rstudio.com/articles/layout-guide.html


# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("united"),
    # Application title
    titlePanel(app_title),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(),
        
        # Show a plot of the generated distribution
        mainPanel(
            tags$br(),
            tags$p(
                "The data and work are based off of the work done",
                tags$a(" here", href = "https://iopscience.iop.org/article/10.1086/516582/pdf"), "."
            ),
        )
    )
))
