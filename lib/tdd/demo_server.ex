defmodule TDD.DemoServer do
  @moduledoc """
  A simple GenServer that does some fake operations and creates
  OpenTelemetry traces/span for them as a demo.

  The GenServer will start, do some CPU-bound work, re-call itself
  every 10 seconds with to do more random work, and report telemetry
  each time.
  """

  use GenServer
  require OpenTelemetry.Tracer, as: Tracer
  require Logger

  # 10 seconds
  @work_interval 10_000

  # Telemetry event names
  @telemetry_prefix [:tdd, :demo_server]

  # Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def trigger_work() do
    GenServer.cast(__MODULE__, :do_work)
  end

  # Server Callbacks

  @impl true
  def init(_opts) do
    Logger.info("Starting #{__MODULE__}")

    # Schedule the first work cycle
    schedule_work()

    {:ok, %{cycle_count: 0, last_work_time: nil}}
  end

  @impl true
  def handle_cast(:do_work, state) do
    new_state = perform_work_cycle(state)
    schedule_work()
    {:noreply, new_state}
  end

  @impl true
  def handle_info(:do_work, state) do
    new_state = perform_work_cycle(state)
    schedule_work()
    {:noreply, new_state}
  end

  # Private Functions

  defp schedule_work() do
    Process.send_after(self(), :do_work, @work_interval)
  end

  defp perform_work_cycle(state) do
    cycle_count = state.cycle_count + 1

    Tracer.with_span "demo_server.work_cycle", %{
      "cycle.number" => cycle_count,
      "service.name" => "tdd_demo_server"
    } do
      Logger.info("DemoServer starting work cycle ##{cycle_count}")

      # Simulate multiple operations with their own spans
      cpu_result = simulate_cpu_work(cycle_count)
      io_result = simulate_io_work(cycle_count)
      calculation_result = simulate_calculation(cycle_count)

      # Add span attributes for the results
      Tracer.set_attributes([
        {"work.cpu_result", cpu_result},
        {"work.io_result", io_result},
        {"work.calculation_result", calculation_result},
        {"work.completed_at", DateTime.utc_now() |> DateTime.to_iso8601()}
      ])

      Logger.info("#{__MODULE__} completed work: ##{cycle_count} cycles")
    end

    %{state | cycle_count: cycle_count, last_work_time: DateTime.utc_now()}
  end

  defp simulate_cpu_work(cycle_count) do
    Tracer.with_span "demo_server.cpu_work", %{
      "operation.type" => "cpu_intensive",
      "cycle.number" => cycle_count
    } do
      # Simulate CPU-bound work
      work_amount = :rand.uniform(1000) + 500

      Tracer.set_attribute("cpu.work_amount", work_amount)

      result =
        Enum.reduce(1..work_amount, 0, fn i, acc ->
          # Some arbitrary calculation
          (acc + :math.pow(i, 1.5)) |> trunc()
        end)

      # Simulate some processing time
      Process.sleep(:rand.uniform(100) + 50)

      # Emit vanilla telemetry event for work cycle finishes (for demo unit test)
      event_measurements = %{cycle_count: cycle_count}
      event_metadata = %{}

      :telemetry.execute(
        @telemetry_prefix ++ [:cpu, :work_cycle, :finished],
        event_measurements,
        event_metadata
      )

      Tracer.set_attributes([
        {"cpu.result", result},
        {"cpu.duration_ms", :rand.uniform(100) + 50}
      ])

      result
    end
  end

  defp simulate_io_work(cycle_count) do
    Tracer.with_span "demo_server.io_work", %{
      "operation.type" => "io_simulation",
      "cycle.number" => cycle_count
    } do
      # Simulate I/O operation (like reading from a file or making an HTTP request)
      io_delay = :rand.uniform(200) + 100

      Tracer.set_attribute("io.delay_ms", io_delay)

      Process.sleep(io_delay)

      # Emit vanilla telemetry event for work cycle finishes (for demo unit test)
      event_measurements = %{cycle_count: cycle_count}
      event_metadata = %{}

      :telemetry.execute(
        @telemetry_prefix ++ [:io, :work_cycle, :finished],
        event_measurements,
        event_metadata
      )

      # Simulate different I/O outcomes
      outcomes = ["success", "partial_success", "retry_needed"]
      outcome = Enum.random(outcomes)

      Tracer.set_attributes([
        {"io.outcome", outcome},
        {"io.bytes_processed", :rand.uniform(1024) + 256}
      ])

      outcome
    end
  end

  defp simulate_calculation(cycle_count) do
    Tracer.with_span "demo_server.calculation", %{
      "operation.type" => "mathematical_computation",
      "cycle.number" => cycle_count
    } do
      # Simulate some complex calculation
      numbers = Enum.map(1..10, fn _ -> :rand.uniform(100) end)

      Tracer.set_attribute("calculation.input_size", length(numbers))

      # Perform various calculations
      sum = Enum.sum(numbers)
      avg = sum / length(numbers)
      variance = variance(numbers, avg)

      result = %{
        sum: sum,
        average: avg,
        variance: variance,
        max: Enum.max(numbers),
        min: Enum.min(numbers)
      }

      Tracer.set_attributes([
        {"calculation.sum", sum},
        {"calculation.average", avg},
        {"calculation.variance", variance}
      ])

      result
    end
  end

  defp variance(numbers, avg) do
    Enum.reduce(numbers, 0, fn x, acc -> acc + :math.pow(x - avg, 2) end) / length(numbers)
  end
end
