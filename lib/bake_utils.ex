defmodule BakeUtils do
  @working_dir File.cwd! <> "/_bake"
  @bake_home "~/.bake"
  @daemon_port 10001

  require Logger

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

  def auth_info(config \\ BakeUtils.Cli.Config.read) do
    #Logger.debug "Config: #{inspect config}"
    if key = config[:key] do
      [key: key]
    else
      Bake.Shell.error "No authorized user found. Run 'bake user auth'"
    end
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
    arch
    |> String.strip
    |> String.downcase
  end

  def host_platform do
    {platform, 0} = System.cmd("uname", ["-s"])
    platform
    |> String.strip
    |> String.downcase
  end

  defp platform(<<"Darwin", _tail :: binary>>) do
    {ver, 0} = System.cmd("sw_vers", ["-productVersion"])
    ver =
      ver
      |> String.strip
     "Mac OS #{ver}"
  end

  defp platform(_), do: :unknown

  def local_user(config) do
    case Keyword.fetch(config, :username) do
      {:ok, username} ->
        username
      :error ->
        raise Bake.Error, message: "No user authorised on the local machine. Run `bake user auth` " <>
                  "or create a new user with `bake user register`"
    end
  end
end
