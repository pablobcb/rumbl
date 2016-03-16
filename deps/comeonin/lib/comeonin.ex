defmodule Comeonin do
  @moduledoc """
  Comeonin is a password hashing library that aims to make the
  secure validation of passwords as straightforward as possible.

  It also provides extensive documentation to help
  developers keep their apps secure.

  Comeonin supports bcrypt and pbkdf2_sha512.

  ## Use

  Most users will just need to use the `hashpwsalt`, `checkpw` and `dummy_checkpw`
  functions, using either the `Comeonin.Bcrypt` or `Comeonin.Pbkdf2` module.
  Naming conventions are the same for each algorithm.

  Import, or alias, the algorithm you want to use -- either `Comeonin.Bcrypt`
  or `Comeonin.Pbkdf2`.

  To hash a password with the default options:

    hash = hashpwsalt("difficult2guess")

  To check a password against the stored hash, use the `checkpw`
  function. This takes two arguments: the plaintext password and
  the stored hash.

  There is also a `dummy_checkpw` function, which takes no arguments
  and is to be used when the username cannot be found. It performs a hash,
  but then returns false. This can be used to make user enumeration more
  difficult. If an attacker already knows, or can guess, the username,
  this function will not be of any use, and so if you are going to use
  this function, it should be used with a policy of creating usernames
  that are not made public and are difficult to guess.

  See each module's documentation for more information about
  all the available options.

  ## Choosing an algorithm

  Bcrypt and pbkdf2_sha512 are both highly secure key derivation functions.
  They have no known vulnerabilities and their algorithms have been used
  and widely reviewed for at least 10 years. They are also designed
  to be `future-adaptable` (see the section below about speed / complexity
  for more details), and so we do not recommend one over the other.

  However, if your application needs to use a hashing function that has been
  recommended by a recognized standards body, then you will need to
  use pbkdf2_sha512, which has been recommended by NIST.

  ## Adjusting the speed / complexity of bcrypt and pbkdf2

  Both bcrypt and pbkdf2 are designed to be computationally intensive and
  slow. This limits the number of attempts an attacker can make within a
  certain time frame. In addition, they can be configured to run slower,
  which can help offset some of the hardware improvements made over time.

  It is recommended to make the key derivation function as slow as the
  user can tolerate. The actual recommended time for the function will vary
  depending on the nature of the application. According to the following [NIST
  recommendations](http://csrc.nist.gov/publications/nistpubs/800-132/nist-sp800-132.pdf),
  having the function take several seconds might be acceptable if the user
  only has to login once every session. However, if an application requires
  the user to login several times an hour, it would probably be better to
  limit the hashing function to about 250 milliseconds.

  To help you decide how slow to make the function, this module provides
  convenience timing functions for bcrypt and pbkdf2.

  ## Further information

  Visit our [wiki](https://github.com/elixircnx/comeonin/wiki)
  for links to further information about these and related issues.

  """

  @doc """
  A function to help the developer decide how many log_rounds to use
  when using bcrypt.

  The number of log_rounds can be increased to make the bcrypt hashing
  function more complex, and slower. The minimum number is 4 and the maximum is 31.
  The default is 12, but this is not necessarily the recommended number.
  The ideal number of log_rounds will depend on the nature of your application
  and the hardware being used.

  The `bcrypt_log_rounds` value can be set in the config file. See the
  documentation for `Comeonin.Config` for more details.
  """
  def time_bcrypt(log_rounds \\ 12) do
    salt = Comeonin.Bcrypt.gen_salt(log_rounds)
    {time, _} = :timer.tc(Comeonin.Bcrypt, :hashpass, ["password", salt])
    Mix.shell.info "Log rounds: #{log_rounds}, Time: #{div(time, 1000)} ms"
  end

  @doc """
  A function to help the developer decide how many rounds to use
  when using pbkdf2.

  The number of rounds can be increased to make the pbkdf2 hashing function slower.
  The maximum number of rounds is 4294967295. The default is 100_000, but this
  is not necessarily the recommended number. The ideal number of log_rounds
  will depend on the nature of your application and the hardware being used.

  The `pbkdf2_rounds` value can be set in the config file. See the
  documentation for `Comeonin.Config` for more details.
  """
  def time_pbkdf2(rounds \\ 100_000) do
    salt = Comeonin.Pbkdf2.gen_salt
    {time, _} = :timer.tc(Comeonin.Pbkdf2, :hashpass, ["password", salt, rounds])
    Mix.shell.info "Rounds: #{rounds}, Time: #{div(time, 1000)} ms"
  end
end
