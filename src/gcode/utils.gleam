import gcode/cli.{type Command, Decode, Encode}
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string

pub fn encode(stream: String, key: Int) -> String {
  let return =
    stream
    |> string.to_utf_codepoints
    |> list.map(fn(utf) {
      let char =
        utf
        |> string.utf_codepoint_to_int

      case char < 97 || char > 122 {
        True -> {
          case char < 65 || char > 90 {
            True -> {
              case char < 48 || char > 57 {
                True -> {
                  let assert Ok(success) = char |> string.utf_codepoint
                  success
                }

                False -> {
                  let fixed = { char - 48 + key } % 10 + 48
                  let assert Ok(success) = fixed |> string.utf_codepoint
                  success
                }
              }
            }

            False -> {
              let fixed = { char - 65 + key } % 26 + 65
              let assert Ok(success) = fixed |> string.utf_codepoint
              success
            }
          }
        }

        False -> {
          let fixed = { char - 97 + key } % 26 + 97
          let assert Ok(success) = fixed |> string.utf_codepoint
          success
        }
      }
    })

  return |> string.from_utf_codepoints
}

pub fn decode(stream: String, key: Int) -> String {
  let return =
    stream
    |> string.to_utf_codepoints
    |> list.map(fn(utf) {
      let char =
        utf
        |> string.utf_codepoint_to_int

      case char < 97 || char > 122 {
        True -> {
          let assert Ok(success) = char |> string.utf_codepoint
          success
        }

        False -> {
          let fixed = { char - 97 - key + 26 } % 26 + 97
          let assert Ok(success) = fixed |> string.utf_codepoint
          success
        }
      }
    })

  return |> string.from_utf_codepoints
}

pub fn get_key(from: Command(String, String)) -> Option(Int) {
  case from {
    Encode(_, key) | Decode(_, key) -> {
      case key |> int.parse {
        Ok(success) -> Some(success)
        Error(_) -> {
          io.println_error("error: " <> key <> " is not a valid keys, aborting")
          None
        }
      }
    }

    _ -> None
  }
}
