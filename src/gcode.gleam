//// # Gcode main module
//// If you want to use it, just import and refer to the main function
//// ```gleam
//// import gcode
////
//// pub fn main() {
////   gcode.main()
//// }
//// ```

import gcode/cli.{Decode, Encode, Help, Undefined, Version}
import gcode/file
import gcode/utils
import gleam/io
import gleam/option.{None, Some}

/// # Gcode main function
/// ```gleam
/// pub fn main() -> Nil
/// ```
pub fn main() {
  case cli.build() {
    Help -> cli.help()
    Version -> cli.version()
    Undefined -> cli.undefined()

    other -> {
      let after_readed = case other |> file.read_file {
        Some(success) -> success
        None -> ""
      }

      let keys = case other |> utils.get_key {
        Some(keys_ok) -> keys_ok
        None -> 0
      }

      case other {
        Encode(_, _) -> {
          after_readed
          |> utils.encode(keys)
          |> io.println
        }

        Decode(_, _) -> {
          after_readed
          |> utils.decode(keys)
          |> io.println
        }

        _ -> Nil
      }

      Nil
    }
  }
}
