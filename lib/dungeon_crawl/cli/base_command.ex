defmodule DungeonCrawl.CLI.BaseCommands do

  use Monad.Operators

  alias Mix.Shell.IO, as: Shell

  import Monad.Result, only: [success: 1, success?: 1, error: 1, return: 1]

  def display_options(options) do
    options
    |> Enum.with_index(1)
    |> Enum.each(fn {option, index} ->
        Shell.info("#{index} - #{option}")
      end)
    return (options)
  end

  def ask_for_index(options) do
    answer =
      options
      |> display_options
      |> generate_question
      |> Shell.prompt
      |> Integer.parse

    case answer do
      :error ->
        display_invalid_option()
        ask_for_index(options)
      {option, _} ->
        option - 1
    end
  end

  def display_invalid_option do
    Shell.cmd("clear")
    Shell.error("Invalid option.")
    Shell.prompt("Press Enter to try again")
    Shell.cmd("clear")
  end

  def ask_for_option(options) do
    result =
      return(options)
        ~>> (&display_options/1)
        ~>> (&generate_question/1)
        ~>> (&Shell.prompt/1)
        ~>> (&parse_answer/1)
        ~>> (&(find_option_by_index(&1, options)))

    if success?(result) do
      result.value
    else
      display_error(result.error)
      ask_for_option(options)
    end
  end

  def display_error(message) do
    Shell.cmd("clear")
    Shell.error(message)
    Shell.prompt("Press Enter to continue")
    Shell.cmd("clear")
  end

  def generate_question(options) do
    options = Enum.join(1..Enum.count(options), ",")
    "Which one? [#{options}]\n"
  end

  def parse_answer(answer) do
    case Integer.parse(answer) do
      :error -> error("Invalid option")
      {option, _} -> success(option - 1)
    end
  end

  def find_option_by_index(index, options) do
    case Enum.at(options, index) do
      nil -> error("Invalid option")
      chosen_option -> success(chosen_option)
    end
  end

  def confirm_choice(choice) do
    Shell.cmd("clear")
    Shell.info(choice.description)
    if Shell.yes?("Confirm?"), do: choice, else: :no
  end
end
