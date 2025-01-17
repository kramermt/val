/// A module declaration.
public struct ModuleDecl: SingleEntityDecl, LexicalScope {

  /// The name of the module.
  public let name: String

  /// The source files in the module.
  public private(set) var sources: [NodeID<TopLevelDeclSet>] = []

  public init(name: String) {
    self.name = name
  }

  public var origin: SourceRange? { nil }

  /// Adds the given source file to our list of sources.
  public mutating func addSourceFile(_ s: NodeID<TopLevelDeclSet>) {
    sources.append(s)
  }

}
