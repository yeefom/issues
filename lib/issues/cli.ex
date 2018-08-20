defmodule Issues.Cli do
  @default_count 4

  def run(argv) do
   parse_args(argv)
  end

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [ help: :boolean ], aliases: [ h: :help ])
    |> elem(1)
    |> _parse_args
  end

  defp _parse_args([ user, project, count ]), do: { user, project, String.to_integer(count) }
  defp _parse_args([ user, project ]), do: { user, project, @default_count }
  defp _parse_args(_), do: :help
end
