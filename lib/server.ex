defmodule Echo.Server do
  def square(x) do
    x * x
  end

  def penultimate(list) do
    case list do
      [] -> nil
      [_] -> nil
      [h, _] -> h
      [_ | t] -> penultimate(t)
    end
  end

  def start(port) do
    tcp_options = [:list, {:packet, 0}, {:active, false}]
    {:ok, socket} = :gen_tcp.listen(port, tcp_options)
    listen(socket)
  end

  defp listen(socket) do
    {:ok, conn} = :gen_tcp.accept(socket)
    spawn(fn -> recv(conn) end)
    listen(socket)
  end

  defp recv(conn) do
    case :gen_tcp.recv(conn, 0) do
      {:ok, data} ->
        :gen_tcp.send(conn, square(data))
        :gen_tcp.send(conn, penultimate(data))
        recv(conn)

      {:error, :closed} ->
        :ok
    end
  end
end
