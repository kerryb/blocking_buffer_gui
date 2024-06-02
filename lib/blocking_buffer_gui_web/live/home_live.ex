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

    {:ok, buffer} = Buffer.start_link(5)
    buffer_state = buffer_state(buffer)

    {:ok,
     assign(socket,
       producers: producers,
       consumers: consumers,
       buffer: buffer,
       buffer_state: buffer_state
     )}
  end

  @impl LiveView
  def handle_event("push", params, socket) do
    pid = self()
    id = String.to_integer(params["id"])

    Task.start_link(fn ->
      Buffer.push(socket.assigns.buffer, id)
      send(pid, {:pushed, id})
    end)

    {:noreply, update(socket, :producers, &update_status(&1, id, :blocked))}
  end

  def handle_event("pop", params, socket) do
    pid = self()
    id = String.to_integer(params["id"])

    Task.start_link(fn ->
      item = Buffer.pop(socket.assigns.buffer)
      send(pid, {:popped, id, item})
    end)

    {:noreply, update(socket, :consumers, &update_status(&1, id, :blocked))}
  end

  @impl LiveView
  def handle_info({:pushed, id}, socket) do
    {:noreply,
     update(socket, :producers, &update_status(&1, id, :idle))
     |> assign(buffer_state: buffer_state(socket.assigns.buffer))}
  end

  def handle_info({:popped, id, _item}, socket) do
    {:noreply,
     update(socket, :consumers, &update_status(&1, id, :idle))
     |> assign(buffer_state: buffer_state(socket.assigns.buffer))}
  end

  defp buffer_state(buffer) do
    buffer
    |> Buffer.state()
    |> Map.update!(:queue, &:queue.to_list/1)
    |> inspect(pretty: true, width: 30)
  end

  defp update_status(producers_or_consumers, id, status) do
    producers_or_consumers
    |> Enum.map(fn
      %{id: ^id} = item -> %{item | status: status}
      item -> item
    end)
  end

  defp border_class(:idle), do: "border-green-500"
  defp border_class(:blocked), do: "border-red-500"

  defp bg_class(:idle), do: "bg-green-500"
  defp bg_class(:blocked), do: "bg-red-500"
end
