library(jpeg)

#GLOBAL VARIABLES
source_dir <- "C:/Users/Alex/Documents/UNL East Sorghum 8-17-18/"
output_dir <- "C:/Users/Alex/Documents/UNL East Sorghum 8-17-18 SmallPics/"
number_of_row_sections <- 5
number_of_column_sections <- 2

files <- list.files(path=source_dir, pattern="*", full.names=TRUE, recursive=FALSE)
lapply(files, function(x) {
  
  #FILE NAME OF BASE PICTURE
  basefilename = gsub('.{4}$','',basename(x))
  
  #LOAD PICTURE INTO R,G,B MATRICES
  jpg <- readJPEG(x)
  
  #SET UP SUBSETS OF PICTURE
  rows=dim(jpg)[1]
  cols=dim(jpg)[2]
  
  rowSectionSize = rows / number_of_row_sections
  colSectionSize = cols / number_of_column_sections
  
  count = 0
  
  #DIVIDE PICTURE INTO NUMBER_OF_ROW_SECTIONS X NUMBER_OF_COLUMN_SECTIONS SUBSETS
  for(rowIndex in c(0:(rowSections-1))) {
    for(columnIndex in c(0:(colSections-1))) {
      
      TopRow = rowSectionSize*rowIndex + 1
      BottomRow = rowSectionSize*(rowIndex + 1)
      
      LeftCol = colSectionSize*columnIndex + 1
      RightCol = colSectionSize*(columnIndex + 1)
      
      count = count + 1
      
      #CREATE PROPER FILENAME
      filename = paste(basefilename, '_', count, '.jpg', sep='')
      fulloutfile = paste(output_dir, filename)
      
      #SELECT SUBSET OF IMAGE
      jpgDF = jpg[c(TopRow:BottomRow), c(LeftCol:RightCol), c(1:3)]
      
      #SAVE PIC
      writeJPEG(jpgDF, target=fulloutfile, quality=1.0)
      
      #OPTIONAL LOGGING, CHANGE TO IF(TRUE) TO LOG
      if(FALSE) {
        print(dim(jpg))  
        print(count)  
        print(x)
        print(basename(x))
        print(gsub('.{4}$','',basename(x)))
        filename = gsub('.{4}$','',basename(x))
        cat("Outfile ,", paste(filename, '_', count, '.jpg', sep=''))
        cat("Rows ", rows, "\n")
        cat("Cols ", cols, "\n")
        cat("RowIndex ", rowIndex, "\n")
        cat("columnIndex ", columnIndex, "\n")
        cat("RowSectionSize ", rowSectionSize, "\n")
        cat("ColSectionSize ", colSectionSize, "\n")
        cat("TopRow ", TopRow, "\n")
        cat("BottomRow ", BottomRow, "\n")
        cat("LeftCol ", LeftCol, "\n")
        cat("RightCol ", RightCol, "\n")
      }
    }
  }
})
  