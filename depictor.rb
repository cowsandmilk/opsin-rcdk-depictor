require 'rubygems'
if ENV['CLASSPATH'].nil? ||  ENV['CLASSPATH'] == ''
    ENV['CLASSPATH'] = 'opsin-big-0.1.0.jar'
else
    ENV['CLASSPATH'] << File::PATH_SEPARATOR 
    ENV['CLASSPATH'] << 'opsin-big-0.1.0.jar'
end
gem 'rcdk'
require 'rcdk'

require 'rcdk/util'

# A simple IUPAC->2-D structure convertor.
jrequire 'java.io.StringBufferInputStream'
jrequire 'uk.ac.cam.ch.wwmm.opsin.NameToStructure'
jrequire 'org.openscience.cdk.io.CMLReader'
jrequire 'org.openscience.cdk.ChemFile'
class Depictor
  include Java::Io
  include Uk::Ac::Cam::Ch::Wwmm::Opsin
  include Org::Openscience::Cdk::Io
  include Org::Openscience::Cdk

  def initialize
    @nts = NameToStructure.getInstance
    @cml_reader = CMLReader.new
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
    string_stream = StringBufferInputStream.new(cml.toXML)

    @cml_reader.setReader(string_stream)

    chem_file = @cml_reader.read(ChemFile.new)
    molecule = chem_file.getChemSequence(0).getChemModel(0).getMoleculeSet.getMolecule(0)

    molecule = RCDK::Util::XY.coordinate_molecule(molecule)

    RCDK::Util::Lang.get_molfile(molecule)
  end
end
