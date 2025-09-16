library(shiny)
library(bslib)
library(shinyvalidate)

generate_story <- function(noun, verb, adjective, adverb) {
  glue::glue(
    "
    Once upon a time, there was a {adjective} {noun} who loved to
    {verb} {adverb}. It was the funniest thing ever!
  "
  )
}

ui <- fluidPage(
  theme = bs_theme(bootswatch = "zephyr"),
  titlePanel("Mad Libs Game"),
  p(
    "Fill in the boxes below, and this app will create a fun statement for you! Watch your statement update in real time as you type in the boxes."
  ),
  sidebarLayout(
    sidebarPanel(
      textInput("noun1", "Enter a noun:", ""),
      textInput("verb", "Enter a verb:", ""),
      textInput("adjective", "Enter an adjective:", ""),
      textInput("adverb", "Enter an adverb:", "")
    ),
    mainPanel(
      p(""),
      h3("Your Mad Libs Story:"),
      textOutput("story")
    )
  )
)

server <- function(input, output) {
  iv <- InputValidator$new()
  iv$add_rule("noun1", sv_required())
  iv$add_rule("verb", sv_required())
  iv$add_rule("adjective", sv_required())
  iv$add_rule("adverb", sv_required())
  story <- reactive({
    generate_story(input$noun1, input$verb, input$adjective, input$adverb)
  })
  output$story <- renderText({
    story()
  })
  iv$enable()
}

shinyApp(ui = ui, server = server)
