library(jpeg)

#GLOBAL VARIABLES
source_dir <- "C:/Users/Alex/Documents/UNL East Sorghum 8-17-18/"
output_dir <- "C:/Users/Alex/Documents/UNL East Sorghum 8-17-18 SmallPics/"
number_of_row_subsets <- 5
number_of_column_subsets <- 2

files <- list.files(path=source_dir, pattern="*", full.names=TRUE, recursive=FALSE)
lapply(files, function(x) {
  
  #FILE NAME OF BASE PICTURE
  base_file_name <- gsub('.{4}$','',basename(x))
  
  #LOAD PICTURE INTO R,G,B MATRICES
  jpg <- readJPEG(x)
  
  #SET UP SUBSETS OF PICTURE
  rows <- dim(jpg)[1]
  cols <- dim(jpg)[2]
  
  row_subset_size <- rows / number_of_row_subsets
  column_subset_size <- cols / number_of_column_subsets
  
  count <- 0
  
  #DIVIDE PICTURE INTO NUMBER_OF_ROW_SECTIONS X NUMBER_OF_COLUMN_SECTIONS SUBSETS
  for(row_subset_index in c(0:(number_of_row_subsets-1))) {
    for(col_subset_index in c(0:(number_of_column_subsets-1))) {
      
      top_row_index <- row_subset_size*row_subset_index + 1
      bottom_row_index <- row_subset_size*(row_subset_index + 1)
      
      left_col_index <- column_subset_size*col_subset_index + 1
      right_col_index <- column_subset_size*(col_subset_index + 1)
      
      count <- count + 1
      
      #CREATE PROPER FILENAME
      outfile_name <- paste(base_file_name, '_', count, '.jpg', sep='')
      full_path_outfile <- paste(output_dir, outfile_name)
      
      #SELECT SUBSET OF IMAGE
      jpgDF <- jpg[c(top_row_index:bottom_row_index), c(left_col_index:right_col_index), c(1:3)]
      
      #SAVE PIC
      writeJPEG(jpgDF, target=full_path_outfile, quality=1.0)
      
      #OPTIONAL LOGGING, CHANGE TO IF(TRUE) TO LOG
      if(FALSE) {
        print(dim(jpg))  
        print(count)  
        print(x)
        print(basename(x))
        print(gsub('.{4}$','',basename(x)))
        base_file_name = gsub('.{4}$','',basename(x))
        cat("Outfile ,", paste(filename, '_', count, '.jpg', sep=''))
        cat("Rows ", rows, "\n")
        cat("Cols ", cols, "\n")
        cat("RowIndex ", row_subset_index, "\n")
        cat("col_subset_index ", col_subset_index, "\n")
        cat("RowSectionSize ", row_subset_size, "\n")
        cat("ColSectionSize ", column_subset_size, "\n")
        cat("top_row_index ", top_row_index, "\n")
        cat("bottom_row_index ", bottom_row_index, "\n")
        cat("left_col_index ", left_col_index, "\n")
        cat("right_col_index ", right_col_index, "\n")
      }
    }
  }
})
  