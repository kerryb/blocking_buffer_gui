defmodule BlockingBufferGuiWeb.HomeLiveTest do
  use BlockingBufferGuiWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  describe "BlockingBufferGuiWeb.HomeLive" do
    test "shows the buffer state", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      assert view |> element("pre", "state: :empty") |> has_element?()
    end

    test "allows items to be pushed", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      view |> element("#producer-1 button") |> render_click()
      view |> element("#producer-2 button") |> render_click()
      assert view |> element("pre", "queue: [1, 2]") |> has_element?()
    end

    test "disables producers when blocked by full buffer", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      for _ <- 1..6 do
        view |> element("#producer-1 button") |> render_click()
      end

      assert view |> element("#producer-1 button:disabled") |> has_element?()
    end

    test "allows items to be popped", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      view |> element("#producer-1 button") |> render_click()
      view |> element("#consumer-2 button") |> render_click()
      assert view |> element("pre", "queue: []") |> has_element?()
      assert view |> element("#popped-value-2", "1") |> has_element?()
    end

    test "disables consumer when blocked by empty buffer", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")
      view |> element("#consumer-1 button") |> render_click()
      assert view |> element("#consumer-1 button:disabled") |> has_element?()
    end
  end
end
