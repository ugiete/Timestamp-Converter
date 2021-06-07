defmodule Timestamp.Converter do
  @moduledoc """
  Timestamp converter module
  """
  alias Timestamp.Converter.Data.{WeekDays, DateTimeStruct, Month}

  def now() do
    case DateTime.now("Etc/UTC") do
      {:ok, dt} -> dt |> DateTime.to_unix(:millisecond) |> timestamp_to_datetime()
      _ -> timestamp_to_datetime(:error)
    end
  end

  def timestamp_to_datetime(timestamp) when is_integer(timestamp) do
    timestamp
    |> to_struct(:timestamp)
    |> get_date()
    |> get_time()
    |> get_weekday()
    |> build_response(:timestamp)
  end

  def timestamp_to_datetime(timestamp) when is_binary(timestamp) do
    try do
      timestamp |> String.to_integer() |> timestamp_to_datetime()
    rescue
      ArgumentError -> timestamp_to_datetime(:error)
    end
  end

  def timestamp_to_datetime(_), do: %DateTimeStruct{} |> build_response(:timestamp)

  def datetime_to_timestamp(datetime) when is_binary(datetime) do
    try do
      datetime |> String.split(" ") |> datetime_to_timestamp()
    rescue
      ArgumentError -> %DateTimeStruct{} |> build_response(:datetime)
    end
  end

  def datetime_to_timestamp([date, time | _tail]) do
    %{date: to_date(date), time: to_time(time)}
    |> to_struct(:datetime)
    |> get_weekday()
    |> to_datetime()
    |> to_timestamp()
    |> build_response(:datetime)
  end

  defp to_struct(timestamp, :timestamp) do
    case DateTime.from_unix(timestamp, :millisecond) do
      {:ok, datetime} ->
        %DateTimeStruct{status: true, datetime: datetime, timestamp: timestamp}

      {:error, _} ->
        %DateTimeStruct{}
    end
  end

  defp to_struct(%{date: nil}, :datetime), do: %DateTimeStruct{}

  defp to_struct(%{time: nil}, :datetime), do: %DateTimeStruct{}

  defp to_struct(%{date: date, time: time}, :datetime) do
    %DateTimeStruct{status: true, date: date, time: time}
  end

  defp get_date(%{status: false} = context),
    do: context

  defp get_date(%{status: true, datetime: datetime} = context) do
    date = DateTime.to_date(datetime)
    Map.put(context, :date, date)
  end

  defp to_date(date) do
    try do
      [day, month, year] = String.split(date, "/")
      date_iso8601 = year <> "-" <> month <> "-" <> day

      case Date.from_iso8601(date_iso8601) do
        {:ok, date} -> date
        _ -> nil
      end
    rescue
      _ -> nil
    end
  end

  defp to_time(time) do
    case Time.from_iso8601(time) do
      {:ok, time} -> time
      _ -> nil
    end
  end

  defp to_datetime(%{date: nil} = context), do: context

  defp to_datetime(%{time: nil} = context), do: context

  defp to_datetime(%{date: date, time: time} = context) do
    datetime_iso8601 = Date.to_iso8601(date) <> "T" <> Time.to_iso8601(time) <> "Z"

    case DateTime.from_iso8601(datetime_iso8601) do
      {:ok, datetime, _} -> Map.put(context, :datetime, datetime)
      _ -> %DateTimeStruct{}
    end
  end

  defp to_timestamp(%{datetime: nil} = context), do: context

  defp to_timestamp(%{datetime: datetime} = context),
    do: Map.put(context, :timestamp, DateTime.to_unix(datetime, :millisecond))

  defp get_time(%{status: false} = context),
    do: context

  defp get_time(%{status: true, datetime: datetime} = context) do
    time = DateTime.to_time(datetime)
    Map.put(context, :time, time)
  end

  defp get_weekday(%{status: false} = context),
    do: context

  defp get_weekday(%{status: true, date: date} = context) do
    weekday =
      date
      |> Date.day_of_week()
      |> WeekDays.name_of()

    case weekday do
      "N/A" ->
        %DateTimeStruct{}

      day ->
        context |> Map.put(:weekday, day)
    end
  end

  defp build_response(%{status: false}, :timestamp), do: %{utc: "Invalid Date"}

  defp build_response(context, :timestamp) do
    %{
      unix: context.timestamp,
      utc: "#{context.weekday}, #{stringify_date(context.date)} #{context.time} GMT"
    }
  end

  defp build_response(%{status: false}, :datetime), do: %{utc: "Invalid Time"}

  defp build_response(context, :datetime) do
    %{
      unix: context.timestamp,
      utc: "#{context.weekday}, #{stringify_date(context.date)} #{context.time} GMT"
    }
  end

  defp stringify_date(date) do
    "#{date.day} #{Month.name_of(date.month)} #{date.year}"
  end
end
