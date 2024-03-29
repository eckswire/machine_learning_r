require(R6)
require(hash)
require(mvtnorm)

NaiveBayesClassifier <- R6Class('NaiveBayesClassifier',
  list(
    means = hash(),
    sigmas = hash(),
    priors = hash(),
    K = NULL,
    P = NULL,
    fit = function(X, y){
      self$K <- unique(y)

    
      for (k in self$K) {
        X_k <-matrix(X[y==k], ncol = ncol(X))
        self$means[[toString(k)]] <- colMeans(X_k)
        self$sigmas[[toString(k)]] <- cov(X_k)
        self$priors[[toString(k)]] <- length(X_k)/length(X)
    }
    
    },
    ## Predict definition 
    predict = function(X){
      self$P <- matrix(0, ncol = ncol(X), nrow = nrow(X))
    
       for (k in self$K) {
          self$P[,k+1] <- dmvnorm(X, self$means[[toString(k)]], self$sigmas[[toString(k)]], log = TRUE) + log(self$priors[[toString(k)]])
       }
      return(apply(self$P, 1, which.max) - 1)
        
    }
  )
)


