/*
 * generated by Xtext 2.20.0
 */
package org.xtext.thphr16.ide

import com.google.inject.Guice
import org.eclipse.xtext.util.Modules2
import org.xtext.thphr16.MathCompilerRuntimeModule
import org.xtext.thphr16.MathCompilerStandaloneSetup

/**
 * Initialization support for running Xtext languages as language servers.
 */
class MathCompilerIdeSetup extends MathCompilerStandaloneSetup {

	override createInjector() {
		Guice.createInjector(Modules2.mixin(new MathCompilerRuntimeModule, new MathCompilerIdeModule))
	}
	
}
