# CodeBook.md

## Source data

Dataset: UCI HAR Dataset (Human Activity Recognition Using Smartphones).
Full details here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

30 subjects, 6 activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS,
SITTING, STANDING, LAYING), data collected from a smartphone's
accelerometer and gyroscope.

## What run_analysis.R does

1. Merges the train and test data into a single dataset.
2. Keeps only the columns related to mean (`mean()`) and standard
   deviation (`std()`) of the measurements.
3. Replaces the numeric activity codes (1-6) with the descriptive
   activity name (e.g. WALKING).
4. Renames the columns to be more readable (e.g. `tBodyAcc-mean()-X`
   becomes `timeBodyAccelerometerMeanX`).
5. Computes the average of each variable for each subject/activity
   combination and saves the result to `tidy_data.txt`.

## Output: tidy_data.txt

- 180 rows (30 subjects x 6 activities)
- 68 columns: `subject`, `activity` + 66 numeric variables

The `subject` and `activity` columns identify the subject and the
activity. Every other column is the average of an original mean()/std()
measurement, computed for that subject during that activity. Column
names follow this pattern:

- `time`/`frequency` prefix: time domain or frequency domain
- `Accelerometer`/`Gyroscope`: which sensor was used
- `Mean`/`Std`: whether it's a mean or a standard deviation
- `X`/`Y`/`Z` suffix: axis (when present)

Example: `timeBodyAccelerometerMeanX` = mean of the body acceleration
signal (time domain), X axis.

Values are numeric and normalized between -1 and 1 (as in the original
dataset).

---
Note: project made for the "Getting and Cleaning Data" course.
