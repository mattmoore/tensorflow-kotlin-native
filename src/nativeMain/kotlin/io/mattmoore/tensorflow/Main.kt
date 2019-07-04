package io.mattmoore.tensorflow

import kotlinx.cinterop.*
import tensorflow.*

fun main(args: Array<String>) {
  println(TF_Version()?.toKString())
}
