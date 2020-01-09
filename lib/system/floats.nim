type
  float* {.magic: Float.}     ## Default floating point type.
  float32* {.magic: Float32.} ## 32 bit floating point type.
  float64* {.magic: Float.}   ## 64 bit floating point type.

# 'float64' is now an alias to 'float'; this solves many problems

type
  SomeFloat* = float|float32|float64
    ## Type class matching all floating point number types.

  BiggestFloat* = float64
    ## is an alias for the biggest floating point type the Nim
    ## compiler supports. Currently this is ``float64``, but it is
    ## platform-dependent in general.

  PFloat32* = ptr float32    ## An alias for ``ptr float32``.
  PFloat64* = ptr float64    ## An alias for ``ptr float64``.

# floating point operations:
proc `+`*(x: float32): float32 {.magic: "UnaryPlusF64", noSideEffect.}
proc `-`*(x: float32): float32 {.magic: "UnaryMinusF64", noSideEffect.}
proc `+`*(x, y: float32): float32 {.magic: "AddF64", noSideEffect.}
proc `-`*(x, y: float32): float32 {.magic: "SubF64", noSideEffect.}
proc `*`*(x, y: float32): float32 {.magic: "MulF64", noSideEffect.}
proc `/`*(x, y: float32): float32 {.magic: "DivF64", noSideEffect.}

proc `+`*(x: float): float {.magic: "UnaryPlusF64", noSideEffect.}
proc `-`*(x: float): float {.magic: "UnaryMinusF64", noSideEffect.}
proc `+`*(x, y: float): float {.magic: "AddF64", noSideEffect.}
proc `-`*(x, y: float): float {.magic: "SubF64", noSideEffect.}
proc `*`*(x, y: float): float {.magic: "MulF64", noSideEffect.}
proc `/`*(x, y: float): float {.magic: "DivF64", noSideEffect.}

proc `==`*(x, y: float32): bool {.magic: "EqF64", noSideEffect.}
proc `<=`*(x, y: float32): bool {.magic: "LeF64", noSideEffect.}
proc `<`  *(x, y: float32): bool {.magic: "LtF64", noSideEffect.}

proc `==`*(x, y: float): bool {.magic: "EqF64", noSideEffect.}
proc `<=`*(x, y: float): bool {.magic: "LeF64", noSideEffect.}
proc `<`*(x, y: float): bool {.magic: "LtF64", noSideEffect.}


proc toFloat*(i: int): float {.noSideEffect, inline.} =
  ## Converts an integer `i` into a ``float``.
  ##
  ## If the conversion fails, `ValueError` is raised.
  ## However, on most platforms the conversion cannot fail.
  ##
  ## .. code-block:: Nim
  ##   let
  ##     a = 2
  ##     b = 3.7
  ##
  ##   echo a.toFloat + b # => 5.7
  float(i)

proc toBiggestFloat*(i: BiggestInt): BiggestFloat {.noSideEffect, inline.} =
  ## Same as `toFloat <#toFloat,int>`_ but for ``BiggestInt`` to ``BiggestFloat``.
  BiggestFloat(i)

proc toInt*(f: float): int {.noSideEffect.} =
  ## Converts a floating point number `f` into an ``int``.
  ##
  ## Conversion rounds `f` half away from 0, see
  ## `Round half away from zero
  ## <https://en.wikipedia.org/wiki/Rounding#Round_half_away_from_zero>`_.
  ##
  ## Note that some floating point numbers (e.g. infinity or even 1e19)
  ## cannot be accurately converted.
  ##
  ## .. code-block:: Nim
  ##   doAssert toInt(0.49) == 0
  ##   doAssert toInt(0.5) == 1
  ##   doAssert toInt(-0.5) == -1 # rounding is symmetrical
  if f >= 0: int(f+0.5) else: int(f-0.5)

proc toBiggestInt*(f: BiggestFloat): BiggestInt {.noSideEffect.} =
  ## Same as `toInt <#toInt,float>`_ but for ``BiggestFloat`` to ``BiggestInt``.
  if f >= 0: BiggestInt(f+0.5) else: BiggestInt(f-0.5)


const
  Inf* = 0x7FF0000000000000'f64
    ## Contains the IEEE floating point value of positive infinity.
  NegInf* = 0xFFF0000000000000'f64
    ## Contains the IEEE floating point value of negative infinity.
  NaN* = 0x7FF7FFFFFFFFFFFF'f64
    ## Contains an IEEE floating point value of *Not A Number*.
    ##
    ## Note that you cannot compare a floating point value to this value
    ## and expect a reasonable result - use the `classify` procedure
    ## in the `math module <math.html>`_ for checking for NaN.


{.push stackTrace: off.}

proc abs*(x: float64): float64 {.noSideEffect, inline.} =
  if x < 0.0: -x else: x
proc abs*(x: float32): float32 {.noSideEffect, inline.} =
  if x < 0.0: -x else: x
proc min*(x, y: float32): float32 {.noSideEffect, inline.} =
  if x <= y or y != y: x else: y
proc min*(x, y: float64): float64 {.noSideEffect, inline.} =
  if x <= y or y != y: x else: y
proc max*(x, y: float32): float32 {.noSideEffect, inline.} =
  if y <= x or y != y: x else: y
proc max*(x, y: float64): float64 {.noSideEffect, inline.} =
  if y <= x or y != y: x else: y
proc min*[T: not SomeFloat](x, y: T): T {.inline.} =
  if x <= y: x else: y
proc max*[T: not SomeFloat](x, y: T): T {.inline.} =
  if y <= x: x else: y

{.pop.} # stackTrace: off


proc high*(T: typedesc[SomeFloat]): T = Inf
proc low*(T: typedesc[SomeFloat]): T = NegInf


proc `+=`*[T: float|float32|float64] (x: var T, y: T) {.
  inline, noSideEffect.} =
  ## Increments in place a floating point number.
  x = x + y

proc `-=`*[T: float|float32|float64] (x: var T, y: T) {.
  inline, noSideEffect.} =
  ## Decrements in place a floating point number.
  x = x - y

proc `*=`*[T: float|float32|float64] (x: var T, y: T) {.
  inline, noSideEffect.} =
  ## Multiplies in place a floating point number.
  x = x * y

proc `/=`*(x: var float64, y: float64) {.inline, noSideEffect.} =
  ## Divides in place a floating point number.
  x = x / y

proc `/=`*[T: float|float32](x: var T, y: T) {.inline, noSideEffect.} =
  ## Divides in place a floating point number.
  x = x / y
