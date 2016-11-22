require 'prawn/layout'
require 'barby'
require 'barby/barcode/code_39'
require 'barby/outputter/prawn_outputter'

render partial: 'spree/admin/orders/repeat'

bounding_box([0, 540], width: 540, height: 460) do
  render :partial => "spree/admin/orders/address"
  render :partial => "spree/admin/orders/line_items_box"
end

move_down 8

# Footer
render :partial => "spree/admin/orders/footer"

move_down 650

text "If you wish to return one of your peach products, visit www.#{peach_domain} and sign in to your account to view your Order History. Select the order you'd like to return and follow the instructions to receive your pre-paid UPS shipping label#{(ENV['RETURN_LABEL_INCLUDED'] || false).to_bool ? ", or use the included return label" : nil}. Pop the items you're returning into their original box with the packing slip and drop them off at the nearest UPS Drop Box. Once we receive and process the return, we will refund you accordingly. Please allow up to two weeks for return processing.", :style => :italic 

move_down 4

text("If you would like to exchange an item, please #{@order.has_personal_stylist? ? "connect with your personal stylist, <b>#{@order.stylist.name}</b> at <b>#{@order.stylist.email}</b>" : "email us at <b>#{returns_email}</b>"}", style: :italic, inline_format: true )
