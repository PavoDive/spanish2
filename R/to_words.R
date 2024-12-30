#' From integers to spanish spelled quantities.
#'
#' Takes any number up to 1e22 or string of numbers
#' up to 60 digits and returns spanish characters.
#' The general strategy is to follow the "natural way"
#' of reading numbers in Spanish: divide them in
#' groups of 3 from right to left, read them in
#' hundreds, using mapply, (that's the work of the
#' function (convert_3_digits())) and attach the suffix
#' as appropriate (thousands, millions, etc.)
#' with mapply.
#' Spanish uses long scale, and that is the one
#' used in this code (1 billion = 1e12). See
#' (https://en.wikipedia.org/wiki/Long_and_short_scales)
#'
#' @usage to_words(x)
#' @keywords spanish, integers, money, quantities.
#' @param x An integer up to 1e22 or a string of numbers up to 60 digits
#' @return A string for the same integer number in spanish.
#' @examples
#' # Converting numbers (can be negative)
#' to_words(31254865)
#' # converting strings of digits (can have a "-" as the first character)
#' to_words("-542687982546720143")
#' @export


to_words = function(x){
  if (is.character(x)) {
    ## test if it's only digits, else error out:
      split_x = strsplit(x, "")[[1]]
      if (split_x[1] == "-"){
          negative = TRUE
          x = (split_x[-1] |> paste(collapse = ""))
      }else{
          negative = FALSE
    }
    if (!grepl("\\D", x)){
      y = x
      if (nchar(y) > 60){
          stop("That one there is a big number. I ran out of words.")
      }
    }else{
      stop("String should contain only numbers.")
    }
  } else if (is.numeric(x)) {
      if (x != round(x, 0)) {
          stop("Number should be an integer!")
      }
      if (x < 0){
          negative = TRUE
          x = abs(x)
      }else{
          negative = FALSE
      }
      if (x > 1e22) {
          warning(paste0(
              "Number is big, precision errors may be present",
              " in the output.\nSee https://stackoverflow.com/",
              "questions/23600569/r-wrong-arithmetic-for-big-numbers"
          ))
      }
      if (x >= 1e23) {
          stop(paste0(
              "Errors due to precion are so big that results ",
              "became useless."
          ))
      }
      y = format(x, scientific = FALSE)
  }else{
      stop("Input should be either numeric or a string of numbers.")
  }
  
  groups = regmatches(y, gregexpr(".{1,3}(?=(.{3})*$)", y, perl = TRUE))[[1]]

  long_text = sapply(groups, convert_3_digits)
  big_units = c("", " mil", " millones", " mil", " billones", " mil",
                " trillones", " mil", " cuatrillones", " mil",
                " quintillones", " mil", " sextillones", " mil",
                " septillones", " mil", " octillones", " mil",
                " nonillones", " mil")
  raw_text = mapply(paste0, long_text, rev(big_units[1:length(groups)]))
  negative_text = ifelse(negative == TRUE,
                         "menos ",
                         "")
  cleaned_text = paste0(
          negative_text,
          clean_text(paste(raw_text, collapse = " "))
  )
  return(cleaned_text)
}

clean_text = function(n){
  ## We are aware that many of this replacements can
  ## be "summarized" by the use of some regex.
  ## We choose to keep the replacements readable at
  ## the (cheap) expense of making the code longer.
  ## regex can add 1 problem to your 99 on list:
  ## https://xkcd.com/1171
  ## fix hundreds
  n = gsub("cerocientos", "", n)
  n = gsub("unocientos", "ciento", n)
  n = gsub("cincocientos", "quinientos", n)
  n = gsub("sietecientos", "setecientos", n)
  n = gsub("nuevecientos", "novecientos", n)
  ## fix tenths
  n = gsub("cerodiez", "", n)
  n = gsub("unodiez", "diez", n)
  n = gsub("dosdiez", "veinte", n)
  n = gsub("tresdiez", "treinta", n)
  n = gsub("cuatrodiez", "cuarenta", n)
  n = gsub("cincodiez", "cincuenta", n)
  n = gsub("seisdiez", "sesenta", n)
  n = gsub("sietediez", "setenta", n)
  n = gsub("ochodiez", "ochenta", n)
  n = gsub("nuevediez", "noventa", n)
  ## fix teens
  n = gsub("diez y uno", "once", n)
  n = gsub("diez y dos", "doce", n)
  n = gsub("diez y tres", "trece", n)
  n = gsub("diez y cuatro", "catorce", n)
  n = gsub("diez y cinco", "quince", n)
  ## fix thousands
  n = gsub("cero mil ", "", n)
  n = gsub("uno mil", "mil", n)
  n = gsub("veinte y mil", "veinte y un mil", n)
  n = gsub("treinta y mil", "treinta y un mil", n)
  n = gsub("cuarenta y mil", "cuarenta y un mil", n)
  n = gsub("cincuenta y mil", "cincuenta y un mil", n)
  n = gsub("sesenta y mil", "sesenta y un mil", n)
  n = gsub("setenta y mil", "setenta y un mil", n)
  n = gsub("ochenta y mil", "ochenta y un mil", n)
  n = gsub("noventa y mil", "noventa y un mil", n)
  ## fix millions
  n = gsub("cero millones", "millones", n)
  n = gsub("^millones", "un millón", n)
  ## fix billions (1e12)
  n = gsub("billones millones", "billones", n)
  n = gsub("uno billones", "un billón", n)
  n = gsub("cero billones", "billones", n)
  ## fix trillions (1e18)
  n = gsub("trillones billones", "trillones", n)
  n = gsub("uno trillones", "un trillón", n)
  n = gsub("cero trillones", "trillones", n)
  ## fix cuatrillions (1e24)
  n = gsub("cuatrillones trillones", "cuatrillones", n)
  n = gsub("uno cuatrillones", "un cuatrillón", n)
  n = gsub("cero cuatrillones", "cuatrillones", n)
  ## fix quintillions (1e30)
  n = gsub("quintillones cuatrillones", "quintillones", n)
  n = gsub("uno quintillones", "un quintillón", n)
  n = gsub("cero quintillones", "quintillones", n)
  ## fix sextillions (1e36)
  n = gsub("sextillones quintillones", "sextillones", n)
  n = gsub("uno sextillones", "un sextillón", n)
  n = gsub("cero sextillones", "sextillones", n)
  ## fix septillions (1e42)
  n = gsub("septillones sextillones", "septillones", n)
  n = gsub("uno septillones", "un septillón", n)
  n = gsub("cero septillones", "septillones", n)
  ## fix octillions (1e48)
  n = gsub("octillones septillones", "octillones", n)
  n = gsub("uno octillones", "un octillón", n)
  n = gsub("cero octillones", "octillones", n)
  ## fix ninillions (1e54)
  n = gsub("nonillones octillones", "nonillones", n)
  n = gsub("uno nonillones", "un nonillón", n)
  n = gsub("cero nonillones", "nonillones", n)
  ## general cleaning
  n = gsub(" {2,}", " ", n)
  n = gsub("^ +y ", "", n)
  n = gsub(" y? ?cero$", "", n)
  n = gsub("^ciento$", "cien", n)
  n = gsub("^ ", "", n)
}

convert_3_digits = function(string_value){
  units = c("cero", "uno", "dos", "tres", "cuatro",
            "cinco", "seis", "siete", "ocho", "nueve")

  string_value = sprintf("%03d", as.integer(string_value))
  digits = strsplit(string_value, "")[[1]]
  a = sapply(digits, function(x) units[as.integer(x) + 1])
  raw_text = mapply(paste0, a, c("cientos", "diez y", ""))
  clean_text(paste(raw_text, collapse = " "))
}
