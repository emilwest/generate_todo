library(tidyverse)
library(lubridate)

df <- tibble(datum = seq.Date(from=as.Date("2022-01-01"), to=as.Date("2023-01-01"), by="day"),
       v = isoweek(datum),
       d = wday(datum, label = T, abbr = F),
       m = month(datum, label = T, abbr = F))

df2 <- df %>%
  filter(!d %in% c("lördag", "söndag"))

# w <- 1
outstring <- str_glue("Automatically generated template by Emil Westin on {now()}.
                      Source code: https://github.com/emilwest/generate_todo\n\n
                      ")
for (w in 1:52) {
  d_tmp <- df2 %>% filter(v == w)

  weekly_summary <- d_tmp %>%
    slice(1,5) %>%
    str_glue_data("{month(datum, label=T)} {day(datum)}") %>%
    str_c(collapse = " - ")


  title_string <- str_glue("\n
           // ----------------------------
           // Vecka {unique(d_tmp$v)} ({weekly_summary})\n\n
           ")

  day_string <- str_glue("
           # {d_tmp$d} {day(d_tmp$datum)}/{month(d_tmp$datum)}
           \t.
           \t.
           \t. \n
           ")

  outstring <- c(outstring, title_string, day_string)

}

output_path <- str_glue("todo_{year(now())}.txt")
fileConn <- file(output_path)
writeLines(outstring, fileConn)
close(fileConn)
