library(tidyverse) # for data manipulation
library(visNetwork) # for network visualization
library(htmlwidgets) # to set background color and save as widget
library(metathis)

# define color palette
my_red <- "#e44c3b"
my_black <- "#262421"
my_grey <- "#776c63"
my_white <- "#fff9ef"

# load network data
people <- read_csv("people.csv")
connections <- read_csv("connections.csv")

# sort people alphabetically so that the selection list is easier to follow
people <- people[order(people$id),]

# add attributes
people <- people %>% mutate(image = paste0("https://raw.githubusercontent.com/sophieehill/untold-murder/main/photos/compressed/", gsub(" ", "_", id), ".png"),
                            label = id,
                            size = case_when(id=="Daniel Morgan" ~ 150,
                                             id=="Jonathan Rees" ~ 100,
                                             id=="Sid Fillery" ~ 100,
                                             id=="Southern Investigations" ~ 100,
                                             TRUE ~ 80),
                            shape = case_when(type!="person" ~ "image",
                                              TRUE ~ "circularImage"))
# format tooltip as paragraph
connections$title <- paste0("<p>", connections$title, "</p>")
# highlight colors
connections$color.highlight <- my_red
connections$color.hover <- my_red
# connection width
connections$width <- as.integer(10)

my_graph <- visNetwork(people, connections, width = "1000px", height = "600px", 
           background = my_black, border = my_black,
           main=list(text="THE DANIEL MORGAN MURDER CASE",
                     style='font-family:"Big Brother", sans-serif; 
                     font-size:50px;text-align:center;color:#fff9ef;'),
           submain=list(text="\nAn interactive visualization based on reporting in the podcast/book, <a href='http://www.untoldmurder.com/' style='color:#fff9ef'>Untold Murder</a>",
                        style='font-family:"SpecialElite-Regular", sans-serif;font-size:20px;text-align:center;color:#fff9ef;')) %>%
  visEdges(smooth=TRUE, width=40, shadow=TRUE, color=my_white) %>%
  visNodes(
    font = list(color=my_white, size=28, background=my_black),
    borderWidth = 2, brokenImage = "https://raw.githubusercontent.com/sophieehill/untold-murder/main/photos/compressed/broken_image.png",
    shadow=list(enabled=TRUE),
   # image = image,
    scaling = list(min=80),
    shapeProperties = list(borderRadius=3, useBorderWithImage=T),
    color=list(background=my_white, border=my_white, 
               highlight=my_red, hover=my_red)
  ) %>%
  visOptions(highlightNearest = list(enabled = F, degree = 10, 
                                     hover = F,
                                     labelOnly=FALSE),
             nodesIdSelection=FALSE) %>%
  visInteraction(hover=TRUE, zoomView = TRUE,
                 navigationButtons = FALSE,
                 tooltipStyle = 'position: fixed;visibility:hidden;padding: 5px;
                font-family: sans-serif;font-size:16px;
                font-color: #776c63; background-color: #fff9ef;
                -moz-border-radius: 3px;-webkit-border-radius: 3px;border-radius: 3px;
                 border: 0px solid #fff9ef; box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.2);
                 max-width:240px;overflow-wrap: normal;margin-left: 70px;') %>%
  visPhysics(solver = "forceAtlas2Based", 
             maxVelocity = 1000,
             minVelocity = 5,
             forceAtlas2Based = list(gravitationalConstant = -300),
             stabilization = TRUE) %>%
  addFontAwesome() %>%
  visLayout(randomSeed = 1023) 


my_graph %>%
  htmlwidgets::appendContent(htmltools::includeHTML("meta.html")) %>%
  htmlwidgets::saveWidget(file="untold-murder-viz.html", 
                          background="#262421", selfcontained=FALSE)

# exporting as a non-selfcontained file otherwise the HTML is too big
# and the Twitter social card doesn't load
# but remember you need to library of dependencies to load fonts etc.

visNetwork(people, connections, width = "1000px", height = "600px", 
                       background = my_black, border = my_black) %>%
  visEdges(smooth=TRUE, width=40, shadow=TRUE, color=my_white) %>%
  visNodes(
    font = list(color=my_white, size=28, background=my_black),
    borderWidth = 2, brokenImage = "https://raw.githubusercontent.com/sophieehill/untold-murder/main/photos/compressed/broken_image.png",
    shadow=list(enabled=TRUE),
    # image = image,
    scaling = list(min=80),
    shapeProperties = list(borderRadius=3, useBorderWithImage=T),
    color=list(background=my_white, border=my_white, 
               highlight=my_red, hover=my_red)
  ) %>%
  visOptions(highlightNearest = list(enabled = F, degree = 10, 
                                     hover = F,
                                     labelOnly=FALSE),
             nodesIdSelection=FALSE) %>%
  visInteraction(hover=TRUE, zoomView = TRUE,
                 navigationButtons = FALSE,
                 tooltipStyle = 'position: fixed;visibility:hidden;padding: 5px;
                font-family: sans-serif;font-size:16px;
                font-color: #776c63; background-color: #fff9ef;
                -moz-border-radius: 3px;-webkit-border-radius: 3px;border-radius: 3px;
                 border: 0px solid #fff9ef; box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.2);
                 max-width:240px;overflow-wrap: normal;margin-left: 70px;') %>%
  visPhysics(solver = "forceAtlas2Based", 
             maxVelocity = 1000,
             minVelocity = 5,
             forceAtlas2Based = list(gravitationalConstant = -300),
             stabilization = TRUE) %>%
  addFontAwesome() %>%
  visLayout(randomSeed = 1023, improvedLayout=FALSE) %>%
  htmlwidgets::appendContent(htmltools::includeHTML("meta.html")) %>%
  htmlwidgets::saveWidget(file="untold-murder-viz-selfcontained.html", 
                          background="#262421", selfcontained=TRUE)

