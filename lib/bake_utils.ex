defmodule BakeUtils do
  @working_dir File.cwd! <> "/_bake"
  @bake_home "~/.bake"
  @daemon_port 10001

  def create_working_dir do
    File.mkdir @working_dir
  end

  def working_dir do
    @working_dir
  end

  def bake_home do
    Path.expand(System.get_env("BAKE_HOME") || @bake_home)
  end

  def daemon_pid do
    bake_home <> "/daemon.pid"
  end

  def oven_dir do
    bake_home <> "/oven"
  end

  def daemon_running? do
    case File.read(BakeUtils.daemon_pid) do
      {:ok, pid} ->
        :os.cmd(String.to_char_list("kill -0 #{pid}")) == []
      _ -> false
    end
  end

  def daemon_port do
    System.get_env("BAKE_HOME") || @daemon_port
  end

  def host_arch do
    {arch, 0} = System.cmd("uname", ["-m"])
    arch |> String.strip
  end
end
