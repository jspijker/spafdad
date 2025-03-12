#' Summarize a variable in each cell
#'
#' This function summarizes a variable in for cell. 
#'
#' @param d A data frame with columns x, y, cell, and the variable to
#' summarize
#' @param variable The variable to summarize
#' @return A data frame with the summary statistics]
#'
#' @description
#' This function summarizes a variable in each cell. The function
#' expects a data frame with columns x, y, cell, and the variable to
#' summarize. The function returns a data frame with the number of
#' observations, the 10th, 25th, 50th, 75th and 90th percentile, the
#' mean, the standard deviation and the median absolute deviation.


#' @export


summary_cell <- function(d, variable) {
    if(!all(c("x", "y",  variable) %in% colnames(d))) {
        stop("d must contain columns x, y  and lutum")
    }

    names(d)[which(names(d) == variable)] <- "variable"
   # dcells <- grid_cell(d, resolution)
    res <- d |>
        dplyr::group_by(cell) |>
        dplyr::summarize(n = dplyr::n(),
                         p10 = quantile(variable, na.rm = TRUE, prob = 0.1),
                         p25 = quantile(variable, na.rm = TRUE, prob = 0.25),
                         p50 = quantile(variable, na.rm = TRUE, prob = 0.5),
                         p75 = quantile(variable, na.rm = TRUE, prob = 0.75),
                         p90 = quantile(variable, na.rm = TRUE, prob = 0.9),
                         mad = mad(variable, na.rm = TRUE),
                         mean = mean(variable, na.rm = TRUE),
                         sd = sd(variable, na.rm = TRUE))
    return(res)
}
