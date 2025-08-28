import Config

# Enable dev routes for dashboard and mailbox (only for demo purposes)
config :tdd, dev_routes: true

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
