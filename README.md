# Telemetry-Driven Development

```sh
# https://hexdocs.pm/phoenix/1.8.0/Mix.Tasks.Phx.New.html
mix archive.install hex phx_new 1.8.0

# https://hexdocs.pm/phoenix/1.8.0/Mix.Tasks.Phx.New.html
mix phx.new \
  --binary-id \
  --no-mailer \
  --no-assets \
  --module TDD \
  .

mix release.init
mix phx.gen.release --docker
# The Dockerfile + .dockerignore created by this need a lot of tweaks

docker compose up --detach \
                  --remove-orphans \
                  --renew-anon-volumes \
                  --force-recreate \
                  --build
```
