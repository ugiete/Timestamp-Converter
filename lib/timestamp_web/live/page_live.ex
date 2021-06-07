defmodule TimestampWeb.PageLive do
  @moduledoc false
  use TimestampWeb, :live_view
  alias Timestamp.Converter

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, timestamp: "", datetime: "")}
  end

  @impl true
  def handle_event("clear", _params, socket) do
    {:noreply, assign(socket, timestamp: "", datetime: "")}
  end

  @impl true
  def handle_event("convert", %{"timestamp" => "", "datetime" => ""}, socket) do
    {:noreply, assign(socket, timestamp: "", datetime: "")}
  end

  @impl true
  def handle_event("convert", %{"timestamp" => "", "datetime" => datetime}, socket) do
    %{unix: timestamp, utc: utc} = Converter.datetime_to_timestamp(datetime)
    {:noreply, assign(socket, timestamp: timestamp, datetime: utc)}
  end

  @impl true
  def handle_event("convert", %{"timestamp" => timestamp}, socket) do
    %{utc: utc} = timestamp |> Converter.timestamp_to_datetime()

    {:noreply, assign(socket, timestamp: timestamp, datetime: utc)}
  end
end
