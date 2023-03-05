source("02_code/03_abundance_boxplot.R")
ITS_plot_tb %>%
    filter(value > 0.01 & !is.na(variable)) %>%
    distinct(variable) %>%
    write_csv("ITS_species.csv")
MGS_plot_tb %>%
    filter(value > 0.001 & !is.na(variable)) %>%
    distinct(variable) %>%
    write_csv("MGS_species.csv")

ITS_taxon <- read_delim("ITS_report.txt", delim = "\t|\t", col_names = FALSE, skip = 3) %>%
    rename(
        code = X1,
        name = X2,
        preferred_name = X3,
        taxid = X4
    )

MGS_taxon <- read_delim("MGS_report.txt", delim = "\t|\t", col_names = FALSE, skip = 3) %>%
    rename(
        code = X1,
        name = X2,
        preferred_name = X3,
        taxid = X4
    )

