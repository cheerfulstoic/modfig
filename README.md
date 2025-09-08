# Modfig

**TODO: Add description**

## Usage

Example:

```elixir
def MyApp.Accounts do
  use Playback3.Config

  def fetch_user(id) do
    if Modfig.fetch!(:allow_user_fetching?) do
      ...
    end
  end
```

TODO: Test example

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `modfig` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:modfig, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/modfig>.
