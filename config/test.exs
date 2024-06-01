import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :blocking_buffer_gui, BlockingBufferGuiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "h7fMZjcel69pXRM7tNYESbsiIVfEICn5tvS/EO1AYM2ZTaGdHTcQQgr1Ctutu8Rg",
  server: false

# In test we don't send emails.
config :blocking_buffer_gui, BlockingBufferGui.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true
