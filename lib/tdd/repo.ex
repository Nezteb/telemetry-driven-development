defmodule TDD.Repo do
  use Ecto.Repo,
    otp_app: :tdd,
    adapter: Ecto.Adapters.Postgres
end
