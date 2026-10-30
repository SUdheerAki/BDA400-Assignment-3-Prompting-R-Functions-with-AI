# AI Assistance Declaration
I used ChatGPT (GPT-6, October 30, 2026) to develop the function outline, argument-validation suggestions, test-plan ideas, documentation, and reflection draft. Prompts and key responses are below. I must validate the R output in RStudio, independently compare the results using base R, and personally spot-check the edge cases. All final calculations are my responsibility. I am responsible for the accuracy and originality of this work.

# Assignment 3: AI Prompt Record

**Task description:** Remove unusually high or low numbers from a numeric vector using the 1.5 × interquartile-range rule and return cleaned numbers plus removed-value positions.

1. **Seed prompt:** "Write an R function that removes outliers from a numeric vector using the 1.5 IQR rule."  
   **Key response:** Use `quantile()`, calculate quartile fences, and subset observations. **Initial limitation:** the bare implementation fails if NA values are present and gives only cleaned numbers.
2. **Revision prompt:** "Revise the function to include comments, argument validation, and return a clean result."  
   **Key response:** Add numerical input checks, a nonnegative `multiplier`, explicit missing-data handling, and a named list of outputs.
3. **Explanation prompt:** "Explain what each line of the R code does and how you might test if it works correctly."  
   **Key response:** Document the quartiles, IQR, lower and upper fences, logical index, and return values. Test a synthetic vector with an obvious extreme and confirm expected output by hand.
4. **Debugging prompt:** "Update the function to handle NA values safely and preserve the original positions of removed observations."  
   **Key response:** Track nonmissing positions before computing quartiles, return missing positions separately, and keep indexes of flagged outliers.
5. **Optimization prompt:** "Optimize the function for efficiency and readability, and suggest edge cases to test."  
   **Key response:** Compute quartiles once, use vectorized comparisons, and test empty vectors, all-NA, repeated values, bad inputs, and zero IQR.
6. **Reflection prompt:** "Summarize how this R function changed across revisions. Highlight human-driven versus AI-suggested improvements."  
   **Key response:** Explain how the initial minimal function was extended with missing-data handling, clearer return structure and explicit tests, and stress that RStudio execution and manual comparison—not AI—determine correctness.

## Manual modifications and testing
The initial function is retained in `Aki_AI_RFunction_Assignment.R` for comparison. The revised implementation separates NA values from outliers, validates parameters, preserves original indexes, and handles zero-length input. `Aki_Test_RFunction.R` contains assertions for synthetic examples and an independent base-R check. **Tests are supplied but have not been executed in the user's RStudio session by the assistant.** Capture the actual Console output after running the test script.
