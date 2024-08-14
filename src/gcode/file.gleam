import gcode/cli.{type Command, Decode, Encode}
import gleam/option.{type Option, None, Some}
import simplifile

pub fn read_file(from: Command(String, String)) -> Option(String) {
  case from {
    Encode(file, _) | Decode(file, _) -> {
      case file |> simplifile.read {
        Ok(readed) -> Some(readed)
        Error(_) -> None
      }
    }

    _ -> None
  }
}
