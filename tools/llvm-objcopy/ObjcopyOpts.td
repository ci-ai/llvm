include "llvm/Option/OptParser.td"

multiclass Eq<string name> {
  def NAME: Separate<["--", "-"], name>;
  def NAME # _eq: Joined<["--", "-"], name # "=">, Alias<!cast<Separate>(NAME)>;
}

def help : Flag<["-", "--"], "help">;
defm binary_architecture : Eq<"binary-architecture">,
                           HelpText<"Used when transforming an architecture-less format (such as binary) to another format">;
def B : JoinedOrSeparate<["-"], "B">,
        Alias<binary_architecture>;
defm input_target : Eq<"input-target">,
                    HelpText<"Format of the input file">,
                    Values<"binary">;
def I : JoinedOrSeparate<[ "-" ], "I">, Alias<input_target>;
defm output_target : Eq<"output-target">,
                     HelpText<"Format of the output file">,
                     Values<"binary">;
def compress_debug_sections : Flag<["--", "-"], "compress-debug-sections">;
def compress_debug_sections_eq : Joined<["--", "-"], "compress-debug-sections=">,
                                 MetaVarName<"[ zlib | zlib-gnu ]">,
                                 HelpText<"Compress DWARF debug sections using "
                                          "specified style. Supported styles: "
                                          "'zlib-gnu' and 'zlib'">;
def O : JoinedOrSeparate<["-"], "O">,
        Alias<output_target>;
defm split_dwo : Eq<"split-dwo">,
                 MetaVarName<"dwo-file">,
                 HelpText<"Equivalent to extract-dwo on the input file to <dwo-file>, then strip-dwo on the input file">;

def preserve_dates : Flag<[ "-", "--" ], "preserve-dates">,
                     HelpText<"Preserve access and modification timestamps">;

def p : Flag<[ "-" ], "p">, Alias<preserve_dates>;

defm add_gnu_debuglink : Eq<"add-gnu-debuglink">,
                         MetaVarName<"debug-file">,
                         HelpText<"Add a .gnu_debuglink for <debug-file>">;
defm remove_section : Eq<"remove-section">,
                      MetaVarName<"section">,
                      HelpText<"Remove <section>">;
defm rename_section
    : Eq<"rename-section">,
      MetaVarName<"old=new[,flag1,...]">,
      HelpText<
          "Renames a section from old to new, optionally with specified flags. "
          "Flags supported for GNU compatibility: alloc, load, noload, "
          "readonly, debug, code, data, rom, share, contents, merge, strings.">;
defm redefine_symbol : Eq<"redefine-sym">,
                       MetaVarName<"old=new">,
                       HelpText<"Change the name of a symbol old to new">;
def R : JoinedOrSeparate<["-"], "R">,
        Alias<remove_section>;
defm keep : Eq<"keep">,
            MetaVarName<"section">,
            HelpText<"Keep <section>">;
defm only_keep : Eq<"only-keep">,
                 MetaVarName<"section">,
                 HelpText<"Remove all but <section>">;
def j : JoinedOrSeparate<["-"], "j">,
                      Alias<only_keep>;
defm add_section : Eq<"add-section">,
                   MetaVarName<"section=file">,
                   HelpText<"Make a section named <section> with the contents of <file>.">;
def strip_all : Flag<["-", "--"], "strip-all">,
                HelpText<"Remove non-allocated sections other than .gnu.warning* sections">;
def strip_all_gnu : Flag<["-", "--"], "strip-all-gnu">,
                    HelpText<"Compaitable with GNU objcopy's --strip-all">;
def S : Flag<["-"], "S">,
        Alias<strip_all_gnu>;
def strip_debug : Flag<["-", "--"], "strip-debug">,
                  HelpText<"Remove all debug information">;
def strip_dwo : Flag<["-", "--"], "strip-dwo">,
                HelpText<"Remove all DWARF .dwo sections from file">;
def strip_sections : Flag<["-", "--"], "strip-sections">,
                     HelpText<"Remove all section headers">;
def strip_non_alloc : Flag<["-", "--"], "strip-non-alloc">,
                      HelpText<"Remove all non-allocated sections">;
def extract_dwo : Flag<["-", "--"], "extract-dwo">,
                  HelpText<"Remove all sections that are not DWARF .dwo sections from file">;
def localize_hidden : Flag<["-", "--"], "localize-hidden">,
                      HelpText<"Mark all symbols that have hidden or internal visibility as local">;
defm localize_symbol : Eq<"localize-symbol">,
                       MetaVarName<"symbol">,
                       HelpText<"Mark <symbol> as local">;
def L : JoinedOrSeparate<["-"], "L">,
        Alias<localize_symbol>;
defm globalize_symbol : Eq<"globalize-symbol">,
                       MetaVarName<"symbol">,
                       HelpText<"Mark <symbol> as global">;

defm keep_global_symbol
    : Eq<"keep-global-symbol">,
      MetaVarName<"symbol">,
      HelpText<"Convert all symbols except <symbol> to local. May be repeated "
               "to convert all except a set of symbols to local.">;
def G : JoinedOrSeparate<[ "-" ], "G">, Alias<keep_global_symbol>;

defm keep_global_symbols
    : Eq<"keep-global-symbols">,
      MetaVarName<"filename">,
      HelpText<
          "Reads a list of symbols from <filename> and runs as if "
	  "--keep-global-symbol=<symbol> is set for each one. <filename> "
	  "contains one symbol per line and may contain comments beginning "
	  "with '#'. Leading and trailing whitespace is stripped from each "
	  "line. May be repeated to read symbols from many files.">;

def version : Flag<[ "-", "--" ], "version">,
              HelpText<"Print the version and exit.">;

defm weaken_symbol : Eq<"weaken-symbol">,
                       MetaVarName<"symbol">,
                       HelpText<"Mark <symbol> as weak">;
def W : JoinedOrSeparate<["-"], "W">,
        Alias<weaken_symbol>;
def weaken : Flag<["-", "--"], "weaken">,
                  HelpText<"Mark all global symbols as weak">;
def discard_all : Flag<["-", "--"], "discard-all">,
                      HelpText<"Remove all local symbols except file and section symbols">;
def x : Flag<["-"], "x">,
        Alias<discard_all>;
defm strip_symbol : Eq<"strip-symbol">,
                       MetaVarName<"symbol">,
                       HelpText<"Remove symbol <symbol>">;
def N : JoinedOrSeparate<["-"], "N">,
        Alias<strip_symbol>;
defm keep_symbol : Eq<"keep-symbol">,
                       MetaVarName<"symbol">,
                       HelpText<"Do not remove symbol <symbol>">;
def K : JoinedOrSeparate<["-"], "K">,
        Alias<keep_symbol>;
def only_keep_debug : Flag<["-", "--"], "only-keep-debug">,
                          HelpText<"Currently ignored. Only for compaitability with GNU objcopy.">;
def strip_unneeded : Flag<["-", "--"], "strip-unneeded">,
                      HelpText<"Remove all symbols not needed by relocations">;
def keep_file_symbols : Flag<["-", "--"], "keep-file-symbols">,
                      HelpText<"Do not remove file symbols">;
defm dump_section : Eq<"dump-section">,
                   MetaVarName<"section=file">,
                   HelpText<"Dump contents of section named <section> into file <file>">;
defm prefix_symbols : Eq<"prefix-symbols">,
                       MetaVarName<"prefix">,
                       HelpText<"Add <prefix> to the start of every symbol name">;
