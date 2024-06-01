defmodule BlockingBufferGuiWeb.HomeLive do
  alias BlockingBuffer.Buffer
  alias BlockingBufferGui.Producer
  alias BlockingBufferGui.Consumer
  alias Phoenix.LiveView
  use BlockingBufferGuiWeb, :live_view

  @impl LiveView
  def mount(_params, _session, socket) do
    producers =
      for id <- 1..3 do
        %Producer{id: id, status: :idle}
      end

    consumers =
      for id <- 1..3 do
        %Consumer{id: id, status: :idle}
      end

    {:ok, buffer} = Buffer.start_link(3)
    buffer_state = buffer_state(buffer)

    {:ok,
     assign(socket,
       producers: producers,
       consumers: consumers,
       buffer: buffer,
       buffer_state: buffer_state
     )}
  end

  defp buffer_state(buffer) do
    buffer
    |> Buffer.state()
    |> Map.update!(:queue, &:queue.to_list/1)
    |> inspect(pretty: true, width: 0)
  end

  defp border_class(:idle), do: "border-green-500"
  defp border_class(:blocked), do: "border-red-500"

  defp bg_class(:idle), do: "bg-green-500"
  defp bg_class(:blocked), do: "bg-red-500"
end
