#include "mixing_length_validationApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
mixing_length_validationApp::validParams()
{
  InputParameters params = MooseApp::validParams();

  // Do not use legacy material output, i.e., output properties on INITIAL as well as TIMESTEP_END
  params.set<bool>("use_legacy_material_output") = false;

  return params;
}

mixing_length_validationApp::mixing_length_validationApp(InputParameters parameters) : MooseApp(parameters)
{
  mixing_length_validationApp::registerAll(_factory, _action_factory, _syntax);
}

mixing_length_validationApp::~mixing_length_validationApp() {}

void
mixing_length_validationApp::registerAll(Factory & f, ActionFactory & af, Syntax & syntax)
{
  ModulesApp::registerAll(f, af, syntax);
  Registry::registerObjectsTo(f, {"mixing_length_validationApp"});
  Registry::registerActionsTo(af, {"mixing_length_validationApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
mixing_length_validationApp::registerApps()
{
  registerApp(mixing_length_validationApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
mixing_length_validationApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  mixing_length_validationApp::registerAll(f, af, s);
}
extern "C" void
mixing_length_validationApp__registerApps()
{
  mixing_length_validationApp::registerApps();
}
