require "nydp"
require "nydp/builtin"
require "nydp/caxlsx/version"
require "axlsx"

module Nydp
  module Caxlsx
    class Error < StandardError; end

    class Plugin
      def name ; "nydp/caxlsx plugin" ; end

      def relative_path name
        File.expand_path(File.join File.dirname(__FILE__), name)
      end

      def base_path ; relative_path "../lisp/" ; end

      def load_rake_tasks ; end

      def loadfiles
        Dir.glob(relative_path '../lisp/caxlsx-*.nydp').sort
      end

      def testfiles
        Dir.glob(relative_path '../lisp/tests/**/*.nydp')
      end

      def setup ns
        Nydp::Symbol.mk("xls/package/new"   , ns).assign(Nydp::Caxlsx::Builtin::NewPackage.instance)
        Nydp::Symbol.mk("xls/worksheet/new" , ns).assign(Nydp::Caxlsx::Builtin::NewWorksheet.instance)
        Nydp::Symbol.mk("xls/row/new"       , ns).assign(Nydp::Caxlsx::Builtin::NewRow.instance)
        Nydp::Symbol.mk("xls/style/new"     , ns).assign(Nydp::Caxlsx::Builtin::NewStyle.instance)
      end
    end

    module Builtin
      class NewPackage
        include Nydp::Builtin::Base, Singleton
        def builtin_invoke_1 vm
          vm.push_arg Axlsx::Package.new
        end
      end

      class NewWorksheet
        include Nydp::Builtin::Base, Singleton
        def builtin_invoke_3 vm, package, name
          vm.push_arg package.workbook.add_worksheet(name.is_a?(Hash) ? n2r(name) :  { name: n2r(name) })
        end
      end

      class NewRow
        include Nydp::Builtin::Base, Singleton
        def builtin_invoke_3 vm, sheet, values
          vm.push_arg sheet.add_row(n2r(values))
        end

        def builtin_invoke_4 vm, sheet, values, options
          vm.push_arg sheet.add_row(n2r(values), n2r(options))
        end
      end

      class NewStyle
        include Nydp::Builtin::Base, Singleton
        def builtin_invoke_3 vm, package, rules
          vm.push_arg package.workbook.styles.add_style(n2r(rules))
        end
      end
    end
  end
end

Nydp.plug_in Nydp::Caxlsx::Plugin.new
