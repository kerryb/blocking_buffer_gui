defmodule BlockingBufferGuiWeb.HomeLiveTest do
  use BlockingBufferGuiWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  describe "BlockingBufferGuiWeb.HomeLive" do
    test "shows the buffer state", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      assert view |> element("pre", "state: :empty") |> has_element?()
    end
  end
end
