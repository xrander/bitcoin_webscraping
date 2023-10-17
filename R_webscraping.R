# Automated Web Scraping in R

## Load libraries
library(rvest) #for web scraping
library(tidyverse) #for data manipulation, summary, and visualization

# Load the website
cryptonews_wbpg <- read_html("https://cryptonews.net/news/bitcoin/27699710/")

# scrape the web title text
cryptonews_wbpg %>%
  html_node("title") %>%
  html_text()

# scrape the body of the website
cryptonews_wbpg %>%
  html_nodes("p") %>%
  html_text()

# Read the search result for bitcoin related news
cryptonews_wbpg_articles <- read_html("https://cryptonews.net/?q=bitcoin&rubricId=-1&location=title&type=strict")

# Get the links within the search result
cryptonews_wbpg_articles %>%
  html_nodes("div.desc.col-xs a") %>% #. represents class and a represents the hyperlink
  html_attr("href")
