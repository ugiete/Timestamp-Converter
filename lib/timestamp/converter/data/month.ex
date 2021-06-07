defmodule Timestamp.Converter.Data.Month do
  @moduledoc """
  Structure to handle months
  """

  @months %{
    1 => "Jan.",
    2 => "Feb.",
    3 => "Mar.",
    4 => "Apr.",
    5 => "May.",
    6 => "June",
    7 => "July",
    8 => "Aug.",
    9 => "Sept.",
    10 => "Oct.",
    11 => "Nov.",
    12 => "Dec."
  }

  def name_of(index) when is_integer(index) and index <= 12 and index >= 1, do: @months[index]
  def name_of(_), do: "N/A"
end
