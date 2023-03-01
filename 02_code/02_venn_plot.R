library(VennDiagram)

#接下来，你需要准备要用于 Venn 图的数据。这些数据通常是一组元素的列表，每个元素属于一个或多个集合。例如，以下是三个集合的元素列表：
set1 <- c("apple", "banana", "orange", "peach")
set2 <- c("apple", "pear", "kiwi", "grape")
set3 <- c("banana", "orange", "grape", "strawberry")
#然后，你可以使用 draw.triple.venn 函数来画出三组数据的 Venn 图。以下是一个示例代码：
draw.triple.venn(
  area1 = length(set1),
  area2 = length(set2),
  area3 = length(set3),
  n12 = length(intersect(set1, set2)),
  n23 = length(intersect(set2, set3)),
  n13 = length(intersect(set1, set3)),
  n123 = intersect(set1, intersect(set2, set3)),
  category = c("Set 1", "Set 2", "Set 3"),
  fill = c("dodgerblue", "goldenrod1", "darkorange"),
  lty = "blank",
  cex = 2,
  fontface = "bold",
  cat.fontface = "bold",
  cat.fontfamily = "sans",
  margin = 0.1,
  main = "Venn diagram of three sets"
)
#在这个示例代码中，我们首先使用 length 函数来计算每个集合的元素数量，
#然后使用 intersect 函数来计算两个集合之间的交集。接下来，我们将这些数据传递给 draw.triple.venn 函数，
#并设置一些选项来定制 Venn 图的外观和样式，例如设置每个集合的颜色、文本字体和大小、图表标题等等。

#运行这个代码会生成一个 Venn 图，其中包含三个集合的交集和各自的元素数量。
#你可以根据自己的数据和需求，进一步调整代码以绘制不同数量和类型的 Venn 图。