---
title: "README"
author: "Kami Koleva"
date: "Sunday, November 23, 2014"
output: html_document
---

This file describes how to work with run_analysis.R script.

1. Download the file run_analysis.R, save in your prefered location.
2. Run the script by using the command "run_analysis.R"

Note: The script will check if the initial input data set is present 
in your home directory, by looking for a folder with name "UCI HAR Dataset".
In case this directory is missinfg, the data set will be downloaded and unzipped.

3. The final tidy data set is exported in the file called "tidy_data.txt" 
in the "UCI HAR Dataset" folder contained in your home directory.

4. The working directory will be set to your home directory.

Note: For more details inspect the CodeBook.md and the comments in run_analysis.R.