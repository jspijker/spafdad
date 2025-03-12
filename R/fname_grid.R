#' Get the path to the grid file
#'
#' This function returns the path to the grid file for a given
#' resolution. The grid file is a raster file that contains the
#' cell numbers for each pixel in the grid. These cell numbers are
#' used to link the data to the grid.
#'
#' @param resolution The resolution of the grid
#' @return The path to the grid file
#' @export

fname_grid <- function(resolution) {
    if(!(resolution %in% resolutions)) {
        stop("resolution must be one of: ", paste(resolutions, collapse = ", "))
    }
    gridname <- paste0("pixid", resolution, ".tif")
    fname_grid <- system.file("extdata", gridname, package = "spafdad")
    return(fname_grid)

}

