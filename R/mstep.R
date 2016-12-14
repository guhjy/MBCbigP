#' @title Maximisation step for Expectation-Maximisation algorithm
#'
#' @description Maximisation step for Expectation-Maximisation algorithm
#'
#' @param x A matrix of data.
#' @param z A matrix of cluster memberships/probabilities.
#' @param groups Optional, number of groups in the mixture, inferred from
#'   \code{z} if not supplied.
#' @param p Optional, dimension of \code{x}, inferred from \code{x} if not
#'   supplied
#'
#' @return A list of parameter estimates for the mixing proportions, mean
#'   vectors, and covariance matrices.


mstep <-
function (x, z, groups = NULL, p = NULL)
{
  x <- data.matrix(x)
  groups <- if (is.null(groups))
    ncol(z)
  else groups
  p <- if (is.null(p))
    ncol(x)
  else p
  mixing <- colMeans(z)
  mu <- matrix(nrow = p, ncol = groups)
  sigma <- array(dim = c(p, p, groups))
  for (k in 1:groups){
    mu[, k] <- apply(x, 2, weighted.mean, w = z[, k])
    sigma[, , k] <- cov.wt(x, wt = z[, k], method = "ML")$cov
  }
  rownames(mu) <- colnames(x)
  colnames(mu) <- 1:groups
  list(mixing = mixing, mean = mu, sigma = sigma, groups = groups)
}

mstep_cond <-
function (x1, x2, z, precision2, mu2, sigma2, groups = NULL, p = NULL)
{
  x1 <- data.matrix(x1)
  x2 <- data.matrix(x2)
  groups <- if (is.null(groups))
    ncol(z)
  else groups
  p <- if (is.null(p))
    ncol(x1)
  else p
  if (missing(precision2)){
    precision2 <- array(dim = dim(sigma2))
    for (k in 1:groups){
      precision2[, , k] <- solve(sigma2[, , k])
    }
  }
  mu2 <- if (missing(mu2))
    colMeans.weighted(x2, w = z[, k])
  else mu2
  mu1 <- matrix(nrow = p, ncol = groups)
  sigma1 <- array(dim = c(ncol(x1), ncol(x1), groups))
  cov12 <- array(dim = c(ncol(x1), ncol(x2), groups))
  for (k in 1:groups){
    cov12[, , k] <- var.wt(x1, x2, w = z[, k])
    mu1[k, ] <- colMeans.weighted(x1, w = z[, k]) - cov12[, , k] %*% precision2[
      , , k] %*% colMeans.weighted(sweep(x2, 2, mu2[k, ]), w = z[, k])
    sigma1[, , k] <- var.wt(x1, x1, w = z[, k])
  }
  rownames(mu1) <- colnames(x1)
  colnames(mu1) <- 1:groups
  structure(list(pro = colMeans(z), mean = mu1, sigma = sigma1, cov = cov12,
    precision2 = precision2, groups = groups), class = "mbcparameters")
}