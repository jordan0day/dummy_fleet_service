defmodule DummyFleetService.FakeData do

  # Unit fields
  # * `name`         - unique identifier of entity.
  # * `options`      - list of UnitOption entities.
  # * `desiredState` - state the user wishes the unit to be in ("inactive", "loaded", or "launched").
  # * `currentState` - state the unit is currently in (same possible values as desiredState).
  # * `machineID`    - ID of machine to which the unit is scheduled.
  @spec get_unit :: Map.t
  def get_unit() do
    options = Stream.repeatedly(fn -> get_unit_option end)
              |> Enum.take(:random.uniform(5) - 1)
    %{
      name: Faker.App.name,
      options: options,
      desiredState: get_unit_state,
      currentState: get_unit_state,
      machineID: get_machine_id
    }
  end

  # Unit Option fields
  # * `name`    - name of option (e.g. "BindsTo", "After", "ExecStart").
  # * `section` - name of section that contains the option (e.g. "Unit", "Service", "Socket").
  # * `value`   - value of option (e.g. "/usr/bin/docker run busybox /bin/sleep 1000").
  @unit_option_names ["BindsTo", "After", "ExecStart"]
  @unit_option_sections ["Unit", "Service", "Socket"]
  def get_unit_option() do

    %{
      name: get_random(@unit_option_names),
      section: get_random(@unit_option_sections),
      value: Faker.Lorem.sentence()
    }
  end

  # Unit state fields
  # * `name`               - unique identifier of entity.
  # * `hash`               - SHA1 hash of underlying unit file.
  # * `machineID`          - ID of machine from which this state originated.
  # * `systemdLoadState`   - load state as reported by systemd.
  # * `systemdActiveState` - active state as reported by systemd.
  # * `systemdSubState`    - sub state as reported by systemd.
  def get_unit_state() do
    %{
      name: Faker.App.name(),
      hash: "abc123",
      machineID: get_machine_id(),
      systemdLoadState: "Loaded",
      systemdActiveState: "Active",
      systemdSubState: "ok"
    }
  end

  # Machine fields
  # * `id`        - unique identifier of Machine entity.
  # * `primaryIP` - IP address that should be used to communicate with this host.
  # * `metadata`  - dictionary of key-value data published by the machine.
  def get_machine() do
    %{
      id: get_machine_id(),
      primaryIP: Faker.Internet.ip_v4_address(),
      metadata: %{}
    }
  end

  defp get_machine_id() do
    Faker.Code.isbn13()
  end

  defp get_random(options) do
    index = :random.uniform(length(options)) - 1
    Enum.at(options, index)
  end
end