defmodule HelloWeb.Router do
  use HelloWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HelloWeb.Plugs.Locale, "en"
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # pipeline :review_checks do
  #   plug :browser #pipelines themselves are plugs
  #   plug :ensure_authenticated_user
  #   plug :ensure_user_owns_review
  # end

  # scope "/reviews", HelloWeb do
  #   #pipe_through [:browser, :review_checks]
  #   pipe_through :review_checks

  #   resources "/", ReviewController
  # end

  # scope "/admin", HelloWeb.Admin, as: :admin do
  #   pipe_through :browser

  #   resources "/reviews", ReviewController
  # end

  scope "/", HelloWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/redirect_test", PageController, :redirect_test

    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show

    resources "/users", UserController

    resources "/sessions", SessionController, only: [:new, :create, :delete],
                                              singleton: true

    #resources "/users", UserController
    #resources "/posts", PostController, only: [:index, :show]
    #resources "/reviews", ReviewController
  end

  scope "/cms", HelloWeb.CMS, as: :cms do
    pipe_through [:browser, :authenticate_user]

    resources "/pages", PageController
  end

  defp authenticate_user(conn, _) do
    try do
      case get_session(conn, :user_id) do
        nil ->     handle_error(conn)
        user_id -> assign(conn, :current_user, Hello.Accounts.get_user!(user_id))
      end
    rescue
      Ecto.NoResultsError -> handle_error(conn)
    end
  end

  defp handle_error(conn) do
    conn
    |> Phoenix.Controller.put_flash(:error, "Login required")
    |> Phoenix.Controller.redirect(to: "/")
    |> halt()
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: HelloWeb.Telemetry
    end
  end
end
