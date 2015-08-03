defmodule DummyFleetService do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    dispatch = :cowboy_router.compile([
      {:_, [ {'/fleet/v1/units', DummyFleetService.UnitsHandler, []},
             {'/fleet/v1/units/:name', DummyFleetService.UnitHandler, []},
             {'/fleet/v1/state', DummyFleetService.UnitStatesHandler, []},
             {'/fleet/v1/machines', DummyFleetService.MachineHandler, []},
             {'/fleet/v1/discovery', DummyFleetService.DiscoveryHandler, []}]}
    ])

    http_port = 8080
    IO.puts "Starting DummyFleetService on port #{http_port}"
    {:ok, _} = :cowboy.start_http(:http, 100,
      [port: http_port],
      [env: [dispatch: dispatch]])

    Supervisor.start_link([], strategy: :one_for_one)
  end
end
