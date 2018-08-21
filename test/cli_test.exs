defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.Cli, only: [ parse_args: 1, sort_issues: 1 ]

  test "parse_args() should take help as a switch" do
    assert parse_args(["--help", "doesnotmatter"]) == :help
    assert parse_args(["-h", "doesnotmatter"]) == :help
  end

  test "parse_args() should parse user, project, and count" do
    assert parse_args([ "some_user", "some_project", "12" ]) == { "some_user", "some_project", 12 }
  end

  test "parse_args() should provide default count when omitted" do
    assert parse_args([ "some_user", "some_project" ]) == { "some_user", "some_project", 4 }
  end

  test "sort_issues() should sort issues in descending order" do
    times =
      create_issues(["a", "c", "b"])
      |> sort_issues()
      |> Enum.map(&(Map.get(&1, "created_at")))

    assert times === ~w{ c b a }
  end

  defp create_issues(times) do
    times |> Enum.map(&(%{ "created_at" => &1 }))
  end
end
