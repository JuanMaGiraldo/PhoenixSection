defmodule HelloWeb.PageController do
  use HelloWeb, :controller

  action_fallback HelloWeb.MyFallbackController

  def index(conn, _params) do
    #conn
    #|> put_resp_content_type("text/plain")
    #|> send_resp(201, "")

    #conn
    #|> put_status(202)
    #|> render("index.html")

    #conn
    #|> put_layout("admin.html")
    #|> render("index.html")


    #redirect(conn, to: "/redirect_test")
    #redirect(conn, to: Routes.page_path(conn, :redirect_test))

    conn
    |> put_flash(:info, "Welcome to Phoenix, from flash info!")
    |> put_flash(:error, "Let's pretend we have an error.")
    |> render("index.html")
  end

  def redirect_test(conn, _params) do
    render(conn, "index.html")
  end

  # def handle_error(conn, %{"id" => id}, current_user) do
  #   with {:ok, post} <- fetch_post(id),
  #        :ok <- authorize_user(current_user, :view, post) do
  #     render(conn, "show.json", post: post)
  #   end
  # end
end
