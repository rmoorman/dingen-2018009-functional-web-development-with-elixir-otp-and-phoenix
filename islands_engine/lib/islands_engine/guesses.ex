defmodule IslandsEngine.Guesses do

  alias __MODULE__
  alias IslandsEngine.Coordinate


  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]


  def new(), do:
    %Guesses{hits: MapSet.new(), misses: MapSet.new()}


  def add(%Guesses{} = guesses, :hit, %Coordinate{} = coordinate), do:
    update_in(guesses.hits, fn xs -> MapSet.put(xs, coordinate) end)

  def add(%Guesses{} = guesses, :miss, %Coordinate{} = coordinate), do:
    update_in(guesses.misses, fn xs -> MapSet.put(xs, coordinate) end)

end
