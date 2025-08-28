defmodule TDD.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    config =
      :tdd
      |> Application.get_all_env()
      |> Map.new()
      |> inspect()

    Logger.info("Starting #{__MODULE__}", config: config, env: inspect(System.get_env()))

    :ok = OpentelemetryBandit.setup(opt_in_attrs: [])
    :ok = OpentelemetryPhoenix.setup(adapter: :bandit)

    children = [
      TDDWeb.Telemetry,
      TDD.Repo,
      {DNSCluster, query: Application.get_env(:tdd, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TDD.PubSub},
      # Start a worker by calling: TDD.Worker.start_link(arg)
      # {TDD.Worker, arg},
      TDD.DemoServer,
      # Start to serve requests, typically the last entry
      TDDWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TDD.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TDDWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
