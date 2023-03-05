library("tidyverse")
library("purrr")
library("readr")
library("reshape2")
# 读取 文件夹下所有 csv 文件到 tibble
files <- list.files(path = "01_abundance_table/ITS_data", pattern = "species.csv", full.names = TRUE)
species_tibble <- map_dfr(files, read_csv)

files <- list.files(path = "01_abundance_table/ITS_data", pattern = "genus.csv", full.names = TRUE)
genus_tibble <- map_dfr(files, read_csv)


# 去掉 name 列和 phenotype 列
species_tibble <- species_tibble %>% select(-name, -phenotype)
genus_tibble <- genus_tibble %>% select(-name, -phenotype)

# 写入文件
write_csv(species_tibble, "01_abundance_table/merged_ITS/species_ITS.csv")
write_csv(genus_tibble, "01_abundance_table/merged_ITS/genus_ITS.csv")
