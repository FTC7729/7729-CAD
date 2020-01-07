(Pillow_Block_Chamfer_Holes)
(Chamfer operation using v-carve bit)
(Machine)
(  vendor: Carbide 3D)
(  model: 3)
(  description: Shapeoko)
(T9  D=6.35 CR=0 TAPER=90deg - ZMIN=-1.5 - countersink)
G90 G94
G17
G21
G28 G91 Z0
G90

(Chamfer)
T9 M6
S12000 M3
G54
G0 X3.175 Y47.725
Z20
Z10
Z0
G1 Z-1.5 F60
G0 Z10
Y32
Z0
G1 Z-1.5 F60
G0 Z10
Y3.5
Z0
G1 Z-1.5 F60
G0 Z10
Z20
G28 G91 Z0
G90
G28 G91 X0 Y0
G90
M5
M30
