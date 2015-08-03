defmodule DummyFleetService.Mixfile do
  use Mix.Project

  @description """
    A "dummy" Fleet Service application, which simulates the endpoints and
    typical responses you might expect from a Fleet HTTP API service. Inspired
    by (aka blatantly copying parts of) https://github.com/edgurgel/httparrot.
  """

  def project do
    [app: :dummy_fleet_service,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :cowboy, :faker],
     mod: {DummyFleetService, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:cowboy, "~> 1.0"},
      {:poison, "~> 1.4"},
      {:faker, github: "igas/faker"},
      {:httpoison, "~> 0.7", only: :test}]
  end
end
