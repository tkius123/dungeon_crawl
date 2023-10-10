defmodule DungeonCrawl.CLI.HeroChoice do
  alias Mix.Shell.IO, as: Shell
  import DungeonCrawl.CLI.BaseCommands

  def start do
    Shell.cmd("cls")
    Shell.info("Start by choosing your hero:")

    choice =
    DungeonCrawl.Heroes.all()
    |> ask_for_option
    |> confirm_choice()

    if choice == :no, do: start(), else: choice
  end
end
