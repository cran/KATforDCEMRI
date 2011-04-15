%%    KATforDCEMRI: a Kinetic Analysis Tool for DCE-MRI
%%    Copyright 2014 Genentech, Inc.
%%
%%    For questions or comments, please contact
%%    Gregory Z. Ferl, Ph.D.
%%    Genentech, Inc.
%%    Development Sciences
%%    1 DNA Way, Mail stop 463A
%%    South San Francisco, CA, United States of America
%%    E-mail: ferl.gregory@gene.com

\name{dcemri.data}
\alias{dcemri.data}
\docType{data}
\title{
A sample DCE-MRI data set.
}
\description{
A simulated data set based on the extended Tofts model that includes time
and AIF vectors, contrast agent concentration-time maps and an ROI mask.
}
\usage{data(dcemri.data)}
\format{
  The format is:
List of 4

 $ vectorTimes: num [1:89] 0.00000  4.83328  9.66656 14.49984 ...

 $ mapCC      : num [1:25, 1:25, 1:2, 1:89] NA NA NA NA NA NA ...

 $ maskROI    : int [1:25, 1:25, 1:2] 0 0 0 0 0 0 0 0 0 0 ...

 $ vectorAIF  : num [1:25] -1.0546669 -15.1168922  13.4470030  ...

}
\details{
A simulated four-slice DCE-MRI data set was generated using the extended
Tofts model with mean parameter values set to
\eqn{K^{trans}=0.22~min^{-1}}{Ktrans=0.22 1/min} and \eqn{k_{ep}=1.1~min^{-1}}{kep=1.1 1/min}
for all voxels in each slice. Slices 1 and 3 have \eqn{v_b}{vb} set to 0 while
slices 2 and 4 have \eqn{v_b}{vb} set to 0.05.  Prior to contrast agent time course
simulation for each voxel, the three model parameters (\eqn{K^{trans}}{Ktrans},
\eqn{k_{ep}}{kep}, \eqn{v_b}{vb})
are multiplied by a random variable drawn from a normal distribution
with mean=1 and sd=0.2 (slice 1 and 2) or sd=0.3 (slices 3 and 4).  An additional level of noise is added to each voxel by
multipliying every simulated contrast agent concentration by a random
variable drawn from a normal distribution of mean=1 and sd=0.25 (slices 1
and 2) or sd=0.75 (slices 3 and 4).
}
\seealso{
\code{\link{KAT}}, \code{\link{KAT.checkData}}, \code{\link{KAT.plot}}
}
\keyword{datasets}
