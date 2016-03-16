defmodule Comeonin.Config do
  @moduledoc """
  This module provides an abstraction layer for configuration.
  The following are valid configuration items.

  | name               | type    | default |
  | :----------------- | :------ | ------: |
  | bcrypt_log_rounds  | integer | 12      |
  | pbkdf2_rounds      | integer | 100_000 |

  `bcrypt_log_rounds` and `pbkdf2_rounds` can be used to adjust the
  complexity, and time taken, of the password hashing calculation.
  Please read the documentation for the main Comeonin module,
  which explains why the default values are not always the best
  values to use.

  ## Examples

  The simplest way to change the default values would be to add
  the following to the `config.exs` file in your project.

      config :comeonin,
        bcrypt_log_rounds: 14,
        pbkdf2_rounds: 120_000,

  If you want to have different values when developing and testing,
  you can create separate files for each environment: `dev.exs`,
  `prod.exs` and `test.exs`, and add the configuration values to
  the respective file.

  For example, in `test.exs` and `dev.exs`:

      use Mix.Config

      config :comeonin,
        bcrypt_log_rounds: 4,
        pbkdf2_rounds: 1_000

  And in `prod.exs`:

      use Mix.Config

      config :comeonin,
        bcrypt_log_rounds: 14,
        pbkdf2_rounds: 120_000

  If you use separate files for the different environments, remember
  to add, or uncomment, the line `import_config "#\{Mix.env\}.exs"`
  to the `config.exs` file.
  """

  @doc """
  The number of log rounds the bcrypt function uses. The default
  value of 12 means that 2^12 rounds are used.
  """
  def bcrypt_log_rounds do
    rounds = Application.get_env(:comeonin, :bcrypt_log_rounds)
    if rounds in 4..31, do: rounds, else: 12
  end

  @doc """
  The number of rounds the pbkdf2_sha512 function uses.
  """
  def pbkdf2_rounds do
    Application.get_env(:comeonin, :pbkdf2_rounds, 100_000)
  end

end
