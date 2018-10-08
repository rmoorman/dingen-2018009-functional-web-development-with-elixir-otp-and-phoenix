defmodule IslandsEngine.GameSupervisor do

  use Supervisor

  alias IslandsEngine.Game

  ###
  ### Public interface
  ###

  def start_link(_options), do:
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)

  ###
  ### Supervisor callbacks
  ###

  def init(:ok), do:
    Supervisor.init([Game], strategy: :simple_one_for_one)

end
