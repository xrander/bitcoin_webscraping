# Automated Web Scraping in R

## Load libraries
library(rvest) #for web scraping
library(tidyverse) #for data manipulation, summary, and visualization

# Load the website
marketwatchnews_wbpg <- read_html("https://www.marketwatch.com/story/wall-streets-biggest-bear-is-standing-by-his-call-for-stocks-to-slump-10-by-january-here-are-4-charts-that-support-his-point-f2558974?mod=home-page")

# scrape the web title text
marketwatchnews_wbpg %>%
  html_node("h1") %>%
  html_text() %>%
  str_remove_all("\n") %>%
  str_trim()

# scrape the body of the website
marketwatchnews_wbpg %>%
  html_nodes("p") %>%
  html_text()

# Read the search result for bitcoin related news
marketwatchnews_wbpg_articles <- read_html("https://www.marketwatch.com/search?q=bitcoin&ts=0&tab=All%20News")

# Get the links within the search result
url <- marketwatchnews_wbpg_articles %>%
  html_nodes("div.article__content a") %>% #. represents class and a represents the hyperlink
  html_attr("href")

# Clean the url
col_name <- "webpage"

!is.na(url)

url <- list(weblink = url) %>%
  filter(!is.na(weblink) & weblink != "#")


# Get the time of posting publication of each articles
datetime <- marketwatchnews_wbpg_articles %>%
  html_nodes("div.article__details span.article__timestamp") %>%
  html_text()

# Clean the character date time
datetime_clean <- gsub("\\.", "", datetime)
datetime_clean <- gsub("at","", datetime_clean)
datetime_clean <- gsub("ET", "",datetime_clean)

# Parse to datetime format
datetime_parsed <- parse_datetime(datetime_clean,
                format = "%b %d, %Y %I:%M %p",
               locale = locale(tz = "US/Eastern"))

# Convert datetime to Copenhagen
datetime_convert <- with_tz(datetime_parsed, tz = "Europe/Copenhagen")

# Merging data
marketwatchnews_webpasges <- tibble(webpage = url,
                                    publish_time =datetime_convert)


length(datetime_convert)
