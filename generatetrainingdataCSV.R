
#Save sorghum photos
get_bbox <- function(jpeg,x,y) {
  jpeg <- image_read(jpeg)
  
  cols <- image_info(jpeg)$height
  rows <- image_info(jpeg)$width
  
  top_row <- y-(training_data_height/2)
  bottom_row <- y+(training_data_height/2)
  
  left_col <- x-(training_data_width/2)
  right_col <- x+(training_data_width/2)
  
  #If the box juts out of the picture dimensions
  if(top_row < 1) {
    bottom_row <- bottom_row + (1-top_row)
    top_row <- 1
  }
  if(bottom_row > rows) {
    top_row <- top_row - (bottom_row - rows)
    bottom_row <- rows
  }
  if(left_col < 1) {
    right_col <- right_col + (1-left_col)
    left_col <- 1
  } 
  if(right_col > cols) {
    left_col <- left_col - (right_col - cols)
    right_col <- cols
  }
  
  bbox <- c(left_col,top_row,right_col,bottom_row)
  return(bbox)
}

library(magick)

source_dir <- "C:/Users/Alex/Documents/UNL-East-Sorghum-8-17-18-SmallPics/"
output_dir <- "C:/Users/Alex/CropCV-UNL-UNO/"
output_file <- "flower_training_data.csv"

training_data_width <- 60
training_data_height <- 60

annotations <- read.csv(paste0(output_dir,"sorghum_annotations.csv"),header=TRUE)
annotations$filename <- as.character(annotations$filename)
annotations$task_id <- as.character(annotations$task_id)
annotations$x_loc <- as.integer(annotations$x_loc)
annotations$y_loc <- as.integer(annotations$y_loc)

annotations <- annotations[which(annotations$task_id=="T0"),]

training_data_csv <- data.frame()
  
for(i in 1:nrow(annotations)) {
  single_file <- annotations[i,"filename"]
  single_file <- paste0(source_dir,single_file)
  x_curr <- annotations[i,"x_loc"]
  y_curr <- annotations[i,"y_loc"]
  bbox_curr <- get_bbox(single_file,x_curr,y_curr)
  
  temp_list = list(as.character(single_file),bbox_curr[1],bbox_curr[2],bbox_curr[3],bbox_curr[4],as.character("flower")) 
  
  training_data_csv <- rbind(training_data_csv,temp_list,stringsAsFactors=FALSE)
}

data_file <- paste0(output_dir,output_file)

write.csv(training_data_csv,data_file,row.names = FALSE,col.names = NA)

