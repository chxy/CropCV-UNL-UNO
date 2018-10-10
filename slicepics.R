library(imager)

#GLOBAL VARIABLES
source_dir <- "C:/Users/Alex/Documents/UNL East Sorghum 8-17-18/"
output_dir <- "C:/Users/Alex/Documents/UNL East Sorghum 8-17-18 SmallPics/"
number_of_row_subsets <- 5
number_of_column_subsets <- 5

files <- list.files(path=source_dir, pattern="01[0-9]{2}", full.names=TRUE, recursive=FALSE)
lapply(files, function(x) {
  
  #FILE NAME OF BASE PICTURE
  base_file_name <- gsub('.{4}$','',basename(x))
  
  #LOAD PICTURE INTO R,G,B MATRICES
  full_jpg <- load.image(x)
  
  #SET UP SUBSETS OF PICTURE
  cols <- dim(full_jpg)[1]
  rows <- dim(full_jpg)[2]
  
  row_subset_size <- rows / number_of_row_subsets
  column_subset_size <- cols / number_of_column_subsets
  
  count <- 0
  
  #DIVIDE PICTURE INTO NUMBER_OF_ROW_SECTIONS X NUMBER_OF_COLUMN_SECTIONS SUBSETS
  for(col_subset_index in c(0:(number_of_column_subsets-1))) {
    for(row_subset_index in c(0:(number_of_row_subsets-1))) {
      
      top_row_index <- row_subset_size*row_subset_index + 1
      bottom_row_index <- row_subset_size*(row_subset_index + 1)
      
      left_col_index <- column_subset_size*col_subset_index + 1
      right_col_index <- column_subset_size*(col_subset_index + 1)
      
      count <- count + 1
      
      #CREATE PROPER FILENAME
      outfile_name <- paste(base_file_name, '_', count, '.jpeg', sep='')
      full_path_outfile <- paste(output_dir, outfile_name)
      
      #SELECT SUBSET OF IMAGE
      jpg_subset <- imsub(full_jpg, x %inr% c(left_col_index,right_col_index), y %inr% c(top_row_index,bottom_row_index))
      
      #SAVE PIC
      save.image(jpg_subset, file=full_path_outfile, quality=1.0)
    }
  }
})
  