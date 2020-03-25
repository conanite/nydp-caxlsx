require 'nydp/caxlsx'

RSpec.describe Nydp::Caxlsx do
  it "has a version number" do
    expect(Nydp::Caxlsx::VERSION).not_to be nil
  end

  it "writes an xlsx file" do
    base = File.dirname(__FILE__)
    allow(Time).to receive_messages now: Time.parse("2020-03-25 21:11")

    code = <<NYDP
      ;; (debug-pre-compile t)
      (def make-xls (items)
        (xls
          (sheet "big sheet"
            (row (list "Created" "Name" "Size" "L.F." "W.F." "Polarity") { style (style { b t }) })
            (let rules { style (list (style { format_code "dd/mmm/yyyy" bg_color "00" fg_color "FF" })
                                     (style {                           bg_color "FFEEEE77"} )
                                     (style { format_code "0.00"        bg_color "FFCCCCFF"} )) }
              (each item items
                (row (list item.created_at
                           item.name
                           item.size
                           item.lorentz_factor
                           item.wave_function
                           item.polarity)
                     rules))))))
NYDP

    items = []
    items << { created_at: Time.at(1234567890), name: "SocialDistance", size: 42.0  , lorentz_factor: "epidemic", wave_function: "λβ/2π"  , polarity: "strange" }
    items << { created_at: Time.at(2345678901), name: "20-second-wash", size:  6.283, lorentz_factor: "pandemic", wave_function: "λγ/4πr²", polarity: "left"    }

    ns = ::Nydp.get_nydp
    ::Nydp.eval_src ns, code
    ss = ::Nydp.apply_function ns, "make-xls", items

    output   = File.join(base, "test-result.xlsx")
    expected = File.join(base, "test-expected.xlsx")

    ss.serialize(output)

    expect(File.read(output)).to eq File.read(expected)
  end
end
