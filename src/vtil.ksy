meta:
  id: vtil
  file-extension: vtil
  endian: le
enums:
  architecture_identifier:
    0: amd64
    1: arm64
    2: virtual
seq:
  - id: header
    type: header
  - id: entrypoint
    type: entrypoint
  - id: routine_convention
    type: routine_convention
  - id: subroutine_convention
    type: subroutine_convention
  - id: spec_subroutine_conventions
    type: spec_subroutine_conventions
  - id: explored_blocks
    type: explored_blocks
types:
  register_desc:
    seq:
      - id: flags
        type: u8
      - id: combined_id
        type: u8
      - id: bit_count
        type: s4
      - id: bit_offset
        type: s4
  immediate_desc:
    seq:
      - id: imm
        type: u8
      - id: bitcount
        type: u4
  operand:
    seq:
      - id: sp_index
        type: u4
      - id: operand
        type:
          switch-on: sp_index
          cases:
            0: immediate_desc
            1: register_desc
  instruction:
    seq:
      - id: name_len
        type: u4
      - id: name
        type: str
        size: name_len
        encoding: UTF-8
      - id: operands_amount
        type: u4
      - id: operands
        type: operand
        repeat: expr
        repeat-expr: operands_amount
      - id: vip
        type: u8
      - id: sp_offset
        type: s8
      - id: sp_index
        type: u4
      - id: sp_reset
        type: u1
  basic_block:
    seq:
      - id: entry_vip
        type: u8
      - id: sp_offset
        type: s8
      - id: sp_index
        type: u4
      - id: last_temporary_index
        type: u4
      - id: instruction_amount
        type: u4
      - id: instructions
        type: instruction
        repeat: expr
        repeat-expr: instruction_amount
      - id: prev_vip_amount
        type: u4
      - id: prev_vip
        type: u8
        repeat: expr
        repeat-expr: prev_vip_amount
      - id: next_vip_amount
        type: u4
      - id: next_vip
        type: u8
        repeat: expr
        repeat-expr: next_vip_amount
  spec_subroutine_convention:
    seq:
      - id: vip
        type: u8
      - id: volatile_registers_count
        type: u4
      - id: volatile_registers
        type: register_desc
        repeat: expr
        repeat-expr: volatile_registers_count
      - id: param_registers_count
        type: u4
      - id: param_registers
        type: register_desc
        repeat: expr
        repeat-expr: param_registers_count
      - id: retval_registers_count
        type: u4
      - id: retval_registers
        type: register_desc
        repeat: expr
        repeat-expr: retval_registers_count
      - id: frame_register
        type: register_desc
      - id: shadow_space
        type: u8
      - id: purge_stack
        type: u1 # or use b1 but needs b7 pad
  header:
    seq:
      - id: magic1
        type: u4
      - id: arch_id
        type: u1
        enum: architecture_identifier
      - id: zero_pad
        type: u1
      - id: magic2
        type: u2
  entrypoint:
    seq:
      - id: entry_vip
        type: u8
  routine_convention:
    seq:
      - id: volatile_registers_count
        type: u4
      - id: volatile_registers
        type: register_desc
        repeat: expr
        repeat-expr: volatile_registers_count
      - id: param_registers_count
        type: u4
      - id: param_registers
        type: register_desc
        repeat: expr
        repeat-expr: param_registers_count
      - id: retval_registers_count
        type: u4
      - id: retval_registers
        type: register_desc
        repeat: expr
        repeat-expr: retval_registers_count
      - id: frame_register
        type: register_desc
      - id: shadow_space
        type: u8
      - id: purge_stack
        type: u1 # or use b1 but needs b7 pad
  subroutine_convention:
    seq:
      - id: volatile_registers_count
        type: u4
      - id: volatile_registers
        type: register_desc
        repeat: expr
        repeat-expr: volatile_registers_count
      - id: param_registers_count
        type: u4
      - id: param_registers
        type: register_desc
        repeat: expr
        repeat-expr: param_registers_count
      - id: retval_registers_count
        type: u4
      - id: retval_registers
        type: register_desc
        repeat: expr
        repeat-expr: retval_registers_count
      - id: frame_register
        type: register_desc
      - id: shadow_space
        type: u8
      - id: purge_stack
        type: u1 # or use b1 but needs b7 pad
  spec_subroutine_conventions:
    seq:
      - id: spec_subroutine_conventions_amount
        type: u4
      - id: spec_subroutine_convention
        type: subroutine_convention
        repeat: expr
        repeat-expr: spec_subroutine_conventions_amount
  explored_blocks:
    seq:
      - id: basic_blocks_amount
        type: u4
      - id: basic_blocks
        type: basic_block
        repeat: expr
        repeat-expr: basic_blocks_amount