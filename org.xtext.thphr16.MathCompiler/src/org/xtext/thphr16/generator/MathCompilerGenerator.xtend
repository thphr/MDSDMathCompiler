/*
 * generated by Xtext 2.20.0
 */
package org.xtext.thphr16.generator

import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import org.xtext.thphr16.mathCompiler.Div
import org.xtext.thphr16.mathCompiler.Expression
import org.xtext.thphr16.mathCompiler.ExternalDeclaration
import org.xtext.thphr16.mathCompiler.Let
import org.xtext.thphr16.mathCompiler.MathExp
import org.xtext.thphr16.mathCompiler.Minus
import org.xtext.thphr16.mathCompiler.Mult
import org.xtext.thphr16.mathCompiler.Num
import org.xtext.thphr16.mathCompiler.Plus
import org.xtext.thphr16.mathCompiler.ProgramCall
import org.xtext.thphr16.mathCompiler.Var
import org.xtext.thphr16.mathCompiler.ExtRef

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class MathCompilerGenerator extends AbstractGenerator {

	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val programCall = resource.allContents.filter(ProgramCall).next
		fsa.generateFile("MathProgram.java",programCall.compile)

	}
	
	def CharSequence compile(ProgramCall programCall){
		'''
		import java.util.*;
		
		public class MathProgram{
			public static interface Externals{
				�FOR external : programCall.declaration.filter(ExternalDeclaration)�
				public int �external.name�(�FOR parameter : external.parameter SEPARATOR ','� �parameter� �ENDFOR�);
				�ENDFOR�
			}
			
			private Externals externals;
			
			public MathProgram(Externals externals){
				this.externals = externals;
			}
			
			public void compute() {
				�FOR mathexp : programCall.declaration.filter(MathExp)� 
				System.out.println("�mathexp.name�" + �mathexp.compileExp�);
				�ENDFOR�
			}
			
		}
		
		'''
	}

	//
	// Display function: show complete syntax tree
	// Note: written according to illegal left-recursive grammar, requires fix
	//
	def dispatch String compileExp(MathExp math) {
		math.exp.compileExp
	}

	def dispatch String compileExp(Expression exp) {
		"(" + switch exp {
			Plus:
				exp.left.compileExp + "+" + exp.right.compileExp
			Minus:
				exp.left.compileExp + "-" + exp.right.compileExp
			Mult:
				exp.left.compileExp + "*" + exp.right.compileExp
			Div:
				exp.left.compileExp + "/" + exp.right.compileExp
			Num:
				Integer.toString(exp.value)
			Var:
				exp.id
			Let: '''let �exp.id� = �exp.binding.compileExp� in �exp.body.compileExp� end'''
			default:
				throw new Error("Invalid expression")
		} + ")"
	}
	
	def dispatch String compileExp(ExtRef ref){
		'''externals.�ref.external.name�(�FOR argument : ref.arguments SEPARATOR ','� �argument� �ENDFOR�)'''
	}
}
