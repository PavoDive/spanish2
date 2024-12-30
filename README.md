
<!-- README.md is generated from README.Rmd. Please edit that file -->

# spanish2

<!-- badges: start -->

<!-- badges: end -->

The goal of spanish2 is to allow users to convert from numbers (or their
string representations) to their Spanish words equivalents. That is,
convert from `100` to “cien”, and from `-1325` to “menos mil trecientos
veinte y cinco”.

I developed it because I frequently needed to convert quantities
(usually money) to their text representations in Spanish. There’s
already [a package for that](https://github.com/rOpenSpain/spanish), but
its `to_words()` function has some limitations and produces some
unexpected results (the largest number it can handle is 999,999,999).
That package has some other interesting features, that `spanish2` lacks,
such as converting Spanish text to numbers, so I encourage the user to
check that package, too.

**`spanish2` uses long scale**, which is the most frequently used in the
Spanish language. That means that 1e9 is **not** “un billón”: it is “mil
millones”. “Un billón” will be 1e12\!

## Installation

You can install the development version of spanish2 like so:

``` r
devtools::install_github("pavodive/spanish2")
```

## Examples

The main (and only function) of `spanish2` is `to_words()`, used to
convert from numbers to Spanish words:

``` r
library(spanish2)

to_words(31262668)
#> [1] "treinta y un millones doscientos sesenta y dos mil seiscientos sesenta y ocho"
## [1] "treinta y un millones doscientos sesenta y dos mil seiscientos sesenta y ocho"
```

It an handle very big **integers**:

``` r
big_number = round(pi * 1e21, 0)
to_words(big_number)
#> [1] "tres mil ciento cuarenta y un trillón quinientos noventa y dos mil seiscientos cincuenta y tres billones quinientos ochenta y nueve mil setecientos noventa y tres millones doscientos diez mil trescientos sesenta y ocho"
## [1] "tres mil ciento cuarenta y un trillón quinientos noventa y dos mil seiscientos cincuenta y tres billones quinientos ochenta y nueve mil setecientos noventa y tres millones doscientos diez mil trescientos sesenta y ocho"
```

But numbers above 1e22 trigger a warning because of wrong arithmetic of
big numbers in R: converted text may contain errors:

``` r
bigger_number = round(pi * 1e22, 0)
to_words(bigger_number)
#> Warning in to_words(bigger_number): Number is big, precision errors may be present in the output.
#> See https://stackoverflow.com/questions/23600569/r-wrong-arithmetic-for-big-numbers
#> [1] "treinta y un mil cuatrocientos quince trillones novecientos veinte y seis mil quinientos treinta y cinco billones ochocientos noventa y siete mil novecientos treinta millones seis mil quinientos veinte y ocho"
## [1] "treinta y un mil cuatrocientos quince trillones novecientos veinte y seis mil quinientos treinta y cinco billones ochocientos noventa y siete mil novecientos treinta millones seis mil quinientos veinte y ocho"
## Warning message:
## In to_words(bigger_number) :
##   Number is big, precision errors may be present in the output.
## See https://stackoverflow.com/questions/23600569/r-wrong-arithmetic-for-big-numbers
```

Very large (up to 60 digits) can be provided to the function, as long as
they are provided as a string:

``` r
set.seed(1)
biggest_number = sample(0:9, 60, TRUE) |>
  paste(collapse = "")

biggest_number
#> [1] "836016120449596844884419803259953398658786759629571155022756"
## [1] "836016120449596844884419803259953398658786759629571155022756"

to_words(biggest_number)
#> [1] "ochocientos treinta y seis mil diez y seis nonillones ciento veinte mil cuatrocientos cuarenta y nueve octillones quinientos noventa y seis mil ochocientos cuarenta y cuatro septillones ochocientos ochenta y cuatro mil cuatrocientos diez y nueve sextillones ochocientos y tres mil doscientos cincuenta y nueve quintillones novecientos cincuenta y tres mil trescientos noventa y ocho cuatrillones seiscientos cincuenta y ocho mil setecientos ochenta y seis trillones setecientos cincuenta y nueve mil seiscientos veinte y nueve billones quinientos setenta y un mil ciento cincuenta y cinco millones veinte y dos mil setecientos cincuenta y seis"
## [1] "ochocientos treinta y seis mil diez y seis nonillones ciento veinte mil cuatrocientos cuarenta y nueve octillones quinientos noventa y seis mil ochocientos cuarenta y cuatro septillones ochocientos ochenta y cuatro mil cuatrocientos diez y nueve sextillones ochocientos y tres mil doscientos cincuenta y nueve quintillones novecientos cincuenta y tres mil trescientos noventa y ocho cuatrillones seiscientos cincuenta y ocho mil setecientos ochenta y seis trillones setecientos cincuenta y nueve mil seiscientos veinte y nueve billones quinientos setenta y un mil ciento cincuenta y cinco millones veinte y dos mil setecientos cincuenta y seis"
```

`spahish2::to_words()` can take a negative number, either as an integer
or as a string:

``` r
to_words(-1234)
#> [1] "menos mil doscientos treinta y cuatro"
## [1] "menos mil doscientos treinta y cuatro"

identical(to_words(-1234), to_words("-1234"))
#> [1] TRUE
## [1] TRUE
```

## Simplicity of the Code vs. Style in the Absence of a Standard

There is not (or at least I did not find) a standard transliteration of
numbers in Spanish. It seems to vary from region to region. While some
countries seem to prefer some forms, others prefer different ones (like
1100: “mil cien”, or “mil ciento”).

I took side with the simplicity of the code, which may have the
consequence of a style that may not be the one favored in your country /
region or that of your intended readers or users. The Spanish language
is complex and alive, so I hope the simplicity vs. style decision I made
does not cause you any significant problems.

What I mean by this “simplicity vs. Style” decision? See for yourself:

| Number |     Style 1     |       Other Styles        | spanish2’s output |
| :----: | :-------------: | :-----------------------: | ----------------- |
|   77   | Setenta y siete |                           | setenta y siete   |
|   16   |    Dieciséis    |        Diez y seis        | diez y seis       |
|   27   |   Veintisiete   |       Venta y siete       | veinte y siete    |
|  1100  |    Mil cien     | Mil ciento / mil y ciento | mil cien          |

In the same vein, if you read the code you will see that there is a long
function that “cleans the text” (makes some corrections like converting
the string “cincodiez” to “cincuenta”). **I am well aware that there is
some black magic regex that can reduce the function from its actual 83
lines to some 10 or 15**. But I preferred the readability over the size,
so please bear with me (specially if you plan your contribution around
this very issue).

## Errors, Bugs and Improvements

Even though I checked it carefully against a good array of numbers,
there may be some bugs or errors in the code. For sure there will be
ways to improve it or its documentation. Please rise an issue or write a
pull request, I’ll be happy to review it.
