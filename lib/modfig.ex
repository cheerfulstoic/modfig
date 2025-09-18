defmodule Modfig do
  defmacro __using__(opts) do
    app =
      Keyword.get_lazy(opts, :app, fn ->
        Application.fetch_env!(:modfig, :app)
      end)

    quote do
      require Modfig

      def config do
        actual = Application.get_env(unquote(app), __MODULE__, [])

        temp = Application.get_env(:"#{unquote(app)}_temp", __MODULE__, [])

        Keyword.merge(actual, temp)
      end
    end
  end

  defmacro fetch!(key) do
    quote do
      Modfig.fetch!(__MODULE__, unquote(key))
    end
  end

  def fetch!(mod, key) do
    mod.config()
    |> Keyword.fetch(key)
    |> dbg()
    |> case do
      {:ok, value} ->
        value

      :error ->
        raise KeyError, """
        No config key `#{inspect(key)}` exists for module #{inspect(mod)}.
        """
    end
  end

  # Is defined as a macro so that we can call `on_exit`, which is a callback defined on each test module
  defmacro put_env_temp(mod, values) do
    quote do
      Application.put_env(:playback3_temp, unquote(mod), unquote(values))

      # Give a reference so that only one `on_exit` is run for each module
      on_exit("#{__MODULE__}-#{unquote(mod)}", fn ->
        Application.delete_env(:playback3_temp, unquote(mod))
      end)
    end
  end
end
