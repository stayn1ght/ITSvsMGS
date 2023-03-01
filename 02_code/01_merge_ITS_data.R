library("tidyverse")
library("purrr")
library("readr")
library("reshape2")
# 读取 文件夹下所有 csv 文件到 tibble
files <- list.files(path = "01_abundance_table/ITS_data", pattern = "species.csv", full.names = TRUE)
species_tibble <- map_dfr(files, read_csv)

files <- list.files(path = "01_abundance_table/ITS_data", pattern = "genus.csv", full.names = TRUE)
genus_tibble <- map_dfr(files, read_csv)

colnames(species_tibble)
