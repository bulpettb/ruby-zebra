require_relative '../lib/zebra/zpl'

def print_zpl_str(name, label)
  zpl = ''
  label.dump_contents zpl
  puts "\n#{name}:\n#{zpl}\n\n"
end

def new_label
  Zebra::Zpl::Label.new(
    width:         600,
    length:        305,
    print_speed:   6,
    print_density: 5,
    copies:        1
  )
end

################################################################################
# Text
################################################################################
label = new_label
text  = Zebra::Zpl::Text.new(
  data:       "Hello, printer!",
  position:   [10, 125],
  font_size:  Zebra::Zpl::FontSize::SIZE_5,
  justification: Zebra::Zpl::Justification::CENTER
)
box = Zebra::Zpl::Graphic.new(
  graphic_type:     'B',
  position:         [10,5],
  graphic_width: label.width,
  graphic_height: label.length-10,
  line_thickness: 1,
  rounding_degree: 1
)
label << text
label << box
print_zpl_str('text', label)

################################################################################
# Raw ZPL
################################################################################
label = new_label
zpl_string = "^GFA,1300,1300,13,,::::::O01IFE,N01KFE,N0MFC,M03NF,M0OFC,L03PF,L0QF8,K01QFE,K03RF,K07RF8,J01SFC,J03F9OFE7E,J07F01MFE03F,J07E007LF803F8,J0FE003KFE001FC,I01FEI0FC00FC001FE,I03FCI04M01FF,I07FCQ01FF,I07FCQ01FF8,I0FFCQ01FFC,I0FFEQ01FFC,001FFEQ01FFE,:003FFEQ03IF,003FFEQ01IF,007FFCR0IF,007FFCR0IF8,007FF8R07FF8,00IFS03FF8,00IFS03FFC,:00FFES01FFC,01FFES01FFC,01FFES01FFE,:01FFCS01FFE,:::::01FFES01FFE,::01FFES03FFE,01IFS03FFE,01IFS03FFC,01IF8R07FFC,00IF8R0IFC,00IFCR0IFC,00IFEQ01IFC,00JFQ03IF8,007IF8P07IF8,007IFCP0JF8,007JFO03JF,003F87FCN0KF,003F81FFM03JFE,001F80FFEK01KFE,001FC07FFCJ0LFC,I0FF03FF8J0LFC,I0FF03FF8J07KF8,I07F81FF8J07KF8,I03F807F8J07KF,I03FC004K07JFE,I01FCN07JFE,J0FEN07JFC,J07FN07JF8,J03F8M07JF,J01FCM07IFE,K0FFM07IFC,K07IF8J07IF8,K03IF8J07IF,L0IF8J07FFC,L07FF8J07FF8,L01FF8J07FE,M0FF8J07F8,M01F8J07E,N07K038,,::::::::::::::^FS"
raw_zpl = Zebra::Zpl::Raw.new(
  data:       zpl_string,
  position:   [50, 50],
)
label << raw_zpl
print_zpl_str('raw_zpl', label)

################################################################################
# Barcode
################################################################################
label = new_label
barcode = Zebra::Zpl::Barcode.new(
  data:                       'F112358',
  position:                   [80, 50],
  height:                     150,
  width:                      4,
  print_human_readable_code:  true,
  type:                       Zebra::Zpl::BarcodeType::CODE_128_AUTO
)
label << barcode
print_zpl_str('barcode', label)

################################################################################
# QR Code
################################################################################
label = new_label
qrcode = Zebra::Zpl::Qrcode.new(
  data:             'www.github.com',
  position:         [200, 45],
  scale_factor:     8,
  correction_level: 'H',
)
label << qrcode
print_zpl_str('qrcode', label)

################################################################################
# Data Matrix
################################################################################
label = new_label
datamatrix = Zebra::Zpl::Datamatrix.new(
  data:             'www.github.com',
  position:         [225, 75],
  symbol_height:     10,
  aspect_ratio:      1
)
label << datamatrix
print_zpl_str('datamatrix', label)

################################################################################
# Graphics
################################################################################
label = new_label
box = Zebra::Zpl::Graphic.new(
  graphic_type:     'B',
  position:         [10,10],
  graphic_width: 80,
  graphic_height: 80,
  line_thickness: 2,
  rounding_degree: 2
)
circle = Zebra::Zpl::Graphic.new(
  graphic_type:     'C',
  position:         [100,10],
  graphic_width: 80,
  line_thickness: 3
)
diagonal1 = Zebra::Zpl::Graphic.new(
  graphic_type:     'D',
  position:         [190,10],
  graphic_width: 80,
  graphic_height: 80,
  line_thickness: 3,
  orientation: 'R'
)
diagonal2 = diagonal1.dup
diagonal2.orientation = 'L'
ellipse = Zebra::Zpl::Graphic.new(
  graphic_type:     'E',
  position:         [280,10],
  graphic_width: 40,
  graphic_height: 80,
  line_thickness: 3
)
symbol = Zebra::Zpl::Graphic.new(
  graphic_type:     'S',
  symbol_type:      'B',
  position:         [335,10],
  graphic_width: 80,
  graphic_height: 80
)

label << box
label << circle
label << diagonal1
label << diagonal2
label << ellipse
label << symbol
label.elements.each { |e| e.position = [e.x + 110 , e.y + 90] }
print_zpl_str('graphics', label)

################################################################################
# Images
################################################################################
label = new_label
image = Zebra::Zpl::Image.new(
  path: File.expand_path('./images/earth.jpg', File.dirname(__FILE__)),
  position: [145, 0],
  width: 305,
  height: 305
)
label << image
print_zpl_str('image', label)

# inverted image
label = new_label
image = Zebra::Zpl::Image.new(
  path: File.expand_path('./images/earth.jpg', File.dirname(__FILE__)),
  position: [145, 0],
  width: 305,
  height: 305,
  invert: true
)
label << image
print_zpl_str('image_inverted', label)

################################################################################
# Image Manipulation
################################################################################
label = new_label
image = Zebra::Zpl::Image.new(
  path: File.expand_path('./images/ruby.png', File.dirname(__FILE__)),
  position: [0, 0],
  width: 305,
  height: 305,
  black_threshold: 0.65
)
src = image.source
src.background('white').flatten

# perform edge detection on the image
MiniMagick::Tool::Convert.new do |convert|
  convert << src.path
  convert << '-colorspace' << 'gray'
  convert << '-edge' << '4'
  convert << '-negate'
  convert << src.path
end

src.trim

label << image
print_zpl_str('image_manipulation', label)

################################################################################
# Justification
################################################################################
label = new_label
t1  = Zebra::Zpl::Text.new(
  data:       "ZPL",
  position:   [10, 25],
  font_size:  Zebra::Zpl::FontSize::SIZE_5,
  justification: Zebra::Zpl::Justification::LEFT
)
t2  = Zebra::Zpl::Text.new(
  data:       "ZPL",
  position:   [10, 65],
  font_size:  Zebra::Zpl::FontSize::SIZE_5,
  justification: Zebra::Zpl::Justification::CENTER
)
t3  = Zebra::Zpl::Text.new(
  data:       "ZPL",
  position:   [10, 105],
  font_size:  Zebra::Zpl::FontSize::SIZE_5,
  justification: Zebra::Zpl::Justification::RIGHT
)
t4  = Zebra::Zpl::Text.new(
  data:       "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua",
  position:   [10, 180],
  font_size:  Zebra::Zpl::FontSize::SIZE_4,
  justification: Zebra::Zpl::Justification::JUSTIFIED
)
box = Zebra::Zpl::Graphic.new(
  graphic_type:     'B',
  position:         [10,5],
  graphic_width: label.width,
  graphic_height: label.length-10,
  line_thickness: 1,
  rounding_degree: 1
)
label << t1
label << t2
label << t3
label << t4
label << box
print_zpl_str('justification', label)

################################################################################
# Rotation
################################################################################
label = new_label
t1  = Zebra::Zpl::Text.new(
  data:       "Zero",
  position:   [10, 125],
  font_size:  Zebra::Zpl::FontSize::SIZE_5,
  rotation: Zebra::Zpl::Rotation::NO_ROTATION,
  max_lines: 1
)
t2  = Zebra::Zpl::Text.new(
  data:       "90",
  position:   [100, 125],
  font_size:  Zebra::Zpl::FontSize::SIZE_5,
  rotation: Zebra::Zpl::Rotation::DEGREES_90,
  max_lines: 1
)
t3  = Zebra::Zpl::Text.new(
  data:       "180",
  position:   [175, 125],
  font_size:  Zebra::Zpl::FontSize::SIZE_5,
  rotation: Zebra::Zpl::Rotation::DEGREES_180,
  justification: Zebra::Zpl::Justification::RIGHT,
  max_lines: 1
)
t4  = Zebra::Zpl::Text.new(
  data:       "270",
  position:   [275, 125],
  font_size:  Zebra::Zpl::FontSize::SIZE_5,
  rotation: Zebra::Zpl::Rotation::DEGREES_270,
  justification: Zebra::Zpl::Justification::RIGHT,
  max_lines: 1
)
box = Zebra::Zpl::Graphic.new(
  graphic_type:     'B',
  position:         [10,5],
  graphic_width: label.width,
  graphic_height: label.length-10,
  line_thickness: 1,
  rounding_degree: 1
)
label << t1
label << t2
label << t3
label << t4
label.elements.each { |e| e.position = [e.x + 150, e.y] }
label << box
print_zpl_str('rotation', label)
