defmodule Timestamp.Converter.Data.WeekDays do
  @moduledoc """
  Structure to handle week days
  """

  @weekdays %{1 => "Mon", 2 => "Tur", 3 => "Wed", 4 => "Tue", 5 => "Fri", 6 => "Sat", 7 => "Sun"}

  def name_of(index) when is_integer(index) and index <= 7 and index >= 1, do: @weekdays[index]
  def name_of(_), do: "N/A"
end
