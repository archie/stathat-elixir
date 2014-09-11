defmodule Stathat do
  use Application

  @moduledoc """
  Send data to stathat.com - a stat tracking service.

  ```
  # Examples
  Stathat.ez_count("messages sent", 1)

  Stathat.ez_value("request time", 92.194)
  ```
  """

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    ezkey = Application.get_env(:statman, :ezkey, :missing_ezkey)

    children = [
      worker(StathatServer, [ezkey])
    ]

    opts = [strategy: :one_for_one, name: Stathat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  ### API
  def ez_count(stat, count) do
    GenServer.cast(Stathat, {:ez_count, stat, count})
  end

  def ez_value(stat, value) do
    GenServer.cast(Stathat, {:ez_value, stat, value})
  end

  def cl_count(userkey, statkey, count) do
    GenServer.cast(Stathat, {:cl_count, userkey, statkey, count})
  end

  def cl_value(userkey, statkey, value) do
    GenServer.cast(Stathat, {:cl_value, userkey, statkey, value})
  end
end
