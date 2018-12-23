# Netsplit

Sample application to simulate a netsplit and showcase [Horde](https://github.com/derekkraan/horde/).

It's heavily based on [hello_world example form Horde](https://github.com/derekkraan/horde/tree/master/examples/hello_world)

## Basic use

For the most basic use case of distributed servers, you can start two separate terminals with:

HELLO_NODES="server2@127.0.0.1" iex --name server1@127.0.0.1 --cookie asdf -S mix

HELLO_NODES="server1@127.0.0.1" iex --name server2@127.0.0.1 --cookie asdf -S mix

Then you can alter our server state from server1 with

```elixir Netsplit.Server.set_state("new state") ```

ant then on server2 you can check it's updated with

```elixir Netsplit.Server.get_state() ```
