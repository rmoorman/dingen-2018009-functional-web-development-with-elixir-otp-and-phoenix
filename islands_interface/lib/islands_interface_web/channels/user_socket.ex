defmodule IslandsInterfaceWeb.UserSocket do
  use Phoenix.Socket

  channel "game:*", IslandsInterfaceWeb.GameChannel

  def connect(_params, socket, _connect_info), do: {:ok, socket}
  def id(_socket), do: nil
end
