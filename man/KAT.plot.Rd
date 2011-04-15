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

\name{KAT.plot}
\alias{KAT.plot}
\title{
Plots multiple image slices.
}
\description{
Plots multiple image slices on the same color scale within a single PDF file.
}
\usage{
KAT.plot(F1=0, F2=0, F3=0, F4=0, F5=0, F6=0, F7=0,
F8=0, plot.param="Ktrans", range.map = 1.5, cutoff.map=0.85, ...)
}
\arguments{
  \item{F1}{
KAT output file containing parametric map 1.
}
  \item{F2}{
KAT output file containing parametric map 2.
}
  \item{F3}{
KAT output file containing parametric map 3.
}
  \item{F4}{
KAT output file containing parametric map 4.
}
  \item{F5}{
KAT output file containing parametric map 5.
}
  \item{F6}{
KAT output file containing parametric map 6.
}
  \item{F7}{
KAT output file containing parametric map 7.
}
  \item{F8}{
KAT output file containing parametric map 8.
}
  \item{plot.param}{
Which parameter will be plotted? Can be set to \code{Ktrans},
\code{kep}, \code{vb} or \code{ve}. (Default=\code{Ktrans}).
}
  \item{...}{
Arguments passed on to inner functions.
}
  \item{range.map}{
Specifies range of color scale relative to the max value within map (typically a value between 1 and 3; default=1.5).}
  \item{cutoff.map}{
Truncate parametric map values by max value x cutoff (typically a value between 0 and 1; default=0.85).
}
}
\details{
For n slices, 3 x n figure panels will
be generated where n is the number of slices to be plotted.  MAP is the
parametric map for the slice of interest, while AIC is the model
discrimination map for the slice of interest. ROI is the median contrast agent concentration-time profile
over all voxels within the region of interest shown with associated
estimated extended Tofts model parameters.

slice 1----slice 2----slice 3----slice 4----slice 5----slice 6----slice 7----slice 8

[MAP]---[MAP]---[MAP]---[MAP]---[MAP]---[MAP]---[MAP]---[MAP]

[AIC]-----[AIC]-----[AIC]-----[AIC]------[AIC]-----[AIC]-----[AIC]-----[AIC]

[ROI]-----[ROI]-----[ROI]-----[ROI]----[ROI]-----[ROI]-----[ROI]-----[ROI]
}
\author{
Gregory Z. Ferl
}
\keyword{ kinetic }
\keyword{ DCEMRI }
