# activity_tidy_set

## Files

- `run_analysis.R` - script that cleans and tidies the data
- `CodeBook.md` - describes the variables and transformations
- `tidy_data.txt` - output data set (created after running the script)

## How to run

1. Open R in this folder.
2. Install `dplyr` if needed: `install.packages("dplyr")`
3. Run: `source("run_analysis.R")`

The script downloads and unzips the UCI HAR Dataset (if not already
present), cleans it, and writes `tidy_data.txt`.

To load the result back into R:

```r
tidy_data <- read.table("tidy_data.txt", header = TRUE)
```

## Source

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
