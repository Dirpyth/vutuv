defmodule VutuvWeb.Api.FollowerControllerTest do
  use VutuvWeb.ConnCase

  alias Vutuv.UserConnections

  test "lists all of a user's followers", %{conn: conn} do
    user = insert(:user)
    follower_ids = Enum.map(insert_list(12, :user), & &1.id)

    Enum.each(
      follower_ids,
      &UserConnections.create_user_connection(%{"followee_id" => user.id, "follower_id" => &1})
    )

    conn = get(conn, Routes.api_user_follower_path(conn, :index, user))
    assert followers = json_response(conn, 200)["data"]
    assert length(followers) == 12
  end
end
