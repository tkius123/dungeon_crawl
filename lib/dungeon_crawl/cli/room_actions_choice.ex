defmodule DungeonCrawl.CLI.RoomActionsChoice do
  alias Mix.Shell.IO, as: Shell
  import DungeonCrawl.CLI.BaseCommands

  def start(room) do
    room_actions = room.actions
    Shell.info(room.description)

    chosen_action =
      room_actions
      |> display_options
      |> generate_question
      |> Shell.prompt
      |> parse_answer
      |> (&(Enum.at(room_actions, &1))).()
      |> show_choice

    {room, chosen_action}
  end
end
