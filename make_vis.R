library(tidyverse) # for data manipulation
library(visNetwork) # for network visualization

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
connections$value <- 10

visNetwork(people, connections, width = "100%", height = "500px", 
           background = "black", border = "white",
           main=list(text="\n \n \n THE DANIEL MORGAN MURDER CASE",
                     style='font-family:"Big Brother", sans-serif; 
                     font-size:50px;text-align:center;color:#fff9ef;'),
           submain=list(text="\nAn interactive visualization based on reporting in the podcast/book, <a href='http://www.untoldmurder.com/' style='color:#fff9ef'>Untold Murder</a>",
                        style='font-family:"SpecialElite-Regular", sans-serif;font-size:20px;text-align:center;color:#fff9ef;')) %>%
  visEdges(smooth=TRUE) %>%
  visNodes(
    font = list(color=my_white, size=28),
    borderWidth = 3, brokenImage = "https://raw.githubusercontent.com/sophieehill/untold-murder/main/photos/compressed/broken_image.png",
    shadow=list(enabled=TRUE, color="#776c63"),
    image = image,
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
             forceAtlas2Based = list(gravitationalConstant = -500),
             stabilization = TRUE) %>%
  addFontAwesome() %>%
  visLayout(randomSeed = 4444) %>%
  visSave(file = "untold-murder.html", selfcontained = TRUE)


