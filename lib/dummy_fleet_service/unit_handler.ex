defmodule DummyFleetService.UnitHandler do
  use DummyFleetService.Cowboy, methods: ["GET"]

  alias DummyFleetService.FakeData

  def malformed_request(req, state) do
    {name, req} = :cowboy_req.binding(:name, req)
    if name == nil || String.length(name) == 0 do
      {true, req, state}
    else
      {false, req, name}
    end
  end

  def content_types_provided(req, state) do
    {[{{"application", "json", []}, :get_unit}], req, state}
  end

  def get_unit(req, name) do
    IO.puts "Handling get_unit call for unit #{name}..."
    {{:chunked, stream_response(name)}, req, nil}
  end

  def stream_response(unit_name) do
    unit = %{FakeData.get_unit | name: unit_name}
    resp_body = Poison.encode!(unit)

    fn(send_func) ->
      # Adjust this value as necessary to try to trip up timeout logic
      :timer.sleep(10000)
      send_func.(resp_body)
    end
  end
end