
defmodule Netsplit.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do

    IO.inspect "Starting app"
    # List all child processes to be supervised
    children = [
      {Horde.Registry, [name: Netsplit.ServerRegistry, keys: :unique]},
      {Horde.Supervisor,
       [
         name: Netsplit.ServerSupervisor,
         strategy: :one_for_one,
         max_restarts: 100_000,
         max_seconds: 1
       ]},
      %{
        id: Netsplit.ClusterConnector,
        restart: :transient,
        start:
          {Task, :start_link,
           [
             fn ->
               Netsplit.ClusterConnector.connect()
               Netsplit.HordeConnector.connect()
               Horde.Supervisor.start_child(Netsplit.ServerSupervisor, Netsplit.Server)
             end
           ]}
      }
    ]

    opts = [strategy: :one_for_one, name: Netsplit.Supervisor]
    IO.inspect Supervisor.start_link(children, opts)
  end

  def get_state() do
    Horde.Registry.meta(Netsplit.ServerRegistry, "state")
  end
end
