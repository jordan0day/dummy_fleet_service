defmodule DummyFleetService.MachineHandler do
  use DummyFleetService.Cowboy, methods: ["GET"]

  alias DummyFleetService.FakeData

  def content_types_provided(req, state) do
    {[{{"application", "json", []}, :list_machines}], req, state}
  end

  def list_machines(req, state) do
    num_machines = :random.uniform(5) - 1
    IO.puts "Sending #{num_machines} machines..."
    {{:chunked, stream_response(num_machines)}, req, nil}
  end

  def stream_response(num_machines) do
    machines = Stream.repeatedly(fn -> FakeData.get_machine() end)
               |> Enum.take(num_machines)

    resp_body = Poison.encode!(%{machines: machines})
    fn (send_func) ->
      # Adjust this value as necessary to try to trip up timeout logic
      :timer.sleep(10000)
      send_func.(resp_body)
    end
  end
end