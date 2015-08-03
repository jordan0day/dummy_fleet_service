defmodule DummyFleetService.UnitsHandler do
  use DummyFleetService.Cowboy, methods: ["GET"]

  alias DummyFleetService.FakeData

  def content_types_provided(req, state) do
    {[{{"application", "json", []}, :list_units}], req, state}
  end

  def list_units(req, state) do
    num_units = :random.uniform(5) - 1
    IO.puts "Sending #{num_units} units..."
    {{:chunked, stream_response(num_units)}, req, nil}
  end

  def stream_response(num_units) do
    units = Stream.repeatedly(fn -> FakeData.get_unit() end)
            |> Enum.take(num_units)

    resp_body = Poison.encode!(%{units: units})
    fn (send_func) ->
      # Adjust this value as necessary to try to trip up timeout logic
      :timer.sleep(10000)
      send_func.(resp_body)
    end
  end
end