defmodule Issues.Cli do
  @default_count 4

  def main(argv) do
    argv
    |> parse_args()
    |> process
  end

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [ help: :boolean ], aliases: [ h: :help ])
    |> elem(1)
    |> parse
  end

  defp parse([ user, project, count ]), do: { user, project, String.to_integer(count) }
  defp parse([ user, project ]), do: { user, project, @default_count }
  defp parse(_), do: :help

  def process(:help) do
    IO.puts("Usage: issues <user> <project> [ count | #{@default_count} ]")
    System.halt(0)
  end

  def process({ user, project, count }) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_issues()
    |> get_recent_issues(count)
    |> Enum.map(fn issue ->
      %{"id" => id, "created_at" => created_at, "title" => title} = issue
      [ Integer.to_string(id), created_at, title ]
    end)
    |> print()
  end

  defp decode_response({ :ok, body }), do: body
  defp decode_response({ _, error }) do
    message = error["message"]
    IO.puts("Error fetching issues: #{message}")
    System.halt(2)
  end

  def sort_issues(issues) do
    issues
    |> Enum.sort(fn a, b -> a["created_at"] >= b["created_at"] end)
  end

  defp get_recent_issues(issues, count) do
    issues |> Enum.take(count)
  end

  def print(entries) do
    [ [ "#", "created_at", "title" ] | entries ]
    |> Issues.Table.create()
    |> Enum.each(&(IO.puts(&1)))
  end
end
