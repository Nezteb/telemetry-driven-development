defmodule TDD.DemoServerTest do
  @moduledoc """
  Test file demonstrating how to utilize Telemetry in unit tests.

  mix test lib/tdd/demo_server.ex
  """
  use TDD.DataCase, async: true
  alias TDD.DemoServer

  describe "demo_server" do
    test "can listen for :telemetry event and use that instead of Process.sleep in unit test" do
      cpu_event = [:tdd, :demo_server, :cpu, :work_cycle, :finished]
      io_event = [:tdd, :demo_server, :io, :work_cycle, :finished]
      events_to_capture = [cpu_event, io_event]
      self = self()

      # Attach a handler to these events. When an event is dispatched, the handler
      # sends a message to the current test process.
      :telemetry.attach_many(
        "demo-server-test-handler",
        events_to_capture,
        fn event_name, measurements, metadata, _config ->
          send(self, {:telemetry_event, event_name, measurements, metadata})
        end,
        nil
      )

      # Trigger the asynchronous work in the DemoServer.
      DemoServer.trigger_work()

      # Instead of sleeping, we wait to receive the messages from our telemetry
      # handler. This makes the test faster and more reliable.
      assert_receive {:telemetry_event, ^cpu_event, %{cycle_count: 1}, %{}}, 5_000
      assert_receive {:telemetry_event, ^io_event, %{cycle_count: 1}, %{}}, 5_000
    end
  end
end
