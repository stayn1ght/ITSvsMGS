# ITS数据 boxplot
library("tidyverse")
library("ggplot2")
library("reshape2")

species_tibble_origin <- read_csv("01_abundance_table/merged_ITS/species_ITS.csv") %>%
    melt(id.vars = "index") %>%
    tibble()

# >>> 处理数据，清除 NA 值 >>>
species_tb0 <- species_tibble_origin %>%
    filter(value > 0) %>%
    # 处理物种名字
    filter(grepl("^.*s__", variable)) %>%
    mutate(variable = gsub("^.*s__", "", variable)) %>%
    mutate(variable = gsub("_", " ", variable))
# <<< 处理数据，清除 NA 值 <<<

# >>> 计算相对丰度 >>>
species_tb1 <- species_tb0 %>%
    dcast(index ~ variable, value.var = "value",
        fun.aggregate = mean, fill = 0) %>%
    tibble()
species_tb2 <- species_tb1 %>%
    column_to_rownames("index")
species_tb3 <- species_tb2/rowSums(species_tb2)
# <<< 计算相对丰度 <<<
# >>> 不计算相对丰度，改为抽平处理 >>>
# library("vegan")
# species_tb1 <- species_tb0 %>%
#     dcast(index ~ variable, value.var = "value",
#         fun.aggregate = mean, fill = 0) %>%
#     tibble()
# # rarefaction
# species_tb2 <- species_tb1 %>%
#     # 每一列都改为int
#     mutate_at(vars(-index), as.integer) %>%
#     column_to_rownames("index")

# species_tb3 <- species_tb2 %>%
#     rarefy_even_depth(1000)
# <<< 失败的处理，少于1000的样本没法处理 <<<

# >>> 产生作图数据 >>>
species_tibble <- species_tb3 %>%
    mutate(index = rownames(.)) %>%
    melt(id.vars = "index") %>%
    tibble() %>%
    filter(value > 0)
# <<< 产生作图数据 <<<
# >>> 根据相对丰度的中位数排序, 去掉仅在一个样本中出现的菌 >>>
sorted_table <- species_tibble %>%
    # 计算每个物种的丰度的中位数
    group_by(variable) %>%
    summarise(median = median(value), n = n()) %>%
    # 丰度从大到小排序
    arrange(desc(median)) %>%
    # 去掉仅仅在一个样本index中出现的variable
    filter(n > 1) %>%
    ungroup()
# <<< 根据相对丰度的中位数排序 <<<
# >>> 作图 >>>
ITS_plot_tb <- species_tibble %>%
    mutate(variable = factor(variable, levels = sorted_table$variable))
ggplot(ITS_plot_tb, aes(x = variable, y = value)) +
    geom_boxplot(color = "black", fill = "#b0cede") +
    ggtitle("ITS fungi relative abundance") +
    scale_x_discrete(limits = levels(ITS_plot_tb$variable)[1:20]) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 10),
        plot.margin = unit(c(0.5, 0.5, 0.5, 0.8), "in")) +
    labs(x = "Species", y = "RA")
ggsave("03_plot/ITS_boxplot.png", width = 10, height = 8)
# <<< 作图 <<<

# MGS 数据 boxplot
# species_MGS_ori <- read_tsv("01_abundance_table/MGS/species_norm.tsv", skip = 1) %>%
#     rename(index = "#OTU ID") %>%
#     # 第一列作为行名
#     column_to_rownames("index") %>%
#     t() %>%
#     data.frame() %>%
#     mutate(index = rownames(.)) %>%
#     melt(id.vars = "index") %>%
#     tibble()

# MGS 数据 boxplot
species_MGS_ori <- read_tsv("01_abundance_table/MGS/merged_species.tsv") %>%
    rename(index = taxon) %>%
    column_to_rownames("index") %>%
    t() %>%
    data.frame() %>%
    mutate(index = rownames(.)) %>%
    melt(id.vars = "index") %>%
    tibble()
# >>> 处理数据，清除 NA 值 >>>
MGS_species_tb0 <- species_MGS_ori %>%
    filter(value > 0) %>%
    # 处理物种名字
    mutate(variable = gsub("_", " ", variable))
# <<< 处理数据，清除 NA 值 <<<
# >>> 计算相对丰度 >>>
MGS_species_tb1 <- MGS_species_tb0 %>%
    dcast(index ~ variable, value.var = "value",
        fun.aggregate = mean, fill = 0) %>%
    tibble()
MGS_species_tb2 <- MGS_species_tb1 %>%
    column_to_rownames("index")
MGS_species_tb3 <- MGS_species_tb2/rowSums(MGS_species_tb2)
# <<< 计算相对丰度 <<<


# >>> 产生作图数据 >>>
MGS_species_tibble <- MGS_species_tb3 %>%
    mutate(index = rownames(.)) %>%
    melt(id.vars = "index") %>%
    tibble() %>%
    filter(value > 0)
# <<< 产生作图数据 <<<

# >>> 根据相对丰度的中位数排序, 去掉仅在一个样本中出现的菌 >>>
MGS_sorted_table <- MGS_species_tibble %>%
    # 计算每个物种的丰度的中位数
    group_by(variable) %>%
    summarise(median = median(value), n = n()) %>%
    # 丰度从大到小排序
    arrange(desc(median)) %>%
    # 去掉仅仅在一个样本index中出现的variable
    filter(n > 1) %>%
    ungroup()
# <<< 根据相对丰度的中位数排序 <<<
# >>> 作图 >>>
library(MASS)
MGS_plot_tb <- MGS_species_tibble %>%
    mutate(variable = factor(variable, levels = MGS_sorted_table$variable))
ggplot(MGS_plot_tb, aes(x = variable, y = log(value))) +
    geom_boxplot(color = "black", fill = "#b0cede") +
    ggtitle("MGS fungi relative abundance (log scaled)") +
    scale_x_discrete(limits = levels(MGS_plot_tb$variable)[1:20]) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1, size = 8),
        plot.margin = unit(c(0.5, 0.5, 0.5, 0.8), "in")) +
    labs(x = "Species", y = "log(RA)")
ggsave("03_plot/MGS_boxplot.png", width = 10, height = 8)
# <<< 作图 <<<
