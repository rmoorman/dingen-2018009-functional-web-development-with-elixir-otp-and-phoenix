defmodule IslandsEngine.Game do

  use GenServer

  alias IslandsEngine.Board
  alias IslandsEngine.Coordinate
  alias IslandsEngine.Guesses
  alias IslandsEngine.Island
  alias IslandsEngine.Rules


  @players [:player1, :player2]



  ###
  ### Public interface
  ###

  def start_link(name) when is_binary(name), do:
    GenServer.start_link(__MODULE__, name, [])

  def add_player(game, name) when is_binary(name), do:
    GenServer.call(game, {:add_player, name})

  def position_island(game, player, key, row, col) when player in @players, do:
    GenServer.call(game, {:position_island, player, key, row, col})

  def set_islands(game, player) when player in @players, do:
    GenServer.call(game, {:set_islands, player})



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

  def handle_call({:position_island, player, key, row, col}, _from, state) do
    board = player_board(state, player)
    with {:ok, rules} <- Rules.check(state.rules, {:position_islands, player}),
         {:ok, coordinate} <- Coordinate.new(row, col),
         {:ok, island} <- Island.new(key, coordinate),
         %{} = board <- Board.position_island(board, key, island)
    do
      state
      |> update_board(player, board)
      |> update_rules(rules)
      |> reply_success(:ok)
    else
      :error ->
        {:reply, :error, state}

      {:error, :invalid_coordinate} ->
        {:reply, {:error, :invalid_coordinate}, state}

      {:error, :invalid_island_type} ->
        {:reply, {:error, :invalid_island_type}, state}
    end
  end

  def handle_call({:set_islands, player}, _from, state) do
    board = player_board(state, player)
    with {:rules, {:ok, rules}} <- {:rules, Rules.check(state.rules, {:set_islands, player})},
         {:board, true} <- {:board, Board.all_islands_positioned?(board)}
    do
      state
      |> update_rules(rules)
      |> reply_success({:ok, board})
    else
      {:rules, :error} -> {:reply, :error, state}
      {:board, false} -> {:reply, {:error, :not_all_islands_positioned}, state}
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


  defp player_board(state, player), do:
    Map.get(state, player).board


  defp update_board(state, player, board), do:
    Map.update!(state, player, fn player -> %{player | board: board} end)

end
