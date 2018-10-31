library(imager)

source_dir <- "C:/Users/Alex/Documents/UNL East Sorghum 8-17-18 SmallPics/"
output_dir_no_task <- "C:/Users/Alex/Documents/CropCV-TrainingData-"

training_data_width <- 60
training_data_height <- 60

annotations <- read.csv("sorghum_annotations.csv")
annotations$filename <- as.character(annotations$filename)
annotations$task_id <- as.character(annotations$task_id)
annotations$x_loc <- as.integer(annotations$x_loc)
annotations$y_loc <- as.integer(annotations$y_loc)

annotations$filename_fullpath <- paste0(source_dir,annotations$filename)

unique_file_names <- unique(annotations$filename)

#Save sorghum photos
save_single_example <- function(jpeg,file,task,x,y,output_dir) {
  jpeg <- image_read(jpeg)
  file_name_no_ext <- gsub('.jpeg$','',file)
  file_output <- paste0(output_dir,file_name_no_ext,'_',task,'_',x,'_',y,'.jpeg')
  
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
  
  jpg_subset <- image_crop(jpeg,geometry_area(training_data_width,training_data_height,left_col,top_row))
  image_write(jpg_subset, path=file_output, quality=100)
}


test_index <- 1
  
for(single_file in unique_file_names[test_index]) {
  jpeg <- image_read(paste0(source_dir,single_file))
  for(task in c("T0","T1","T2")) {
    clicks_on_pic <- annotations[which(annotations$task_id==task & annotations$filename==single_file),]
    output_dir <- paste0(output_dir_no_task,task,"/")
    if(nrow(clicks_on_pic)>0) {
      mapply(save_single_example,jpeg, clicks_on_pic$filename, task, clicks_on_pic$x_loc, clicks_on_pic$y_loc, output_dir)
    }
  } 
}

#mapply(save_single_example,annotations_t0$filename_fullpath, annotations_t0$filename, annotations_t0$task_id, annotations_t0$x_loc, annotations_t0$y_loc, output_dir_T0)
#mapply(save_single_example,annotations_t1$filename_fullpath, annotations_t1$filename, annotations_t1$task_id, annotations_t1$x_loc, annotations_t1$y_loc, output_dir_T1)
#mapply(save_single_example,annotations_t2$filename_fullpath, annotations_t2$filename, annotations_t2$task_id, annotations_t2$x_loc, annotations_t2$y_loc, output_dir_T2)