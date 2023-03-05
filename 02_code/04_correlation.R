source("02_code/03_abundance_boxplot.R")
# ITS_plot_tb MGS_plot_tb 是处理好的丰度数据
ITS_plot_tb %>%
    rename(ITS_abundance = value)

MGS_plot_tb %>%
    rename(MGS_abundance = value)