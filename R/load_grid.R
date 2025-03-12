#' Load a grid from a file
#'
#' This function loads a grid from a file. The grid is a raster file
#' that contains the cell numbers for each pixel in the grid. These
#' cell numbers are used to link the data to the grid.
#'
#' @param resolution The resolution of the grid
#'
#' This package contains grid files for a set of resolutions. This
#' function loads the grid for a given resolution. This is loaded as a
#' Terra raster file. 
#'
#' @return The loaded grid
#' @export



load_grid <- function(resolution) {
    fname <- fname_grid(resolution)
    if(!file.exists(fname)) {
        stop("file ", fname, " does not exist")
    }
    grid <- terra::rast(fname)
    return(grid)
}

