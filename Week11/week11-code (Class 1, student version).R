
# Script for ...


######## 0. Set the working environemnt and Load the jpeg package

# Remove all variables from the R environment to create a fresh start
rm(list=ls())

# Set the working folder
# getwd()
# setwd("...")

# Install the "jpeg" package to read, write, and display images in "jpeg" format
if(!require(jpeg)){
  install.packages("jpeg")
  library(jpeg)
}


######## 1. Eigendecomposition

# Define matrix
A <- matrix(c(2, 2, 3, 1), nrow=2, ncol=2)
# Eigenvalues and eigenvectors
A_eig <- eigen(A)
#
# Implement the eigendecomposition (note the operator %*% for the matrix multiplication)
A_eig$vectors %*% diag(A_eig$values) %*% solve(A_eig$vectors)
A

# Define psd matrix 
A <- matrix(c(3, 1, 1, 3), nrow=2, ncol=2)
# A %*% t(A) == t(A) %*% A
# Eigenvalues and eigenvectors
A_eig <- eigen(A)
#
# Implement the eigendecomposition
A_eig$vectors %*% diag(A_eig$values) %*% solve(A_eig$vectors)
A_eig$vectors %*% diag(A_eig$values) %*% t(A_eig$vectors)
A


######## 2. Singular Value Decomposition (SVD)

# Define matrix
X <- matrix(c(2,1,5,7,0,0,6,0,0,10,8,0,7,8,0,6,1,4,5,0), nrow=5, ncol=4)
#
# Apply SVD
s <- svd(X)
#
# Read output
s$d # singular values
s$u # left singular vectors
s$v # right singular vectors
#
# Test
s$u %*% diag(s$d) %*% t(s$v)

# Approximating X
X_hat <- s$u[,1:3] %*% diag(s$d[1:3]) %*% t(s$v[,1:3])
X - X_hat

# Calculate the explained variance
var <- cumsum(s$d^2)
str(var)
plot(1:4,var/max(var))


######## 3. SVD for Image compression

################ 3.1 Greyscale image  

# We start by reading the lky image as a 3D array.
?readJPEG
lky <- readJPEG("lky.jpg")
str(lky)
# The figure has a size of 6 Mb. This is read into an array of size 410 x 640 x 3,
# height x width x channel.
#
# The values of the channels vary between 0.313 to 1.
min(lky[,,1])
max(lky[,,1]) 
#
# We can verify that all three channels have the same values
max(abs((lky[,,1]-lky[,,2])))
max(abs((lky[,,1]-lky[,,3])))

# Let's now perform the Singular Value Decomposition (SVD)
s <- svd(lky[,,1])
s$d # singular values
s$u # left singular vectors
s$v # right singular vectors

# With s, we can now perform a low rank approximation. In particular, 
# we do a rank-10 approximation by using the top 10 singular values.
lky10 <- ..   
#
# Save the results into a jpeg file
?writeJPEG
writeJPEG(lky10,"lky10.jpg") # Note that this writes a grayscale image of size 16kb.
# ... obviosuly, the file is lossy and loses a lot of information.
#
# Let's retry with a rank50 approximation.
lky50 <- ..
writeJPEG(lky50,"lky50.jpg")
# This time, we get a size of 24 and a better resolution.

# Let's plot the cumulative sum of the (squared) singular values, so as to calculate the explained variance
var <- cumsum(s$d^2)
str(var)
plot(1:410,var/max(var))
# The plot shows that with a few singular values we can get ~99% of the explain variance. How many?
..

################ 3.2 RGB image

# We now repeat the analysis using a RGB image
pansy <- readJPEG("pansy.jpg")
str(pansy)
# The figure has a size of 6.4 Mb. This is read into an array of size 600 x 465 x 3,
# height x width x channel (with each channel representing the RGB intensity.
# Note that in this case pansy[,,1] is different than pansy[,,2]
max(abs((pansy[,,1]-pansy[,,2])))

# Let's now perform the Singular Value Decomposition (SVD) on the different channels
s1 <- ..
s2 <- ..
s3 <- ..
#
# Develop low rank approximation (with rank 50)
# initialize the vector for storing the approximation
pansy50 <- array(dim=c(600,465,3))
pansy50[,,1] <- ..
pansy50[,,2] <- ..
pansy50[,,3] <- ..
#
# Save the image in a jpeg file of ize ~40 kb, which has some blurring edges of the flower and leaves.
writeJPEG(pansy50,"pansy50.jpg")
#
# let's retey with a higher approximation
pansy350 <- array(dim=c(600,465,3))
pansy350[,,1] <- ..
pansy350[,,2] <- ..
pansy350[,,3] <- ..
writeJPEG(pansy350,"pansy350.jpg") # --> much better!







