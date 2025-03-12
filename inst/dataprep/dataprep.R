# Data preparation


######################################################################
# load libraries
######################################################################

library(tidyverse)
library(terra)
library(MDMA)
library(datafile)
library(pryr)

######################################################################
# functions
######################################################################


getmem <- function() {
    memused <- pryr::mem_used()
    cat("Memory used: ")
    print(memused/1)
    cat("\n")
}

create_idgrid <- function(xmin=0,xmax=280000,
                          ymin=300000,ymax=625000,
                          resolution=25) {
    # Creeert de 'pixel id' laag. Deze laag wordt gebruikt als basis
    # voor de datacube. Iederre pixel heeft een uniek nummer wat
    # gebruikt kan worden als koppeling met andere pixels uit andere
    # kaartlagen.
    # Deze kaart wordt ook gebruikt als referentieraster om de andere
    # kaarten te verasteren.
    # @param xmin minimale x coordinaat bounding box
    # @param xmax maximale x coordinaat bounding box
    # @param ymin minimale y coordinaat bounding box
    # @param ymin maximale y coordinaat bounding box
    # @param resolution resolutie van de kaart (pixelgrootte)

    xcells=(xmax-xmin)/resolution
    ycells=(ymax-ymin)/resolution
    ncells  <- xcells * ycells
    x <- rast(ncol = ycells, nrow = xcells,
              xmin = xmin,
              xmax = xmax,
              ymin = ymin,
              ymax = ymax,
              resolution = resolution,
              names = paste0("pixid", resolution),
              vals = seq_len(ncells),
              crs = "+init=epsg:28992"
    )
    return(x)
}

quantile_layer <- function(sellayer, x) {
    rq <- unlist(c(0, global(x[[sellayer]], quantile, 
             probs = seq(0.1, 0.9, 0.1), na.rm=TRUE)))
    v3 <- classify(x[[sellayer]], rq, include.lowest = TRUE)
    return(v3)
}


######################################################################
# start
######################################################################

cfg <- list()
datafileInit(here("inst", "dataprep"))
init_session(script = here("inst", "dataprep", "dataprep.R"))


cfg <- list()
cfg$irods_project <- "/rivmZone/projects/no3proxies"
cfg$irods_datacube <- "datacube"
cfg$irods_data <- "data"
ri_setCollection(file.path(cfg$irods_project, cfg$irods_data))
ri_setDatadir(datafile(""))


# create grids
resolutions <- c(250, 500, 750, 1000, 2000, 4000, 5000, 7500, 10000)
idgrids <- map(resolutions, function(i) {x <- create_idgrid(resolution = i);
               writeRaster(x, datafile(paste0(names(x), ".tif")),
                           overwrite = TRUE);
               x})


get_obj("cube_lutum.tif",
        collection = file.path(cfg$irods_project, cfg$irods_datacube))

lutum <- rast(datafile("cube_lutum.tif"))

# create sample data set

maxcell <- ncell(lutum)

set.seed(123)

s_lutum <- tibble()

while(nrow(s_lutum) < 100000) {
    s <- sample(1:maxcell, 1000)
    lutum_val <- extract(lutum, s)
    s_lutum <- s_lutum |>
        bind_rows(tibble(cell = s, lutum = lutum_val$lutum)) |>
        na.omit()
}

s_lutum <- s_lutum |>
    rowwise() |>
    mutate(lutum_var = lutum + rnorm(n = 1, sd = 1)) |>
    mutate(lutum_var = round(lutum_var, 2)) |>
    filter(lutum_var > 0)
xy <- xyFromCell(lutum, s_lutum$cell) |>
    as_tibble()

s_lutum <- s_lutum |>
    bind_cols(xy)

dclutum <- s_lutum |>
    select(x, y, lutum)
rm(s_lutum); gc()
saveRDS(dclutum, datafile("dclutum.rds"))

# get all the file names from the ./data/ directory
files <- list.files(datafile(""), pattern = "pixid.*\\.tif", full.names = TRUE)
if(!file.exists(here("inst", "extdata"))) {
    dir.create(here("inst", "extdata"))
}

# copy the files to the extdata directory
file.copy(files, here("inst", "extdata"), overwrite = TRUE)

usethis::use_data(dclutum, overwrite = TRUE)
usethis::use_data(dclutum, overwrite = TRUE, internal = TRUE)
usethis::use_data(resolutions, overwrite = TRUE, internal = TRUE)








