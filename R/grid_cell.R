#' Bind data to grid cells
#'
#' This function binds the x and y coordinates of a dataset to the
#' grid cell in a map with a specific resolution. The grid cell is
#' determined by the cell number in the grid file.
#'
#' @param d The dataset with x and y coordinates
#' @param resolution The resolution of the grid
#'
#' @description
#'
#' This function needs a dataset with x and y coordinates. It expects
#' a tibble with columns named 'x' and 'y'. The function will add a
#' column 'cell' to the dataset with the grid cell number. The grid
#' cell number is determined by the cell number in the grid file for
#' the given resolution.
#'
#' @return The dataset with an additional column with the grid cell
#' number
#'
#' @examples
#'
#' d <- dc_lutum
#' grid_cell(d, 250)


#' @export

grid_cell <- function(d, resolution) {
    if(!all(c("x", "y") %in% colnames(d))) {
        stop("xy must contain columns x and y")
    }
    xy <- d |>
        dplyr::select(x, y) |>
        as.matrix()
    grid <- load_grid(resolution)
    cell <- terra::cellFromXY(grid, xy)
    res <- d |>
        dplyr::bind_cols(cell = cell)
    return(res)
}

