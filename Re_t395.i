von_karman_const = 0.41

H = 1 #halfwidth of the channel
L = 150

Re_t = 395
Re = 13700

#rho = 1
#mu = 1
#nu = 1
#momentum_force = ${fparse Re_t * Re_t * nu * nu / H / H / H}  #needs periodic BC's

rho = 1
bulk_u = 1
mu = ${fparse rho * bulk_u * 2 * H / Re}

advected_interp_method='upwind'
velocity_interp_method='rc'

[GlobalParams]
  two_term_boundary_expansion = true
[]

[Mesh]
  [gen]
    type = CartesianMeshGenerator
    dim = 2
    dx = '${L}'
    dy = '0.9 0.1'
    ix = '200'
    iy = '9  1'
  []
[]

#[Mesh]
#  [gen]
#    type = GeneratedMeshGenerator
#    dim = 2
#    xmin = 0
#    xmax = ${L}
#    ymin = 0
#    ymax = ${H}  #Channel is 2H tall, half channel H for symmetry
#    nx = 40
#    ny = 3
#  []
#[]


[Problem]
  fv_bcs_integrity_check = false
[]

[Variables]
  [u]
    type = INSFVVelocityVariable
    initial_condition = 1
  []
  [v]
    type = INSFVVelocityVariable
    initial_condition = 1
  []
  [pressure]
    type = INSFVPressureVariable
  []
[]

[AuxVariables]
  [mixing_len]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
  [wall_shear_stress]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
  [wall_yplus]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
[]

#[UserObjects]
#  [./inlet_solution]
#    type = SolutionUserObject
#    mesh = Re_t180_out.e
#    system_variables = 'u v'
#    translation = '${fparse -0.8 * L} 0 0'
#    timestep = LATEST
#  [../]
#[]

#[Functions]
#  [./set_inlet_u]
#    type = SolutionFunction
#    solution = inlet_solution
#    from_variable = u
#  [../]
#  [./set_inlet_v]
#    type = SolutionFunction
#    solution = inlet_solution
#    from_variable = v
#  [../]
#[]


[FVKernels]
  [mass]
    type = INSFVMassAdvection
    variable = pressure
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    vel = 'velocity'
    pressure = pressure
    u = u
    v = v
    mu = ${mu}
    rho = ${rho}
  []

  [u_advection]
    type = INSFVMomentumAdvection
    variable = u
    advected_quantity = 'rhou'
    vel = 'velocity'
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    pressure = pressure
    u = u
    v = v
    mu = ${mu}
    rho = ${rho}
  []
  [u_viscosity]
    type = FVDiffusion
    variable = u
    coeff = ${mu}
  []
  [u_viscosity_rans]
    type = INSFVMixingLengthReynoldsStress
    variable = u
    rho = ${rho}
    mixing_length = mixing_len
    momentum_component = 'x'
    u = u
    v = v
  []
  [u_pressure]
    type = INSFVMomentumPressure
    variable = u
    momentum_component = 'x'
    p = pressure
  []
  #[u_force]
  #  type = FVBodyForce
  #  variable = u
  #  function = function_force
  #[]

  [v_advection]
    type = INSFVMomentumAdvection
    variable = v
    advected_quantity = 'rhov'
    vel = 'velocity'
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    pressure = pressure
    u = u
    v = v
    mu = ${mu}
    rho = ${rho}
  []
  [v_viscosity]
    type = FVDiffusion
    variable = v
    coeff = ${mu}
  []
  [v_viscosity_rans]
    type = INSFVMixingLengthReynoldsStress
    variable = v
    rho = ${rho}
    mixing_length = mixing_len
    momentum_component = 'y'
    u = u
    v = v
  []
  [v_pressure]
    type = INSFVMomentumPressure
    variable = v
    momentum_component = 'y'
    p = pressure
  []
[]

[AuxKernels]
  [mixing_len]
    type = WallDistanceMixingLengthAux
    walls = 'top'
    variable = mixing_len
    execute_on = 'initial'
    von_karman_const = ${von_karman_const}
  []
  [wall_shear_stress]
    type = WallFunctionWallShearStressAux
    variable = wall_shear_stress
    walls = 'top'
    u = u
    v = v
    mu = ${mu}
    rho = ${rho}
  []
  [wall_yplus]
    type = WallFunctionYPlusAux
    variable = wall_yplus
    walls = 'top'
    u = u
    v = v
    mu = ${mu}
    rho = ${rho}
  []
[]

[FVBCs]

[inlet-u]
  type = INSFVInletVelocityBC
  boundary = 'left'
  variable = u
  function = '1'
[]
[inlet-v]
  type = INSFVInletVelocityBC
  boundary = 'left'
  variable = v
  function = '0'
[]
#[inlet-u]
#  type = INSFVInletVelocityBC
#  boundary = 'left'
#  variable = u
#  function = 'set_inlet_u'
#[]
#[inlet-v]
#  type = INSFVInletVelocityBC
#  boundary = 'left'
#  variable = v
#  function = 'set_inlet_v'
#[]


  [no-slip-wall-u]
    type = INSFVNoSlipWallBC
    boundary = 'top'
    variable = u
    function = 0
  []
  [no-slip-wall-v]
    type = INSFVNoSlipWallBC
    boundary = 'top'
    variable = v
    function = 0
  []
  [wall-u]
    type = INSFVWallFunctionBC
    variable = u
    boundary = 'top'
    u = u
    v = v
    mu = ${mu}
    rho = ${rho}
    momentum_component = x
  []
  [wall-v]
    type = INSFVWallFunctionBC
    variable = v
    boundary = 'top'
    u = u
    v = v
    mu = ${mu}
    rho = ${rho}
    momentum_component = y
  []

  [sym-u]
    type = INSFVSymmetryVelocityBC
    boundary = 'bottom'
    variable = u
    u = u
    v = v
    mu = ${mu}
    momentum_component = x
  []
  [sym-v]
    type = INSFVSymmetryVelocityBC
    boundary = 'bottom'
    variable = v
    u = u
    v = v
    mu = ${mu}
    momentum_component = y
  []
  [outlet_p]
    type = INSFVOutletPressureBC
    boundary = 'right'
    variable = pressure
    function = '0'
  []
[]

#[Functions]
#  [./function_force]
#    type = ConstantFunction
#    value = momentum_force
#  [../]
#[]

[Materials]
  [ins_fv]
    type = INSFVMaterial
    u = 'u'
    v = 'v'
    pressure = 'pressure'
    rho = ${rho}
  []
[]

[Executioner]
  type = Steady
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_pc_type -sub_pc_factor_shift_type'
  petsc_options_value = 'asm      200                lu           NONZERO'
  line_search = 'none'
  nl_rel_tol = 1e-12
[]

[Outputs]
  exodus = true
  [restart_out]        # creates input_other.e
   type = Exodus
[]
[]
