/*
 * generated by Xtext 2.20.0
 */
package org.xtext.thphr16


/**
 * Initialization support for running Xtext languages without Equinox extension registry.
 */
class MathCompilerStandaloneSetup extends MathCompilerStandaloneSetupGenerated {

	def static void doSetup() {
		new MathCompilerStandaloneSetup().createInjectorAndDoEMFRegistration()
	}
}
