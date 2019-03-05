%%    KATforDCEMRI: a Kinetic Analysis Tool for DCE-MRI
%%    Copyright 2019 Genentech, Inc.
%%
%%    For questions or comments, please contact
%%    Gregory Z. Ferl, Ph.D.
%%    Genentech, Inc.
%%    Development Sciences
%%    1 DNA Way, Mail stop 463A
%%    South San Francisco, CA, United States of America
%%    E-mail: ferl.gregory@gene.com

\name{KAT.checkData}
\alias{KAT.checkData}
\title{
Checks and converts your data to the RData file format.
}
\description{
Load your data into an R session and save as an RData file that can be analyzed by the KAT function.  Also check that dimensions of vectors and arrays are consistent.
}
\usage{
KAT.checkData(file.name, vector.times, map.CC, mask.ROI, vector.AIF, map.tlag=NULL,
write.data.to.file=TRUE)
}
\arguments{
  \item{file.name}{
    Give a name to the RData file that will be generated with this
    function. A \code{.RData} extension will automatically be added.
}
  \item{vector.times}{
The nt x 1 time vector; can have units of seconds or minutes.  KAT
will automatically assign units based on the following
assumptions: units are minutes if \eqn{t_{max}<100}{tmax < 100} and seconds
if \eqn{t_{max} \ge 100}{tmax >= 100}. Please make sure that these
assumptions are consistent with your data.  You will have to manually
convert the time vector into seconds or minutes prior to running \code{KAT.checkData}
if the time vector specified by \code{vector.times} has other units.
}
  \item{map.CC}{
The nx x ny x ns x nt contrast agent intensity/concentration array.
}
  \item{mask.ROI}{
The nx x ny x ns ROI mask array where voxels within the ROI are assigned a 1 and those outside assigned a 0.
}
  \item{vector.AIF}{
The nt x 1 arterial (vascular) input function.
}
 \item{map.tlag}{
The nx x ny x ns array that contains per-voxel tag times estimated
outside of KAT, to be applied
to the vascular input function. Units must be same as those used for
vector.times. This argument is optional.
}
\item{write.data.to.file}{
  Should the original data, loaded into R, be saved in a single RData
  file for future use? Default=TRUE.

  NOTE: if set to FALSE, usage for
  this function must be exactly as follows:


  R> dcemri.data <- KAT.checkData(args)

  R> KAT(args)


  where the \code{file} argument is \bold{not} specified when calling KAT().
}
}
\value{
Returns an RData file that can be read by the \code{KAT} function.
}
\author{
Gregory Z. Ferl
}
\note{
The \code{KAT} function can also read data stored as an uncompressed MATLAB 5 file.
}
\seealso{
\code{\link{KAT}}, \code{\link{KAT.plot}}, \code{\link{dcemri.data}}
}
\examples{
## Create temporary directory for benchmark example code output files
temp_dir <- tempdir(check=FALSE)
##
current_dir <- getwd()
setwd(temp_dir)
##
## Run example code
data(dcemri.data, package="KATforDCEMRI")
a1=dcemri.data$vectorTimes
a2=dcemri.data$mapCC
a3=dcemri.data$maskROI
a4=dcemri.data$vectorAIF
KAT.checkData("f",vector.times=a1,map.CC=a2,mask.ROI=a3,vector.AIF=a4,write.data.to.file=TRUE)
##
setwd(current_dir)
}
\keyword{ data }
\keyword{ check }