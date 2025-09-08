defmodule Modfig do
  defmacro __using__(_opts) do
    quote do
      require Playback3.Config
      alias Playback3.Config

      def config do
        actual = Application.get_env(:playback3, __MODULE__, [])

        if Application.fetch_env!(:playback3, :env) do
          temp = Application.get_env(:playback3_temp, __MODULE__, [])

          Keyword.merge(actual, temp)
        else
          actual
        end
      end
    end
  end

  defmacro fetch!(key) do
    quote do
      Playback3.Config.fetch!(__MODULE__, unquote(key))
    end
  end

  def fetch!(mod, key) do
    mod.config()
    |> Keyword.fetch(key)
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
