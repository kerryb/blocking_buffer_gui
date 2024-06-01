defmodule BlockingBufferGuiWeb.HomeLive do
  alias BlockingBufferGui.Producer
  alias BlockingBufferGui.Consumer
  alias Phoenix.LiveView
  use BlockingBufferGuiWeb, :live_view

  @impl LiveView
  def mount(_params, _session, socket) do
    producers = [
      %Producer{id: 1, status: :idle},
      %Producer{id: 2, status: :blocked},
      %Producer{id: 3, status: :idle}
    ]

    consumers = [
      %Consumer{id: 1, status: :idle},
      %Consumer{id: 2, status: :blocked},
      %Consumer{id: 3, status: :idle}
    ]

    queue_state = "TODO"

    {:ok, assign(socket, producers: producers, consumers: consumers, queue_state: queue_state)}
  end

  defp border_class(:idle), do: "border-green-500"
  defp border_class(:blocked), do: "border-red-500"

  defp bg_class(:idle), do: "bg-green-500"
  defp bg_class(:blocked), do: "bg-red-500"
end
