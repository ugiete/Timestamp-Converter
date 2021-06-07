defmodule Timestamp.Converter.Data.DateTimeStruct do
  @moduledoc """
  Structure to handle convertion
  """

  defstruct [:weekday, :date, :time, :datetime, :timestamp, status: false]
end
