# AI Assistance Declaration: I used ChatGPT (GPT-6, October 30, 2026)
# for test-plan suggestions. See Aki_AI_Prompts_Appendix.md. I must verify
# outcomes in RStudio and independently spot-check the results myself.

source("Aki_AI_RFunction_Assignment.R")

cat("TEST 1: Basic synthetic case\n")
x <- c(10, 15, 999, 20, 25)
r <- remove_outliers(x)
print(r)
# Manual expectation for default R quantiles: Q1 = 15, Q3 = 25,
# IQR = 10; fences = 0 and 40; remove 999 at position 3.
stopifnot(identical(r$cleaned, c(10, 15, 20, 25)))
stopifnot(identical(r$outliers, 999))
stopifnot(identical(r$outlier_positions, 3L))
stopifnot(isTRUE(all.equal(c(r$lower_bound, r$upper_bound), c(0, 40))))
# Independent base-R cross-check: use an explicitly matched quantile rule.
q <- quantile(x, c(.25, .75), names = FALSE)
expected <- x[x >= q[1] - 1.5 * IQR(x) & x <= q[2] + 1.5 * IQR(x)]
stopifnot(identical(r$cleaned, expected))
cat("PASS: basic example and independent IQR cross-check\n\n")

cat("TEST 2: NA handling and original indexes\n")
r2 <- remove_outliers(c(10, NA, 15, 999, 20, 25))
stopifnot(identical(r2$missing_positions, 2L))
stopifnot(identical(r2$outlier_positions, 4L))
stopifnot(identical(r2$cleaned, c(10, 15, 20, 25)))
cat("PASS: missing-value handling\n\n")

cat("TEST 3: Empty, all-NA, constant, and repeated values\n")
stopifnot(length(remove_outliers(numeric(0))$cleaned) == 0)
stopifnot(length(remove_outliers(c(NA_real_, NA_real_))$cleaned) == 0)
stopifnot(identical(remove_outliers(rep(7, 5))$cleaned, rep(7, 5)))
stopifnot(identical(remove_outliers(c(1, 1, 1, 1, 100))$outliers, 100))
cat("PASS: edge cases\n\n")

cat("TEST 4: Bad arguments raise expected errors\n")
should_fail <- function(expr) inherits(tryCatch(force(expr), error = identity), "error")
stopifnot(should_fail(remove_outliers("text")))
stopifnot(should_fail(remove_outliers(matrix(1:4, 2))))
stopifnot(should_fail(remove_outliers(c(1, Inf, 2))))
stopifnot(should_fail(remove_outliers(c(1, NA), na_rm = FALSE)))
stopifnot(should_fail(remove_outliers(1:5, multiplier = -1)))
cat("PASS: argument validation\n\n")

cat("ALL TESTS PASSED (only if this line prints in RStudio).\n")
