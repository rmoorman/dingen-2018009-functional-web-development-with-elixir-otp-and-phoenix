defmodule IslandsEngine.Game do

  use GenServer

  alias IslandsEngine.Board
  alias IslandsEngine.Guesses
  alias IslandsEngine.Rules



  ###
  ### Public interface
  ###

  def start_link(name) when is_binary(name), do:
    GenServer.start_link(__MODULE__, name, [])



  ###
  ### GenServer callbacks
  ###

  def init(name) do
    initial_state = %{
      player1: %{
        name: name,
        board: Board.new(),
        guesses: Guesses.new(),
      },
      player2: %{
        name: nil,
        board: Board.new(),
        guesses: Guesses.new(),
      },
      rules: Rules.new(),
    }

    {:ok, initial_state}
  end


  def handle_call(:demo_call, _from, state) do
    {:reply, state, state}
  end


  def handle_cast({:demo_cast, new_value}, state) do
    {:noreply, Map.put(state, :test, new_value)}
  end


  def handle_info(:first, state) do
    IO.puts("This message has been handled by handle_info/2, matching on :first.")
    {:noreply, state}
  end

end
