library("vegan")
source("02_code/03_abundance_boxplot.R")
# ITS_plot_tb MGS_plot_tb 是处理好的丰度数据
ITS_table <- ITS_plot_tb %>%
    rename(ITS_abundance = value) %>%
    dcast(index ~ variable, value.var = "ITS_abundance",
        fun.aggregate = mean, fill = 0) %>%
    column_to_rownames("index")

sp1 <- specaccum(ITS_table, "random")
plot(sp1, ci.type="bar", col="lightblue",
    lwd=2, ci.lty=1, ci.col="#c3e8f4",
    xlab="Number of samples", ylab="Species accumulation",
    main="ITS data")
# boxplot(sp1, col="#f1d4a7", add=TRUE, pch="+", border="#c79a45")

MGS_table <- MGS_plot_tb %>%
    rename(MGS_abundance = value) %>%
    dcast(index ~ variable, value.var = "MGS_abundance",
        fun.aggregate = mean, fill = 0) %>%
    column_to_rownames("index")

sp2 <- specaccum(MGS_table, "random")
plot(sp2, ci.type="bar", col="lightblue",
    lwd=2, ci.lty=1, ci.col="#c79a45",
    xlab="Number of samples", ylab="Species accumulation",
    main = "MGS data")

# 将两个plot拼接在一起
png("03_plot/accumulation_curves.png", width = 1300, height = 650)
par(mfrow = c(1, 2))
plot(sp1, ci.type="bar", col="lightblue",
    lwd=2, ci.lty=1, ci.col="#c3e8f4",
    xlab="Number of samples", ylab="Species accumulation",
    main="ITS data")
plot(sp2, ci.type="bar", col="lightblue",
    lwd=2, ci.lty=1, ci.col="#c79a45",
    xlab="Number of samples", ylab="Species accumulation",
    main = "MGS data")
dev.off()
# 恢复绘图参数
par(mfrow = c(1, 1))
dev.off()
