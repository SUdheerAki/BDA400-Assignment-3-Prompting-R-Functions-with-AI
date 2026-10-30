# AI Assistance Declaration: I used ChatGPT (GPT-6, October 30, 2026) to
# propose a function outline, comments, argument checks, and test cases.
# Prompts: see Aki_AI_Prompts_Appendix.md. Outputs must be verified by running
# the test script in RStudio, independent comparison, and personal spot-check.
# All final calculations are my responsibility; I am responsible for accuracy
# and originality of this work.

# BDA400 Assignment 3: Prompting R Functions with AI
# Original task: Remove unusually high or low observations from a numeric
# vector using the 1.5 * IQR rule and return both cleaned values and positions.

# VERSION 1 - INITIAL AI-SUGGESTED DRAFT (for review; known limitations)
remove_outliers_v1 <- function(x) {           # Define a simple cleaning function.
  q <- quantile(x, c(.25, .75))            # Find the quartiles; fails on NA.
  iqr <- q[2] - q[1]                     # Compute interquartile range.
  keep <- x >= q[1] - 1.5 * iqr &          # Test observations against lower bound.
    x <= q[2] + 1.5 * iqr                 # And test against upper bound.
  x[keep]                                 # Return remaining values only.
}

# VERSION 2 - REVISED FUNCTION (preferred final version)
remove_outliers <- function(x, multiplier = 1.5, na_rm = TRUE) {
  # Ensure the input is a numeric vector, not a matrix/data frame/list.
  if (!is.numeric(x) || !is.null(dim(x)) || is.complex(x)) {
    stop("x must be a one-dimensional numeric vector")
  }
  # Confirm multiplier is one finite, nonnegative numeric value.
  if (!is.numeric(multiplier) || length(multiplier) != 1L ||
      is.na(multiplier) || !is.finite(multiplier) || multiplier < 0) {
    stop("multiplier must be a single finite nonnegative number")
  }
  # Require a single TRUE or FALSE for missing-value handling.
  if (!is.logical(na_rm) || length(na_rm) != 1L || is.na(na_rm)) {
    stop("na_rm must be TRUE or FALSE")
  }
  # Reject infinite values rather than silently use them in quantiles.
  if (any(is.infinite(x))) stop("x may not include Inf or -Inf")
  # Reject missing values if caller chooses not to remove them.
  if (!na_rm && anyNA(x)) stop("x contains missing values; use na_rm = TRUE")
  # Identify missing values and preserve original (one-based) positions.
  missing_positions <- which(is.na(x))
  valid_positions <- which(!is.na(x))
  values <- x[valid_positions]
  # Handle an empty or all-missing vector without computing quantiles.
  if (length(values) == 0L) {
    return(list(cleaned = numeric(0), kept_positions = integer(0),
                outliers = numeric(0), outlier_positions = integer(0),
                missing_positions = missing_positions,
                lower_bound = NA_real_, upper_bound = NA_real_))
  }
  # Compute base-R type-7 quartiles on observed values, as in boxplot.stats.
  q <- as.numeric(quantile(values, c(0.25, 0.75), names = FALSE))
  spread <- q[2] - q[1]
  lower <- q[1] - multiplier * spread
  upper <- q[2] + multiplier * spread
  # Retain values within inclusive bounds, in their original order.
  is_kept <- values >= lower & values <= upper
  # Return the cleaned values, removed values, their indexes, and limits.
  list(cleaned = unname(values[is_kept]),
       kept_positions = valid_positions[is_kept],
       outliers = unname(values[!is_kept]),
       outlier_positions = valid_positions[!is_kept],
       missing_positions = missing_positions,
       lower_bound = unname(lower), upper_bound = unname(upper))
}

# The final function is deliberately limited to 1-D numerical inputs.
# IQR filtering is exploratory; removing a valid extreme observation can
# distort a real analysis. Use only synthetic examples for this assignment.
