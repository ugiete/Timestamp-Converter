defmodule TimestampWeb.Router do
  use TimestampWeb, :router
  alias TimestampWeb.Api.ApiController

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TimestampWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TimestampWeb do
    pipe_through :browser

    live "/", PageLive, :index
  end

  scope "/api" do
    pipe_through :api

    get "/ts/:timestamp", ApiController, :convert_timestamp
    get "/dt/:datetime", ApiController, :convert_datetime
    get "/now", ApiController, :now
  end
end
