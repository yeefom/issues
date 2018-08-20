defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.Cli, only: [ parse_args: 1 ]

  test "should take help as a switch" do
    assert parse_args(["--help", "doesnotmatter"]) == :help
    assert parse_args(["-h", "doesnotmatter"]) == :help
  end

  test "should parse user, project, and count" do
    assert parse_args([ "some_user", "some_project", "12" ]) == { "some_user", "some_project", 12 }
  end

  test "should provide default count when omitted" do
    assert parse_args([ "some_user", "some_project" ]) == { "some_user", "some_project", 4 }
  end
end
