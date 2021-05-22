# set working directory

library(tidyverse)
library(visNetwork)
library(igraph)

# load network data
people <- read_csv("people.csv")
connections <- read_csv("connections.csv")

# sort people alphabetically so that the selection list is easier to follow
people <- people[order(people$id),]

# calculate degree cenrality in order to scale nodes
graph <- igraph::graph.data.frame(connections, directed = F)
degree_value <- degree(graph, mode = "in")
# scaling factor 
people$icon.size <- degree_value[match(people$id, names(degree_value))] + 25
people$icon.size <- as.integer(people$icon.size)


# add attributes
people <- people %>% mutate(shape = shape, 
                            image = paste0("/photos/", gsub(" ", "_", id), ".png"),
                            label = id)
people$title <- paste0("<p>", people$desc,"</p>")
people$font.size <- people$icon.size/2

# connections$label <- connections$type
connections$title <- paste0("<p>", connections$detail, "</p>")
connections$color.highlight <- "yellow"
connections$color.hover <- "yellow"
# make sure "value" is saved as an integer variable
connections$value <- 20


# save datasets to call in Shiny
save(people, file = "people.RData")
save(connections, file = "connections.RData")



