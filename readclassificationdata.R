library(RJSONIO)
library(stringr)

classifications_csv <- read.csv("generate-panicles-training-data-classifications.csv")

sorghum_annotations_json <- sapply(as.character(classifications_csv$annotations), function(x) {
  single_entry <- fromJSON(x)
})

subject_data <- as.character(classifications_csv$subject_data)
file_name_json <- sapply(subject_data, function(x) {
  return(fromJSON(x[[1]][[1]]))
})

#sorghum_annotations[50][[1]][[1]]$value[[1]]$y
#sorghum_annotations[50][[1]][[1]]$value[[1]]$x
#sorghum_annotations[50][[1]][[1]]$task
#file_name_json[50][[1]][[2]]

file_name_vector <- sapply(file_name_json, function(x) {
  return(x[[2]])
})
file_name_vector <- str_trim(basename(unname(file_name_vector)))

annotations_df <- data.frame(filename=character(),
                             task_id=character(), 
                             x_loc=character(), 
                             y_loc=character(),
                             stringsAsFactors=FALSE) 

for(i in 1:length(sorghum_annotations_json)) {
  for(j in 1:length(sorghum_annotations_json[i][[1]])) {
    
    if("value" %in% names(sorghum_annotations_json[i][[1]][[j]])) {
      for(k in 1:length(sorghum_annotations_json[i][[1]][[j]]$value)) {
        
        if(length(sorghum_annotations_json[i][[1]][[j]]$value) > 0) {
          file <- file_name_vector[i]
          task <- sorghum_annotations_json[i][[1]][[j]]$task
          x <- sorghum_annotations_json[i][[1]][[j]]$value[[k]]$x
          y <- sorghum_annotations_json[i][[1]][[j]]$value[[k]]$y
          df_to_add <- data.frame(filename=file,task_id=task,x_loc=x,y_loc=y)
          annotations_df <- rbind(annotations_df,df_to_add)
        }
      }
    }
  }
}

write.csv(annotations_df, "sorghum_annotations.csv", row.names = FALSE)


#Broken attempts at faster ways to parse difficult json data

# depth <- function(this) ifelse(is.list(this), 1L + max(sapply(this, depth)), 0L)
# 
# bind_at_any_depth <- function(l) {
#   if (depth(l) == 2) {
#     return(bind_rows(l))
#   } else {
#     l <- at_depth(l, depth(l) - 2, bind_rows)
#     bind_at_any_depth(l)
#   }
# }
#
#----------
# 
# flatten_df(sorghum_annotations_json,.id = 'var')
# 
#----------
#
# sorghum_annotations <- sapply(sorghum_annotations_json, function(x, annotations_df) { #For each element/image
#     sapply(x, function(y) { #For each task
#       img_name <- file_name_vector[which(as.character(classifications_csv$annotations) == names(x))] #Get current filename
#       cat(img_name)
#       img_name_base <- basename(img_name) #Get filename's basename
#       
#       sapply(y$value, function(z, task, img_name, img_name_base, annotations_df) {#For each click
#         entry <- list(filename_full=img_name, filename_base=img_name_base, task_id=task, x_loc=z$x, y_loc=z$y)
#         annotations_df <<- rbind(annotations_df,entry,stringsAsFactors=FALSE)
#       }, y$task, img_name, img_name_base, annotations_df)
#     }, annotations_df)
#   },annotations_df)
