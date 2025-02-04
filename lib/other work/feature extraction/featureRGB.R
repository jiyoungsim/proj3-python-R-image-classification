#train_dir <- "../data/train_set/" 
#train_image_dir <- paste(train_dir, "images/", sep="")
#img_dir <- train_image_dir

feature <- function(img_dir, export=T){
  
  ### Construct process features for training/testing images
  ### Sample simple feature: Extract row average raw pixel values as features
  
  ### Input: a directory that contains images ready for processing
  ### Output: an .RData file contains processed features for the images
  
  ### load libraries
  library("EBImage")
  library(grDevices)
  ### Define the b=number of R, G and B
  nR <- 10
  nG <- 12
  nB <- 12 
  rBin <- seq(0, 1, length.out=nR)
  gBin <- seq(0, 1, length.out=nG)
  bBin <- seq(0, 1, length.out=nB)
  mat=array()
  freq_rgb=array()
  n_files <- length(list.files(img_dir))
  rgb_feature=matrix(nrow=n_files, ncol=nR*nG*nB)
  

  
########extract RGB features############
  for (i in 1:n_files){
    mat <- imageData(readImage(paste0(img_dir, sprintf("%04.f",i), ".jpg")))
    mat_as_rgb <-array(c(mat,mat,mat),dim = c(nrow(mat),ncol(mat),3))
    freq_rgb <- as.data.frame(table(factor(findInterval(mat_as_rgb[,,1], rBin), levels=1:nR), 
                                    factor(findInterval(mat_as_rgb[,,2], gBin), levels=1:nG),
                                    factor(findInterval(mat_as_rgb[,,3], bBin), levels=1:nB)))
    rgb_feature[i,] <- as.numeric(freq_rgb$Freq)/(ncol(mat)*nrow(mat)) # normalization
    
    mat_rgb <-mat_as_rgb
    dim(mat_rgb) <- c(nrow(mat_as_rgb)*ncol(mat_as_rgb), 3)
  }
  

rgb_feature <- cbind(rgb_feature,info$emotion_idx)

  if(export){
    saveRDS(rgb_feature, file = "../output/rgb_feature.RData")
  }
  return(data.frame(rgb_feature))
}
