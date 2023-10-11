defprotocol DungeonCrawl.Display do
  @spec info(t) :: String.t()
  def info(value)
end

defimpl DungeonCrawl.Display, for: DungeonCrawl.Room.Action do
  def info(action), do: action.label
end

defimpl DungeonCrawl.Display, for: DungeonCrawl.Character do
  def info(character), do: character.name
end
