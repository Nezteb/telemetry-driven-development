defmodule TDDWeb.PageController do
  use TDDWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
