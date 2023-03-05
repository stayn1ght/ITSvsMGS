source("02_code/03_abundance_boxplot.R")

library("vegan")
library("ggplot2")

ITS_table <- ITS_plot_tb %>%
    filter(!is.na(variable)) %>%
    mutate(index = paste0("ITS_", index))
    

MGS_table <- MGS_plot_tb %>%
    filter(!is.na(variable)) %>%
    mutate(index = paste0("MGS_", index))

mydata <- rbind(ITS_table, MGS_table) %>%
    dcast(index ~ variable, value.var = "value",
        fun.aggregate = mean, fill = 0) %>%
    column_to_rownames("index")

group_df <- tibble(tibble(index = rownames(mydata))) %>%
    mutate(group = ifelse(str_detect(index, "ITS"), "ITS", "MGS")) %>%
    column_to_rownames("index")
    
# 计算距离矩阵
mydist <- vegdist(mydata, method = "bray")

mypcoa <- cmdscale (mydist, eig=TRUE)

# 提取前两个PCoA坐标
pcoa_coords <- data.frame({mypcoa$points})[, 1:2]

# 添加元数据
pcoa_plot <- cbind(pcoa_coords, group_tb)
ggplot(pcoa_plot, aes(x=X1, y=X2, color=group,shape=group)) +
    geom_point(size = 3) +
    xlab("PCoA1") + 
    ylab("PCoA2") +
    theme_bw() + 
    stat_ellipse(data=pcoa_plot, geom = "polygon", level=0.9, size=0.5, aes(fill=group), alpha=0.2, show.legend = T)
ggsave("03_plot/PCoA.png", width = 6, height = 6, units = "in", dpi = 900)


# 绘制PCoA图
ggplot(pcoa_coords, aes(x = Axis1, y = Axis2, color = group)) +
  geom_point(size = 3) +
  xlab("PCoA1") + ylab("PCoA2") +
  ggtitle("PCoA Plot of Microbial Communities") +
  theme(plot.title = element_text(hjust = 0.5))


