defmodule StathatServer do
  use GenServer

  @stathaturl "http://api.stathat.com/"

  def start(key) do
    GenServer.start(__MODULE__, [ezkey: key], name: Stathat)
  end

  def start_link(key) do
    GenServer.start_link(__MODULE__, [ezkey: key], name: Stathat)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:ez_count, stat, count}, state) do
    url = build_url("ez", [{"ezkey", state[:ezkey]}, {"stat", stat}, {"count", to_s(count)}])
    send_value(url)
    {:noreply, state}
  end
  def handle_cast({:ez_value, stat, value}, state) do
    url = build_url("ez", [{"ezkey", state[:ezkey]}, {"stat", stat}, {"value", to_s(value)}])
    send_value(url)
    {:noreply, state}
  end
  # def handle_cast({:cl_count, userkey, statkey, count}, state) do
  #   url = build_url("ez", [{"ukey", userkey}, {"key", statkey}, {"count", count}])
  #   send_value(url)
  #   {:noreply, state}
  # end
  # def handle_cast({:cl_value, userkey, statkey, value}, state) do
  #   url = build_url("ez", [{"ukey", userkey}, {"key", statkey}, {"value", count}])
  #   send_value(url)
  #   {:noreply, state}
  # end
  def handle_cast(_req, state) do
    {:noreply, state}
  end

  defp send_value(url) do
    :httpc.request(:get, {url, []}, [], [sync: false])
  end

  defp to_s(number) when is_float(number),   do: Float.to_string(number)
  defp to_s(number) when is_integer(number), do: Integer.to_string(number)

  defp build_url(url, []), do: url
  defp build_url(url, args) do
    args = Stream.map(args, fn({k,v}) -> k <> "=" <> v end) |> Enum.join "&"
    @stathaturl <> url <> "?" <> args |> URI.encode |> :erlang.binary_to_list
  end
end
