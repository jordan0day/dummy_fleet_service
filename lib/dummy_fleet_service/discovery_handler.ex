defmodule DummyFleetService.DiscoveryHandler do
  use DummyFleetService.Cowboy, methods: ["GET"]

  alias DummyFleetService.FakeData

  def content_types_provided(req, state) do
    {[{{"application", "json", []}, :get_discovery_document}], req, state}
  end

  def get_discovery_document(req, _state) do
    IO.puts "Sending discovery document..."
    {{:chunked, stream_response()}, req, nil}
  end

  def stream_response() do
    # load document
    resp_body = File.read!("priv/discovery.json")
    fn (send_func) ->
      # Adjust this value as necessary to try to trip up timeout logic
      :timer.sleep(15000)
      send_func.(resp_body)
    end
  end
end