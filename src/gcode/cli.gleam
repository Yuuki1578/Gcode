import argv
import gleam/int
import gleam/io

pub type Command(file, keys) {
  Help
  Version
  Encode(file, keys)
  Decode(file, keys)
  Undefined
}

pub fn build() -> Command(String, String) {
  case argv.load().arguments {
    ["help"] -> Help
    ["version"] -> Version
    ["encode", file, keys] -> Encode(file, keys)
    ["decode", file, keys] -> Decode(file, keys)
    _ -> Undefined
  }
}

pub fn help() {
  io.println("Gleam Encode: Encode ASCII file to Caesar Token")
  io.println("")
  io.println("Usage: ")
  io.println("Encode mode : gcode encode [FILE] <KEY>")
  io.println("Decode mode : gcode decode [FILE] <KEY>")
  io.println("Help        : gcode help")
  io.println("Version     : gcode version")
}

pub fn main() {
  help()
}
