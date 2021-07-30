require "nydp"
require "nydp/builtin"
require "nydp/caxlsx/version"
require "axlsx"

module Nydp
  module Caxlsx
    class Error < StandardError; end

    class Plugin
      include Nydp::PluginHelper

      def name ; "nydp/caxlsx plugin" ; end

      def base_path ; relative_path "../lisp/" ; end

      def load_rake_tasks ; end

      def loadfiles
        file_readers Dir.glob(relative_path '../lisp/caxlsx-*.nydp').sort
      end

      def testfiles
        file_readers Dir.glob(relative_path '../lisp/tests/**/*.nydp')
      end

      def setup ns
        ns.assign("xls/package/new"            , Nydp::Caxlsx::Builtin::NewPackage.instance      )
        ns.assign("xls/worksheet/new"          , Nydp::Caxlsx::Builtin::NewWorksheet.instance    )
        ns.assign("xls/worksheet/column-widths", Nydp::Caxlsx::Builtin::SetColumnWidths.instance )
        ns.assign("xls/row/new"                , Nydp::Caxlsx::Builtin::NewRow.instance          )
        ns.assign("xls/style/new"              , Nydp::Caxlsx::Builtin::NewStyle.instance        )
      end
    end

    module Builtin
      class NewPackage
        include Nydp::Builtin::Base, Singleton
        def call
          # vm.push_arg Axlsx::Package.new
          Axlsx::Package.new
        end
      end

      class NewWorksheet
        include Nydp::Builtin::Base, Singleton
        # def builtin_invoke_3 vm, package, name
        def call package, name
          # vm.push_arg package.workbook.add_worksheet(name.is_a?(Hash) ? rubify(name) :  { name: rubify(name) })
          package.workbook.add_worksheet(name.is_a?(Hash) ? rubify(name) :  { name: rubify(name) })
        end
      end

      class NewRow
        include Nydp::Builtin::Base, Singleton
        # def builtin_invoke_3 vm, sheet, values
        def call sheet, values
          # vm.push_arg sheet.add_row(rubify(values))
          sheet.add_row(rubify(values))
        end

        # def builtin_invoke_4 vm, sheet, values, options
        def call sheet, values, options={}
          # vm.push_arg sheet.add_row(rubify(values), rubify(options))
          sheet.add_row(rubify(values), rubify(options))
        end
      end

      class SetColumnWidths
        include Nydp::Builtin::Base, Singleton
        # def builtin_invoke_3 vm, sheet, values
        def call sheet, values
          # vm.push_arg sheet.column_widths(rubify(values))
          sheet.column_widths(rubify(values))
        end
      end

      class NewStyle
        include Nydp::Builtin::Base, Singleton
        # def builtin_invoke_3 vm, package, rules
        def call package, rules
          # vm.push_arg package.workbook.styles.add_style(rubify(rules))
          package.workbook.styles.add_style(rubify(rules))
        end
      end
    end
  end
end

Nydp.plug_in Nydp::Caxlsx::Plugin.new
