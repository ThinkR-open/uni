library(tidyverse)
files <- list.files( "data-raw/unicode-table-data/loc/en/symbols/", pattern = "[.]txt$", recursive = TRUE, full.names = TRUE )

read_unicode_table <- function(file){
  tibble(
      line  = read_lines(file)
    ) %>%
    filter( line != "") %>%
    separate(line, c("rune", "description"), sep = ":" , extra = "merge") %>%
    filter( description != "" ) %>%
    mutate(
      id = strtoi(rune, base = 16L ),
      rune = paste0( "U+", rune)
    ) %>%
    select( id, rune, description )
}

code <- map_df( files, read_unicode_table )

read_blocks.txt <- function(){
  tibble(
      line = str_trim( read_lines("data-raw/unicode-table-data/data/blocks.txt") )
    ) %>%
    mutate( step = cumsum(line=="") ) %>%
    filter( line != "") %>%
    group_by( step ) %>%
    summarise(
      block = line[1]  %>%
        str_replace( "^.(.*).$", "\\1" ),
      data  = tibble( line = str_subset( line[-1], ":" ) ) %>%
        separate( line, into = c("variable", "content"), extra = "merge", sep = ":") %>%
        mutate( variable = str_trim(variable) ) %>%
        filter( content != "" ) %>%
        spread(variable, content) %>%
        list()
    ) %>%
    unnest() %>%
    select(-step) %>%
    mutate_at( vars(countries, languages, type), str_trim )
}
blocks <- read_blocks.txt()

x <- blocks %>%
  separate( diap, into = c("start", "end"), sep = ":" ) %>%
  mutate( id = map2(start, end, ~ seq( strtoi(.x, base = 16), strtoi(.y, base = 16) ) ) ) %>%
  unnest() %>%
  select(-start,-end)

code <- left_join( code, x, by = "id")

use_data(code, overwrite = TRUE)
