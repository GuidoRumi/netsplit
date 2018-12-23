defmodule Netsplit.HordeConnector do
  require Logger

  def connect() do
    Node.list()
    |> Enum.each(fn node ->
      Horde.Cluster.join_hordes(Netsplit.ServerSupervisor, {Netsplit.ServerSupervisor, node})
      Horde.Cluster.join_hordes(Netsplit.ServerRegistry, {Netsplit.ServerRegistry, node})
    end)
  end
end
