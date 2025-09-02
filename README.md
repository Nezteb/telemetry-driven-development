# Telemetry-Driven Development

## Description

> Telemetry is an invaluable part of any production deployment, but have you ever used it for local debugging or when writing unit/integration tests? While logging is a form of telemetry that many developers are familiar with, other tools like tracing and metrics have historically been production-only concerns. Even then, how often are your traces and metrics really being utilized? Developers should understand that these same tools that give you confidence in production can also help you during development and testing.
>
> Key takeaways for the audience: Telemetry is more than just logs. It's incredibly flexible and can be used for more than just operating a production deployment. You can also use telemetry to debug an application locally during development or even use it to unit/integration test entire parts of your system.
>
> Target audience: Developers with basic Elixir proficiency that are also familiar with high-level telemetry concepts (logs, tracing, metrics). Experience with `:telemetry` (hexdocs.pm/telemetry) and or OpenTelemetry (opentelemetry.io) is nice to have.

## Command Reference

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
# The Dockerfile + .dockerignore created by this need several tweaks because we used `--no-assets`.

docker compose up --detach \
                  --remove-orphans \
                  --renew-anon-volumes \
                  --force-recreate \
                  --build
```

## Timeline / Context

- [January 19, 2022: ElixirConf EU 2021 - "Monitoring Elixir With OpenTelemetry"](https://www.youtube.com/watch?v=4OBtc_eIKIE)
- [June 22, 2022: Code BEAM V America 21 - "BEAM + Prometheus + Grafana = Observability Heaven"](https://www.youtube.com/watch?v=0SkVsUdUutE)
- [November 14, 2022: Fly.io Blog - "Elixir, OpenTelemetry, and the Infamous N+1"](https://fly.io/phoenix-files/opentelemetry-and-the-infamous-n-plus-1/)
- [November 3, 2023: Cory O'Daniel Tweet - "Webinar: Test driven development with OpenTelemetry"](https://x.com/coryodaniel/status/1720482323148501099)
- [February 15, 2024: Substack - "All you need is Wide Events, not "Metrics, Logs and Traces'"](https://isburmistrov.substack.com/p/all-you-need-is-wide-events-not-metrics)
- [February 17, 2024: Blog Post - "Observability for Phoenix using the Grafana Stack in Dev"](https://web.archive.org/web/20240920140027/https://stereowrench.com/2024/02/17/observability-for-phoenix-using-the-grafana-stack-in-dev/)
- [April 4, 2024: Cory O'Daniel DMs me a link to tracetest](https://github.com/kubeshop/tracetest)
- [April 16, 2024: ElixirConf EU 23 - "Using OpenTelemetry To Troubleshoot & Monitor Production Applications"](https://www.youtube.com/watch?v=ecc94cYwOFo)
- [December 11, 2024: Webinar - "Instrumenting Erlang and Elixir code with open telemetry"](https://www.youtube.com/watch?v=0P_1KEOVwZg)
- [December 12, 2024: Elixir Wizards Podcast - "Telemetry & Observability for Elixir Apps"](https://smartlogic.io/podcast/elixir-wizards/s13-e09-observability-telemetry-elixir-cars-commerce/)
- [February 6, 2025: LostKobrakai on testing emitted telemetry events](https://bsky.app/profile/kobrakai.de/post/3lhiuibfuh22j)
- [February 11, 2025: Initial wildfires local telemetry demo](https://github.com/Nezteb/wildfires/blob/main/docker-compose.yml)
- [March 24, 2025: German Velasco asks about tracing in production](https://bsky.app/profile/germsvel.com/post/3ll4s25nxk222)
- [April 27, 2025: ElixirConf US 2024 - "OpenTelemetry: From Desire to Dashboard"](https://www.youtube.com/watch?v=62OK9B4yRfg)
- [May 6, 2025: David Bernheisel posts about Elixir pains working with OpenTelemetry](https://bsky.app/profile/david.bernheisel.com/post/3loj3yewrmk2p)
- [June 23, 2025: Lars Wikman asks about opinions on Grafana](https://bsky.app/profile/lawik.bsky.social/post/3lsav7sejll2o)
- [June 23, 2025: Łukasz Niemier mentions OpenTelemetry + DuckDB](https://bsky.app/profile/hauleth.dev/post/3lsbujw375k2j)
- [June 30, 2025: Jacob Swanner's proposed telemetry talk](https://bsky.app/profile/jacobswanner.com/post/3lsv2r2jtnc2b)
