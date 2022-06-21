/// A C++ type declaration.
struct CXXTypeDecl {

  /// The name of the type.
  var name: String

  /// The public stored properties.
  var publicFields: [String] = []

  /// The private stored properties.
  var privateFields: [String] = []

  /// The public constructors.
  var publicCtors: [String] = []

  /// The private constructors.
  var privateCtors: [String] = []

  /// The public destructor, if any.
  var dtor: String?

  /// The public methods, properties, and subscripts.
  var methods: [String] = []

  /// Writes the C++ textual representation of `self` using `printer` indentation level.
  func write<Target: TextOutputStream>(
    into output: inout Target,
    using printer: inout IndentPrinter
  ) {
    // Emit the definition.
    printer.write("class \(name) {", to: &output)

    // Emit public fields.
    if !publicFields.isEmpty {
      printer.write("public:", to: &output)
      printer.indentationLevel += 1
      for field in publicFields {
        printer.write(field, to: &output)
      }
      printer.indentationLevel -= 1
    }

    // Emit private fields.
    if !privateFields.isEmpty {
      printer.write("private:", to: &output)
      printer.indentationLevel += 1
      for field in privateFields {
        printer.write(field, to: &output)
      }
      printer.indentationLevel -= 1
    }

    // Emit the public API.
    printer.write("public:", to: &output)
    printer.indentationLevel += 1

    // Disable the default constructor.
    printer.write("\(name)() = delete;", to: &output)

    // Disable the move constructor, unless the type is publicly sinkable.
    // TODO: Determine if conformance to Sinkable is external.
    printer.write("\(name)(\(name)&&) = delete;", to: &output)
    printer.write("\(name)& operator=(\(name)&&) = delete;", to: &output)

    // Disable implicit copying.
    printer.write("\(name)(\(name) const&) = delete;", to: &output)
    printer.write("\(name)& operator=(\(name) const&) = delete;", to: &output)

    // Emit public constructors.
    for ctor in publicCtors {
      printer.write(ctor, to: &output)
    }

    // Emit other public members.
    if let member = dtor {
      printer.write(member, to: &output)
    }
    for member in methods {
      printer.write(member, to: &output)
    }
    printer.indentationLevel -= 1

    // Emit private constructors.
    if !privateCtors.isEmpty {
      printer.write("private:", to: &output)
      printer.indentationLevel += 1
      for ctor in privateCtors {
        printer.write(ctor, to: &output)
      }
      printer.indentationLevel -= 1
    }

    printer.write("};", to: &output)
  }

}