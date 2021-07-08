defmodule HelloWeb.HelloController do
  use HelloWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"messenger" => messenger}) do
    #render (conn, "show.html", messenger: messenger)
    #text(conn, "From messenger: #{messenger}")
    # html(conn, """
    #   <html>
    #     <head>
    #       <title>Passing a Messenger</title>
    #     </head>
    #     <body>
    #       <p>From messenger #{Plug.HTML.html_escape(messenger)}</p>
    #     </body>
    #   </html>
    # """)

    conn
    |> assign(:messenger, messenger)
    |> assign(:receiver, "Juan")
    |> render("show.html")
  end
end
