library(ggVennDiagram)
# update: 引入了 ncbi taxon id 用于校准两个数据集的共有物种

# >>> 原始数据 >>>
source("02_code/03_abundance_boxplot.R")

ITS_plot_tb %>%
  filter(value > 0.01) %>%
  dcast(index ~ variable, value.var = "value", fun.aggregate = mean, fill = 0)

MGS_tb <- MGS_plot_tb %>%
  mutate(index = gsub("^m", "", index))
# <<< 原始数据 <<<

# >>> 判断数据集中鉴定到的菌
df1 <- ITS_plot_tb %>%
  left_join(ITS_taxon, by = c("variable" = "name")) %>%
  filter(value > 0.01 & !is.na(taxid) & code != 3) %>%
  group_by(taxid) %>%
  summarise(rel_abundance = sum(value)) %>%
  ungroup() %>%
  mutate(rel_abundance = rel_abundance/length(unique(ITS_plot_tb$index))) %>%
  rename(bacteria = taxid)
df2 <- MGS_plot_tb %>%
  left_join(MGS_taxon, by = c("variable" = "name")) %>%
  filter(value > 0.001 & !is.na(variable), code != 3) %>%
  group_by(taxid) %>%
  summarise(rel_abundance = sum(value)) %>%
  ungroup() %>%
  mutate(rel_abundance = rel_abundance/length(unique(MGS_plot_tb$index))) %>%
  rename(bacteria = taxid)

# >>> 查看重叠的样本数 >>>
inner_join(ITS_plot_tb, MGS_tb, by = "index") %>%
  distinct(index)

distinct(ITS_plot_tb, index)
# <<< 查看重叠的样本数 <<<


# 合并两个数据框的菌名列
bacteria <- unique(c(df1$bacteria, df2$bacteria))

# 创建逻辑向量，以指示每个样本中是否存在每个菌
in_df1 <- bacteria %in% df1$bacteria
in_df2 <- bacteria %in% df2$bacteria

# 计算共同和特定菌的数量和相对丰度的总和
n_both <- sum(in_df1 & in_df2)
n_only_df1 <- sum(in_df1 & !in_df2)
n_only_df2 <- sum(!in_df1 & in_df2)
sum_both <- sum(df1$rel_abundance[df1$bacteria %in% bacteria[in_df1 & in_df2]]) + 
            sum(df2$rel_abundance[df2$bacteria %in% bacteria[in_df1 & in_df2]])
sum_only_ITS <- sum(df1$rel_abundance[df1$bacteria %in% bacteria[in_df1 & !in_df2]])
sum_only_MGS <- sum(df2$rel_abundance[df2$bacteria %in% bacteria[!in_df1 & in_df2]])

round(sum_only_ITS * 100, 2)

ggVennDiagram(list(
    A = as.character(df1$bacteria),
    B = as.character(df2$bacteria)
  ),
  label = "count",
  label_alpha=0,
  category.names = c("ITS", "MGS"),
  set_size = 6) +
scale_x_continuous(expand = expansion(mult = .2)) +
scale_fill_gradient(low="#bef0fa",high = "#8dcdc0") +
scale_color_brewer(palette = "Paired")
ggsave("03_plot/venn_plot.png", width = 6, height = 6, dpi = 900)

