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

\name{KAT}
\alias{KAT}
\title{
Kinetic Analysis Tool for DCE-MRI
}
\description{
Fits the selected model structure to voxel-wise contrast agent concentration data.
}
\usage{
KAT(file = "concatenate.KAT.with.KAT.checkData.RData",
results_file="my_results", method.optimization = "L-BFGS-B",
show.rt.fits = FALSE, param.for.avdt = "Ktrans", range.map = 1.5,
cutoff.map = 0.85, export.matlab = TRUE, export.RData = TRUE,
verbose=FALSE, show.errors = FALSE, try.silent=TRUE, fracGTzero = 0.75,
AIF.shift = "", Force.AIF.peak = FALSE, tlag.Tofts.on = FALSE, ...)
}
\arguments{
  \item{file}{
Specify the file to be analyzed.
}
  \item{results_file}{
Specify the absolute path to the folder, including file name with no
extension (.RData and/or .mat will be automatically added) of the file
where results are to be saved.
}
  \item{method.optimization}{
Optimization method (\code{Nelder-Mead}, \code{BFGS}, \code{CG}, \code{L-BFGS-B}, \code{SANN}); default=\code{L-BFGS-B}.
}
  \item{show.rt.fits}{
Shows voxel-wise fits as each ROI is processed (default=\code{FALSE}).
}
  \item{param.for.avdt}{
Select extended Tofts model param to display using avdt (\code{Ktrans},
\code{kep}, \code{ve}, \code{vb}; default=\code{Ktrans}).
}
  \item{range.map}{
Specifies range of color scale relative to the max value within map (typically a value between 1 and 3; default=1.5).
}
  \item{cutoff.map}{
Truncate parametric map values by max value \eqn{\times}{*} cutoff (typically a value between 0 and 1; default=0.85).
}
\item{export.matlab}{
Save results in a matlab file? (default=\code{TRUE}). NOTE: matlab files
are intended only for use with MATLAB and are not meant to be read back into R for viewing with the advanced voxel
diagnosis tool.
}
\item{export.RData}{
Save results in an RData file? (default=\code{TRUE}).
}
\item{verbose}{
Should voxel-wise contrast agent curves and other voxel specific
information be printed in the terminal
during the parameter estimation process? (default=\code{FALSE}).
}
\item{show.errors}{
  Should errors messages be printed while KAT is running? Default is \code{show.errors = FALSE}.
}
\item{try.silent}{
  Should the \code{silent} argument within \code{try} functions be TRUE or
  FALSE? Default is \code{try.silent=TRUE}.
}
\item{fracGTzero}{
  Voxels are excluded from analysis if less than 'fracGTzero' of
  contrast agent concentrations in a voxel time series are greater
  than zero. (a value between 0 and 1; default is \code{fracGTzero = 0.75}).
}
\item{AIF.shift}{
  Specify if your vascular input function is based on arterial or
  venous data.  Possible values are \code{"ARTERY"} or \code{"VEIN"} (or
  \code{"NONE"} if you prefer to not estimate the \eqn{t_{lag}}{tlag} parameter).  This
  argument must be specified when running \code{KAT}.
}
\item{Force.AIF.peak}{
  Do you want to force the peak values of the shifted Vascular input
  Function to be equal to the peak value of the original, raw VIF that
  is read into \code{KAT}? The value of this argument is ignored if
  \code{AIF.shift}=\code{"NONE"}. (default=\code{FALSE}).
}
\item{tlag.Tofts.on}{
  Do you want to estimate \eqn{t_{lag}}{tlag} for the Tofts model
  (\code{tlag.Tofts.on = TRUE})?. If \code{tlag.Tofts.on = FALSE}, \eqn{t_{lag}}{tlag} for the Tofts
 model will be set equal to the \eqn{t_{lag}}{tlag} value estimated for
 the extended Tofts model. Use with caution, since there may be
 parameter identifiability issues associated with estimated
 \eqn{t_{lag}}{tlag} when fitting the Tofts model to data. (default=\code{FALSE}).
}
\item{...}{
Pass arguments to functions within \code{KAT}.
}
}

\details{
\bold{Demo}

Run the KAT benchmark test by typing

\code{R> demo(KAT, ask=FALSE)}

at the R prompt, to analyze the simulated DCE-MRI data set described in \code{\link{dcemri.data}}.

\bold{Model equations [refs. 1-2]}

\emph{Tofts Model}

\deqn{\frac{dC_t(t)}{dt}=K^{trans}\mbox{VIF}(t \pm t_{lag})-k_{ep}C_t(t)}{dCt(t)/dt = Ktrans*VIF(t)-kep*Ct(t)}

\emph{and}

\deqn{C(t) = C_t(t).}{C(t) = Ct(t).}

\emph{Extended Tofts Model}

\deqn{\frac{dC_t(t)}{dt}=K^{trans}\mbox{VIF}(t \pm t_{lag})-k_{ep}C_t(t)}{dCt(t)/dt = Ktrans*VIF(t)-kep*Ct(t)}

\emph{and}

\deqn{C(t)=v_b\mbox{VIF}(t \pm t_{lag})+C_t(t),}{C(t)=v_b*VIF(t)+Ct(t),}

\emph{where}

\deqn{C_{t}=\mbox{tissue/region of interest}}{Ct = tissue/region of interest}

\emph{and}

\deqn{C(t): \mbox{measurement model for ROI corresponding to observed CA
    conc}.}{C(t): measurement model for ROI corresponding to observed CA conc.}

\emph{VIF\eqn{(t \pm t_{lag})}{(t +/- tlag)} represents the Vascular Input Function as VIF\eqn{(t + t_{lag})}{(t + tlag)} if the measured VIF is based on arterial data or VIF\eqn{(t - t_{lag})}{(t - tlag)} if the measured VIF is based on venous data.}

\bold{Objective Function [ref. 3]}

\emph{The objective function based on maximum likelihood can be
  written as}

\deqn{\mbox{OF}_{M}=\frac{1}{n_D}\sum_{i=1}^{n_D}\left[ log \left(
  \frac{1}{\mbox{SD}_i^2} \right) + \left(
  \frac{(y_i-s(\hat{p},t_i))^2}{\mbox{SD}_i^2} \right)
  \right],}{OF_M=1/nD*sum(i=1 to nD)[log(1/SDi^2) + (y_i-s(p_hat,ti))^2/(SDi^2)],}

\emph{where}

\deqn{\mbox{SD}_i = \mbox{standard deviation of each data point } i
  \mbox{ in the
  intensity/concentration time curve},}{SDi = standard deviation of each
  data point i in the intensity/concentration time curve,}

\deqn{y_i = \mbox{data point } i \mbox{ in the
  intensity/concentration time curve},}{yi = data point i in the intensity/concentration time curve,}

\deqn{s(\hat{p},t_i) = \mbox{simulated data point at parameter vector }
  \hat{p} \mbox{ and time point } t_i,}{s(p_hat,ti) = simulated data
  point at parameter vector p_hat and time point ti,}

\emph{and}

\deqn{n_D = \mbox{number of data points in the intensity/concentration time
    curve}.}{nD = number of data points in the intensity/concentration time
curve.}

\emph{If observed data is unweighted, i.e., \eqn{\mbox{SD}_i=1}{SDi=1},
  \eqn{\mbox{OF}_{M}}{OF_M} is equal to the mean
  residual sum of squares, \eqn{\mbox{OF}_R}{OF_R}, or}

\deqn{\mbox{OF}_R = \frac{\sum_{i=1}^{n_D}
  (y_i-s(\hat{p},t_i))^2}{n_D} = \frac{R\!S\!S}{n_D} =
  \overline{R\!S\!S}.}{OF_R = (sum(i=1 to
nD)[(y_i-s(p_hat,ti))^2])/ND = RSS/ND = RSSbar.}

\emph{The objective function implemented in \code{KAT} is written as}

\deqn{\mbox{OF}_{K\!AT} = R\!S\!S = \sum_{i=1}^{n_D}
  (y_i-s(\hat{p},t_i))^2.}{OF_KAT=RSS=sum(i=1 to
nD)[(y_i-s(p_hat,ti))^2].}

\bold{Model discrimination [ref. 4]}

\emph{Fits of the Tofts and Extended Tofts model to the
  intensity/concentration time curve are compared via the Akaike
  Information Criterion \eqn{\mbox{(AIC)}}{(AIC)}, written generally as}

\deqn{\mbox{AIC}=-2 \cdot \mbox{log-likelihood}+n_P.}{AIC = -2*log-likelihood + 2*nP.}

\emph{When applying least squares regression, i.e.,
  \eqn{OF_{K\!AT}}{OF_KAT}, to observed data with Gaussian variability,
  the \eqn{\mbox{AIC}}{AIC} is written as}

\deqn{\mbox{AIC}=n_D \cdot log\left( \mbox{OF}_{R} \right) + 2(n_P+1).}{AIC=nD*log(OF_R) + 2*(nP+1).}

\emph{A correction term for small sample
  sizes \eqn{(n_D/n_P < 40)}{(nD/nP <~ 40)} can be derived, yielding}

\deqn{\mbox{AIC}_c=n_D \cdot log\left( \mbox{OF}_{R} \right) +
  2(n_P+1) + \frac{2(n_P+1)(n_P+2)}{n_D-n_P-2},}{AICc=nD*log(OF_R) +
  2*(nP+1) + (2(nP+1)(nP+2))/(nD-nP-2),}

\emph{where}

\deqn{n_P=\mbox{number of estimated model parameters}.}{nP=number of estimated model parameters.}

\bold{Coefficients of Variation (CVs) for estimated parameters [refs. 5-6]}

\emph{The Hessian matrix \eqn{\mathbf{H}(\hat{p})}{(H(p_hat))} is
  calculated numerically by \code{R} during the
  parameter estimation process, so that the covariance matrix
  (\eqn{cov}{cov}) and \%CVs for model parameters estimated
  using the \eqn{\mbox{OF}_{K\!AT}}{OF_KAT}, i.e., \eqn{R\!S\!S}{RSS}, objective function may be \strong{approximated} as}

\deqn{cov(\hat{p})=\frac{n_D \cdot \mbox{OF}_{K\!AT}}{n_D-n_P}\mathbf{H}^{-1}(\hat{p})}{cov(p_hat)=(nD*OF_KAT)/(nD-nP)*H^-1(p_hat)}

\emph{and}

\deqn{\mbox{\%CV}(\hat{p})=\frac{\sqrt{\mbox{diag}[cov(\hat{p})]}}{\hat{p}} \times
  100\%,}{\%CV(p_hat)=sqrt(diag[cov(p_hat)])/(p_hat) * 100\%,}

\emph{where \eqn{\mbox{diag}[cov(\hat{p})]}{diag[cov(p_hat)]} is a vector composed of the diagonal
  elements of \eqn{cov}{cov} and
  \eqn{\hat{p}}{p_hat} is the vector of
  final parameter estimates. Note that this method for calculating \%CVs assumes that variability in measured data points follows a Gaussian
  distribution. Thus, large outlier data points in the
  concentration/intensity curve, for example those caused by patient
  motion, may inflate estimated \%CVs.}

\bold{Contents of output file}

\code{args}: List of all arguments specified when running the
\code{KAT} function plus a few additional values generated during the run.

\code{cc}: \code{nx x ny x nt} array of voxel-wise contrast agent
concentration/intensity-time curves for all voxels within the Field of View.

\code{ccroi}: \code{nx x ny x nt} array of voxel-wise contrast agent
concentration/intensity-time curves for all voxels within the Region of
Interest.

\code{ccmedian}: Median contrast agent-time profile within the Region
of Interest.

\code{maptimes}: \code{nt x 1} time vector.

\code{aif}: \code{nt x 1} Vascular Input Function.

\code{aifshifted}: \code{nt x 1} Time shifted (by \eqn{t_{lag}}{tlag})
Vascular Input Function.

\code{maskroi}: \code{nx x ny} array indicating the region
of interest.

\code{mapKtransxT}: \code{nx x ny} array of \code{Ktrans} values estimated
using the extended Tofts model.

\code{mapKtransxTcv}: \code{nx x ny} array of \%CVs associated with
\code{Ktrans} values in \code{mapKtransxT}.

\code{mapkepxT}: \code{nx x ny} array of \code{kep} values estimated
using the extended Tofts model.

\code{mapkepxTcv}: \code{nx x ny} array of \%CVs associated with
\code{kep} values in \code{mapkepxT}.

\code{mapvbxT}: \code{nx x ny} array of \code{vb} values estimated
using the extended Tofts model.

\code{mapvbxTcv}: \code{nx x ny} array of \%CVs associated with
\code{vb} values in \code{mapvbxT}.

\code{mapvexT}: \code{nx x ny} array of \code{ve} values estimated
using the extended Tofts model. Note that \eqn{v_e}{ve} is not
directly fitted to the concentration/intensity data but is calculated as
\eqn{v_e=K^{trans}/k_{ep}}{ve=Ktrans/kep}

\code{mapOptimValuexT}: \code{nx x ny} array of objective function values
for voxels where the extended Tofts model has successfully converged (convergence/exit code=0; see
?optim).

\code{mapfitfailuresxT}: Map indicating per voxel optimization exit
codes for the extended Tofts model. 0: indicates successful
completion. 1: indicates that the iteration limit maxit had been
reached. 10: indicates degeneracy of the Nelder-Mead simplex. 51:
indicates a warning from the L-BFGS-B method; see component message for
further details. 52: indicates an error from the L-BFGS-B method; see
component message for further details. 99: indicates a try error
(optimization routine crashed). -2: indicates that voxel failed \code{fracGTzero}
test. Voxels with exit codes > 0 will appear
white when using the interactive AVDT and are excluded from subsequent
analysis.

\code{paramestmedianxT}: List of median values of all extended Tofts
model parameters fitted on a voxel-wise basis to contrast agent curves
within the ROI; includes the percent of total fitted voxels that are
classified as fit failures.

\code{roimedianfittedxTofts}: Simulated contrast agent-time profile
generated by fitting the extended Tofts model to median contrast agent
values within the Region of Interest.

\code{paramestwholeroixTofts}: Model parameters estimated by fitting the
extended Tofts model to median concentration/intensity data across the
Region of Interest. These parameters are used to generate
\code{roimedianfittedxTofts}.

\code{cvwholeroixTofts}: \%CVs for extended Tofts model parameters
listed in \code{paramestwholeroixTofts}.

\code{mapKtransT}: \code{nx x ny} array of \code{Ktrans} values estimated
using the Tofts model.

\code{mapKtransTcv}: \code{nx x ny} array of \%CVs associated with
\code{Ktrans} values in \code{mapKtransT}.

\code{mapkepT}: \code{nx x ny} array of \code{kep} values estimated
using the Tofts model.

\code{mapkepTcv}: \code{nx x ny} array of \%CVs associated with
\code{kep} values in \code{mapkepT}.

\code{mapveT}: \code{nx x ny} array of \code{ve} values estimated
using the Tofts model. Note that \eqn{v_e}{ve} is not
directly fitted to the concentration/intensity data but is calculated as
\eqn{v_e=K^{trans}/k_{ep}}{ve=Ktrans/kep}.

\code{mapOptimValueT}:  \code{nx x ny} array of objective function values
for voxels where the Tofts model has successfully converged (convergence/exit code=0; see
?optim).

\code{mapfitfailuresT}: Map indicating per voxel optimization exit
codes for the Tofts model. 0: indicates successful completion. 1:
indicates that the iteration limit maxit had been reached. 10: indicates
degeneracy of the Nelder-Mead simplex. 51: indicates a warning from the
L-BFGS-B method; see component message for further details. 52:
indicates an error from the L-BFGS-B method; see component message for
further details. 99: indicates a try error (optimization routine
crashed). -2: indicates that voxel failed \code{fracGTzero}
test. Voxels with exit codes > 0 will appear
white when using the interactive AVDT and are excluded from subsequent
analysis.

\code{paramestmedianT}: List of median values of all Tofts
model parameters fitted on a voxel-wise basis to contrast agent curves
within the ROI; includes the percent of total fitted voxels that are
classified as fit failures.

\code{roimedianfittedTofts}: Simulated contrast agent-time profile
generated by fitting the Tofts model to median contrast agent
values within the Region of Interest.

\code{paramestwholeroiTofts}: Model parameters estimated by fitting the
Tofts model to median concentration/intensity data across the
Region of Interest. These parameters are used to generate
\code{roimedianfittedTofts}.

\code{proctimetotal}: Total processing time in minutes.

\code{roiplotparams}: Cropping coordinates applied to the FOV and upper
limit of color bar for
visualization of parametric maps via the advanced voxel diagnostic tool
(AVDT).

\code{KATversion}: Version of KATforDCEMRI used to generate this output
file.

\code{mapAICxT}: \code{nx x ny} array of \eqn{\mbox{AIC}_c}{AICc} values
for per-voxel fits of the extended Tofts model to
concentration/intensity data.

\code{mapAICT}: \code{nx x ny} array of \eqn{\mbox{AIC}_c}{AICc} values
for per-voxel fits of the Tofts model to
concentration/intensity data.

\code{mapAICcompare}: \code{nx x ny} \code{nx x ny} array that contains
a ``1'' for voxels with a lower (lower=better model) AIC for the
extended Tofts model or a ``2'' for voxels with a lower AIC for the
Tofts model.

\code{nx}: \code{x} dimension of the FOV.

\code{ny}: \code{y} dimension of the FOV.

\code{nt}: number of elements in the time vector (number of time
points).

\code{ccFittedxT}: \code{nx x ny x nt} array of extended Tofts model simulations
fitted to voxel-wise contrast agent concentration-time data within the ROI.

\code{ccFittedT}: \code{nx x ny x nt} array of Tofts model simulations
fitted to voxel-wise contrast agent concentration-time data within the
ROI.

\code{p0T}: Initial parameter values for the Tofts model where \eqn{K^{trans}(0)}{Ktrans(0)} and
\eqn{k_{ep}(0)}{kep(0)} are estimated using the numerical deconvolution method
described in the \code{DATforDCEMRI} package refs \bold{[refs 7-8]}.

\code{p0xT}: Initial values for the extended Tofts model where \eqn{K^{trans}(0)}{Ktrans(0)} and
\eqn{k_{ep}(0)}{kep(0)} are the same as those used for \code{p0T}. Initial values for \eqn{v_b}{vb} and
\eqn{t_{lag}}{tlag} are set to nominal values (0.05 and 7.2 seconds),
when fitting the
model to median data. Initial values for \eqn{v_b}{vb} and
\eqn{t_{lag}}{tlag}, when fitting the xTofts model to
per-voxel data, are set to those values estimated based on fits to the median
data.

\code{IRFresults}: Contains results of noncompartmental analysis of the
estimated Impulse Response Function (IRF), where \code{AUC} is the area
under the curve (AUC) of the IRF and is analogous to the Tofts parameter
\eqn{v_e}{ve}, \code{AUCMRT} is the AUC of the IRF divided by the Mean
Residence Time (MRT) of the IRF and is analogous to the Tofts parameter
\eqn{K^{trans}}{Ktrans} and \code{AUCMRT.divby.AUC} is AUCMRT divided by
AUC (equal to 1/MRT) and is analogous to the Tofts parameter
\eqn{k_{ep}}{kep}. Each of these parameters is either corrected for
truncation error and contribution of \eqn{v_b}{v_b} using
nominal values (\code{corrnom}), as described in the entry for
\code{p0xT}, or the actual values estimated based on fitting the
extended Tofts model to median intensity/concentration data
(\code{corr}). The method for truncation correction is described in
\bold{[ref 7]}.

\code{mapEF}: Map indicating enhancing voxel within the specified region
of interest, where a ``1'' indicates enhancement.
}



\references{
  \emph{Model equations}

[1] Tofts P, Kermode A (1991). Measurement of the blood-brain barrier
permeability and leakage space using dynamic MR imaging. 1. Fundamental
concepts. Magn Reson Med, 17(2), 357-67. \url{http://www.ncbi.nlm.nih.gov/pubmed/2062210}

[2] Ferl GZ, Port RE (2012). Quantification of Antiangiogenic and
Antivascular Drug Activity by Kinetic Analysis
of DCE-MRI Data. Clin Pharmacol Ther, 92(1), 118-124. \url{http://www.ncbi.nlm.nih.gov/pubmed/22588603}

\emph{Objective Function}

[3] Barrett PHR, Bell BM, Cobelli C, Golde H, Schumitzky A,
Vicini P, and Foster DM (1998). SAAM II: Simulation, Analysis, and Modeling Software for Tracer
and Pharmacokinetic Studies. Metabolism, 47(4), 484-492. \url{http://www.ncbi.nlm.nih.gov/pubmed/9550550}

\emph{Model discrimination}

[4] Glatting G, Kletting P, Reske SN (2007). Choosing the optimal fit function: Comparison of the Akaike information
criterion and the F-test. Med Phys, 34(11), 4285-4292. \url{http://www.ncbi.nlm.nih.gov/pubmed/18072493}

\emph{Coefficients of Variation (CVs) for estimated parameters}

[5] Venables WN, Smith DM, R Core Team (2012). An Introduction to R [Notes
on R: A Programming Environment for Data Analysis and Graphics Version
2.15.2 (2012-10-26)]. Section 11.7: Nonlinear least squares and maximum likelihood
models. \url{http://cran.r-project.org/doc/manuals/R-intro.pdf}

[6] Unpublished notes by Elliot M. Landow, UCLA Department of
Biomathematics.

\emph{R package for numerical deconvolution}

[7] Ferl GZ, Xu L, Friesenhahn M, Bernstein LJ, Barboriak DP, Port RE
(2010). An automated method for nonparametric kinetic analysis of
clinical DCE-MRI data: application to glioblastoma treated with
bevacizumab. Magn Reson Med, 63(5), 1366-1375. \url{http://www.ncbi.nlm.nih.gov/pubmed/20432307}

[8] Ferl GZ (2011). DATforDCEMRI: An R Package for Deconvolution Analysis and Visualization
of DCE-MRI Data. J Stat Softw, 44(3),
1-18. \url{http://www.jstatsoft.org/v44/i03} and \url{http://cran.r-project.org/package=DATforDCEMRI}

}
\author{
Gregory Z. Ferl
}
\seealso{
\code{\link{KAT.checkData}}, \code{\link{KAT.plot}}, \code{\link{dcemri.data}}
}
\examples{
## RUN THE BENCHMARK TEST
   demo(KAT, ask=FALSE)
##
## ANALYZE DATA FROM A SINGLE DCE-MRI SCAN
##
## Load MATLAB files into R
## R> aif <- readMat("mydatafile-AIF.mat")$aif
## R> ct <- readMat("mydatafile-CT.mat")$ct
## R> roi <- readMat("mydatafile-ROILES.mat")$roi
## R> tvec <- readMat("mydatafile-TVEC.mat")$tvec
##
## Check that the dimensionality of the loaded data is consistent and save
## as a single R object or RData file
## R> dcemri.data <- KAT.checkData(file.name="mydatafile", vector.times=tvec,
##    map.CC=ct, mask.ROI=roi, vector.AIF=aif)
##
## Fit the Tofts and extended Tofts model to all ROIs in RData file
## R> KAT(file="mydatafile.RData", results_file= "mydatafile_out",
## show.rt.fits=TRUE, AIFshift="VEIN")
##
## Plot all ROIs in a single figure
## R> KAT.plot(F1="mydatafile_out_slice3.RData",
##    F2="mydatafile_out_slice4.RData", F3="mydatafile_out_slice5.RData",
##    F4="mydatafile_out_slice6.RData")
##
## Visualize and explore a parametric map for a single ROI
## R> KAT(file="mydatafile_out_slice6.RData")
}

\keyword{ kinetic }
\keyword{ DCEMRI }