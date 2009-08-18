require 'rubygems'
require_gem 'rcdk'
require 'rcdk'

Java::Classpath.add('opsin-big-0.1.0.jar')

require 'util'

# A simple IUPAC->2-D structure convertor.
class Depictor
  @@StringReader = import 'java.io.StringReader'
  @@NameToStructure = import 'uk.ac.cam.ch.wwmm.opsin.NameToStructure'
  @@CMLReader = import 'org.openscience.cdk.io.CMLReader'
  @@ChemFile = import 'org.openscience.cdk.ChemFile'

  def initialize
    @nts = @@NameToStructure.new
    @cml_reader = @@CMLReader.new
  end

  # Writes a <tt>width</tt> by <tt>height</tt> PNG to
  # <tt>filename</tt> for the molecule described by
  # <tt>iupac_name</tt>.
  def depict_png(iupac_name, filename, width, height)
    cml = @nts.parseToCML(iupac_name)

    throw("Can't parse name: #{iupac_name}") unless cml

    molfile = cml_to_molfile(cml)

    RCDK::Util::Image.molfile_to_png(molfile, filename, width, height)
  end

  private

  def cml_to_molfile(cml)
    string_reader = StringReader.new(cml.toXML)

    @cml_reader.setReader(string_reader)

    chem_file = @cml_reader.read(@@ChemFile.new)
    molecule = chem_file.getChemSequence(0).getChemModel(0).getSetOfMolecules.getMolecule(0)

    molecule = RCDK::Util::XY.coordinate_molecule(molecule)

    RCDK::Util::Lang.get_molfile(molecule)
  end
end
