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

  def add_player(game, name) when is_binary(name), do:
    GenServer.call(game, {:add_player, name})



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


  def handle_call({:add_player, name}, _from, state) do
    with {:ok, rules} <- Rules.check(state.rules, :add_player)
    do
      state
      |> update_player2_name(name)
      |> update_rules(rules)
      |> reply_success(:ok)
    else
      :error -> {:reply, :error, state}
    end
  end



  ###
  ### Further implementation
  ###

  defp update_player2_name(state, name), do:
    put_in(state.player2.name, name)


  defp update_rules(state, rules), do:
    %{state | rules: rules}


  defp reply_success(state, reply), do:
    {:reply, reply, state}

end
