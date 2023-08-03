defmodule Protobuf.TypeCheck do
  @moduledoc false

  alias Protobuf.MessageProps
  alias Protobuf.TypeCheck.Wire.Types
  alias Protobuf.TypeCheck.Wire.Types, as: WireTypes

  def default_overrides() do
    Code.ensure_loaded?(Types)
    Code.ensure_loaded?(WireTypes)
    [{&Types.wire_type/0, &WireTypes.wire_type/0}]
  end

  def def_t_typespec(%MessageProps{enum?: true} = props) do
    if Code.ensure_loaded?(TypeCheck) do
      import Kernel, except: [@: 1]
      quote do
        use TypeCheck, overrides: Protobuf.TypeCheck.default_overrides()

        @type! t() :: unquote(Protobuf.DSL.Typespecs.quoted_enum_typespec(props))
      end
    end
  end

  def def_t_typespec(%MessageProps{} = props) do
    if Code.ensure_loaded?(TypeCheck) do
      import Kernel, except: [@: 1]
      quote do
        use TypeCheck, overrides: Protobuf.TypeCheck.default_overrides()

        @type! t() :: unquote(Protobuf.DSL.Typespecs.quoted_message_typespec(props))
      end
    end
  end

  def def_t_typespec(_props) do
    nil
  end
end
