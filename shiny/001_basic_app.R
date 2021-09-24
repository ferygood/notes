library(shiny)
library(shinythemes)

# Define UI
ui <- fluidPage(theme = shinytheme("spacelab"),
                navbarPage(
                    "My first app",
                    tabPanel(
                        "Navbar 1",
                        sidebarPanel(
                            tags$h3("Input:"),
                            textInput("txt1", "Given Name:", "John"),
                            textInput("txt2", "Surname:", "Doe")
                        ),
                        mainPanel(h1("Your name is here:"),
                                  verbatimTextOutput("txtout"))
                    ),
                    tabPanel(
                        "Navbar 2",
                        sidebarPanel(
                            tags$h3("Input:"),
                            numericInput("num1", "First number:", 3),
                            numericInput("num2", "Second number:", 6)
                        ),
                        mainPanel(h2("Multiplication result:"),
                                  verbatimTextOutput("numout"))
                    )
                ))


# Define server function
server <- function(input, output) {
    output$txtout <- renderText(paste(input$txt1, input$txt2))

    output$numout <- renderText(as.character(input$num1 * input$num2))
}


# create shiny object
shinyApp(ui = ui, server = server)
