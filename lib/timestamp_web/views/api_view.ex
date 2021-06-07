defmodule TimestampWeb.Api.ApiView do
  use TimestampWeb, :view

  def render("index.json", result), do: result
end
