
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SPAFDAD: Spatial Feature Data Aggregation and Disclosure

<!-- badges: start -->

<!-- badges: end -->

The spafdad package is used for aggregating spatial data based on given
spatial resolutions. The package contains raster data of the
Netherlands. For specific resolutions, these raster data contains cells
which can be used for the aggregation.

If the users provides a dataset, containing measurements and spatial
coordinates using the Dutch ‘Rijksdriehoekstelsel’ (RD), these
measurements can be aggregated for each cell in one of the raster data
grids with selected resolution.

By using the package a overview of the spatial variability a a certain
measurement can be obtained without the need to provide the exact
location.

For each cell distribution statistics can be calculated, such as the
mean, median, standard deviation, etc. Also the amount observations in
each cell can be calculated.

Based on the amount of observations in each cell, the user can decide
what the minimal amount of observations is needed, to not disclose any
individual information.

# Installation

The package can be installed from GitHub.com by using the following
command:

``` r
devtools::install_github("jspijker/spafdad")
```

# Usage

See the
[vignette](https://jspijker.github.io/spafdad/articles/spafdad.html) for
a detailed example.

# License

This package is free and open source software, licensed under GPL-3.
