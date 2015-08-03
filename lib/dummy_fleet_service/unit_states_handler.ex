defmodule DummyFleetService.UnitStatesHandler do
  use DummyFleetService.Cowboy, methods: ["GET"]

  alias DummyFleetService.FakeData

  def content_types_provided(req, state) do
    {[{{"application", "json", []}, :list_states}], req, state}
  end

  def list_states(req, state) do
    num_states = :random.uniform(5) - 1
    IO.puts "Sending #{num_states} unit states..."
    {{:chunked, stream_response(num_states)}, req, nil}
  end

  def stream_response(num_states) do
    states = Stream.repeatedly(fn -> FakeData.get_unit_state() end)
             |> Enum.take(num_states)

    resp_body = Poison.encode!(%{states: states})
    fn (send_func) ->
      # Adjust this value as necessary to try to trip up timeout logic
      :timer.sleep(10000)
      send_func.(resp_body)
    end
  end
end