defmodule TimestampWeb.Api.ApiController do
  @moduledoc """

  """
  use TimestampWeb, :controller
  alias Timestamp.Converter

  def convert_timestamp(conn, %{"timestamp" => timestamp}) do
    json(conn, Converter.timestamp_to_datetime(timestamp))
  end

  def convert_datetime(conn, %{"datetime" => datetime}) do
    [date, time | _tail] = String.split(datetime, "T")
    [day, month, year] = String.split(date, "-")

    dt = "#{day}/#{month}/#{year} #{time}"
    json(conn, Converter.datetime_to_timestamp(dt))
  end

  def now(conn, _params) do
    json(conn, Converter.now())
  end
end
