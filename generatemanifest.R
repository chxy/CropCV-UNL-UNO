source_output_dir <- "C:/Users/Alex/Documents/UNL East Sorghum 8-17-18 SmallPics/"
files_in_dir <- list.files(path=source_output_dir, pattern="*", full.names=TRUE, recursive=FALSE)
files_in_dir_vec <- unlist(files_in_dir)

output_file_name <- paste(source_output_dir, "manifest.csv")
fileConn <- file(output_file_name)

writeLines("filename",fileConn)

#file_names <- basename(files_in_dir_vec)

writeLines(files_in_dir_vec,fileConn)

close(fileConn)
