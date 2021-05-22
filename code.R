# set working directory

library(tidyverse)
library(visNetwork)
library(igraph)

# load network data
people <- read_csv("people.csv")
connections <- read_csv("connections.csv")

# sort people alphabetically so that the selection list is easier to follow
people <- people[order(people$id),]

# add attributes
people <- people %>% mutate(shape = shape, 
                            image = paste0("https://raw.githubusercontent.com/sophieehill/untold-murder/main/photos/", gsub(" ", "_", id), ".png"),
                            label = id,
                            size = case_when(id=="Daniel Morgan" ~ 80,
                                             id=="Jonathan Rees" ~ 60,
                                             id=="Sid Fillery" ~ 60,
                                             TRUE ~ 40))
people$title <- paste0("<p>", people$desc,"</p>")

# connections$label <- connections$type
connections$title <- paste0("<p>", connections$detail, "</p>")
connections$color.highlight <- "yellow"
connections$color.hover <- "yellow"
# make sure "value" is saved as an integer variable
connections$value <- 10


# save datasets to call in Shiny
save(people, file = "people.RData")
save(connections, file = "connections.RData")



