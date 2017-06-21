font @font_face, size: 10

data = []
row_styles = {}

def style_row(styles, row_num, opts={})
  styles[row_num] ||= {}
  styles[row_num].merge!(opts)
end

@column_widths = { 0 => 360, 1 => 80, 2 => 100}
@align = { 0 => :left, 1 => :left, 2 => :right }
if @order.shipments.count > 1
  style_row(row_styles, data.size)
  data << ["--> Included in this shipment", nil, nil]
end

@shipment.cards_for_packing_slip.each do |card|
  style_row(row_styles, data.size)
  data << ['<b>'+card.name+'</b>', [card.options_text, "qty: #{card.quantity}"].map(&:presence).compact.join("\n"), card.sku]
end

render partial: 'spree/admin/orders/shipment_line_items', locals: {shipment: @shipment, included: true, need_title: false, data: data, row_styles: row_styles}

if @order.shipments.count > 1
  need_title = true
  @order.shipments.each do |shipment|
    if (shipment.number != @shipment.number)
      render partial: 'spree/admin/orders/shipment_line_items', locals: {shipment: shipment, included: false, need_title: need_title, data: data, row_styles: row_styles}
    end
  end
end

table(data, :width => @column_widths.values.compact.sum, :column_widths => @column_widths, cell_style: {padding: [8, 5, 8, 5], inline_format: true}, row_colors: [nil,'eff0f1']) do
  cells.border_width = 0.5
  last_row = data.length - 1
  last_column = data[0].length - 1
  row_styles.each do |row_num, styles|
    row(row_num).font_style = styles[:font_style] if styles[:font_style].present?
    row(row_num).text_color = styles[:text_color] if styles[:text_color].present?
    if (align = styles[:align]).present?
      row(row_num).style(align: align)
    end
    row(row_num).columns(0..last_column).borders = [:top, :bottom]
  end

  row(0).borders = [:bottom]

  row(0).columns(0..last_column).borders = [:top, :bottom]
  row(0).columns(0..last_column).border_widths = [1.5, 0, 0.5, 0]

  row(0).column(last_column).border_widths = [1.5, 0, 0.5, 0]

  row(last_row).columns(0..last_column).borders = [:top, :bottom]
  row(last_row).columns(0..last_column).border_widths = [0.5, 0, 1.5, 0]
  row(last_row).column(last_column).border_widths = [0.5, 0, 1.5, 0]
end
