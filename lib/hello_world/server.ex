defmodule Netsplit.Server do
  use GenServer

  def child_spec(opts) do
    name = Keyword.get(opts, :name, __MODULE__)

    %{id: "#{__MODULE__}_#{name}", start: {__MODULE__, :start_link, [name]}, shutdown: 10_000}
  end

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: via_tuple(name))
  end

  def get_state(name \\ __MODULE__) do
    GenServer.call(via_tuple(name), :get_state)
  end


  def set_state(new_state, name \\ __MODULE__) do
    GenServer.call(via_tuple(name), {:set_state, new_state})
  end

  def init(_args) do
    {:ok, get_global_state()}
  end

  def handle_call({:set_state, new_state}, _from,  _state) do
    IO.puts("Altering global state from node #{inspect(Node.self())}")

    {:reply, :ok, set_global_state(new_state)}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  defp get_global_state() do
    case Horde.Registry.meta(Netsplit.ServerRegistry, "state") do
      {:ok, state} -> state
      :error ->
        set_global_state("Initial state")
        get_global_state()
    end
  end

  defp set_global_state(new_state) do
    :ok = Horde.Registry.put_meta(Netsplit.ServerRegistry, "state", new_state)
    new_state
  end

  def via_tuple(name), do: {:via, Horde.Registry, {Netsplit.ServerRegistry, name}}
end
