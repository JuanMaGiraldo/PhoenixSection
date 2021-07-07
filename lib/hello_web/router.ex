defmodule HelloWeb.Router do
  use HelloWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :review_checks do
    plug :browser #pipelines themselves are plugs
    plug :ensure_authenticated_user
    plug :ensure_user_owns_review
  end

  scope "/reviews", HelloWeb do
    #pipe_through [:browser, :review_checks]
    pipe_through :review_checks

    resources "/", ReviewController
  end

  scope "/admin", HelloWeb.Admin, as: :admin do
    pipe_through :browser

    resources "/reviews", ReviewController
  end

  scope "/", HelloWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show

    resources "/users", UserController
    resources "/posts", PostController, only: [:index, :show]
    resources "/reviews", ReviewController
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: HelloWeb.Telemetry
    end
  end
end
