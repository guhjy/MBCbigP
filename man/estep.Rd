% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estep.R
\name{estep}
\alias{estep}
\alias{estep_cond}
\alias{estep_cond2}
\title{Expectation step for Expectation-Maximisation algorithm}
\usage{
estep(x, pro, mean, sigma, groups)

estep_cond(x_A, x_B, pro, mean_A, mean_B, sigma_AA, sigma_AB, sigma_BB, groups)

estep_cond2(x_A, x_B, pro, mean_A, mean_B, sigma_AA, sigma_AB, sigma_BB, groups,
  oldz = NULL)
}
\arguments{
\item{x, x_A, x_B}{A matrix of data.}

\item{pro}{A vector of mixing proportions.}

\item{mean, mean_A, mean_B}{A 2-D array of mean vectors.}

\item{sigma, sigma_AA, sigma_AB, sigma_BB}{A 3-D array of covariance matrices.}

\item{groups}{The integer number of groups.}

\item{oldz}{Previous matrix of cluster probabilities.}
}
\value{
A matrix of probabilities of belonging to a cluster.
}
\description{
Expectation step for Expectation-Maximisation algorithm
}

