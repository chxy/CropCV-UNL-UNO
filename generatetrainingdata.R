library(imager)

#Save sorghum photos
bounding_box <- function(jpeg,x,y) {
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
  
  return(c(left_col, top_row, right_col, bottom_row))
}

data_dir <- "C:/Users/Alex/CropCV-UNL-UNO/"
data_file <- "sorghum_annotations.csv"
source_dir <- "C:/Users/Alex/Documents/UNL East Sorghum 8-17-18 SmallPics/"
output_dir <- "C:/Users/Alex/CropCV-UNL-UNO/train/annotations/"

training_data_width <- 60
training_data_height <- 60

input_data <- paste0(data_dir,data_file)
annotations_t0 <- read.csv(input_data)
annotations_t0 <- annotations_t0[which(annotations_t0$task_id=="T0"),]

annotations_t0$filename <- as.character(annotations_t0$filename)
annotations_t0$task_id <- as.character(annotations_t0$task_id)
annotations_t0$x_loc <- as.integer(annotations_t0$x_loc)
annotations_t0$y_loc <- as.integer(annotations_t0$y_loc)

annotations_filecounts <- list()

for(i in 1:nrow(annotations_t0)) {
  input_file <- paste0(source_dir,annotations_t0[i,"filename"])
  jpeg <- image_read(input_file)
  coords <- bounding_box(jpeg,annotations_t0[i,"x_loc"],annotations_t0[i,"y_loc"])
  
  width <- coords[3]-coords[1]
  height <- coords[4]-coords[2]
  
  jpeg <- image_modulate(jpeg, brightness=0, saturation=0)
  jpeg_draw <- image_draw(jpeg)
  rect(coords[1],coords[4],coords[3],coords[2],col="white",border=NA)
  dev.off()
  
  base <- gsub('\\..{4}$','',basename(annotations_t0[i,"filename"]))
  
  if(is.null(annotations_filecounts[[base]])) {
    annotations_filecounts[[base]] <- as.numeric(1)
  } else {
    
    annotations_filecounts[[base]] <- as.numeric(annotations_filecounts[[base]])+1
  }
  
  count <- annotations_filecounts[[base]]
  
  output_file <- paste0(output_dir,base,"_","flower","_",count,".jpeg")
  image_write(jpeg_draw,output_file)
}
