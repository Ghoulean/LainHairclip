// left orientation = negative
 module bridge_base(orientation, ring_width, ring_height, hole_width, hole_height, bridge_length, thickness, hole_offset, semicylinder_offset) {
    bbth = calc_bridge_base_thickness(
        ring_width=ring_width,
        ring_height=ring_height,
        hole_width=hole_width,
        hole_height=hole_height,
        semicylinder_offset=semicylinder_offset,
        hole_offset=hole_offset
    );
    bbco = calc_bridge_base_center_offset(
        hole_width=hole_width,
        hole_height=hole_height,
        semicylinder_offset=semicylinder_offset,
        hole_offset=hole_offset,
        bbth=bbth
    );
    translate([0, orientation * bbco, 0]) {
         difference() {
            scale([bridge_length, bbth, thickness]) {
                cube(size=[1, 1, 2*1], center=true);
            }
            translate([bridge_length/2, 0, -thickness]) {
                rotate(45, [0, 1, 0]) {
                    cube(size=[thickness * sqrt(2), 999, 999], center=true);
                }
            }
            translate([-bridge_length/2, 0, thickness]) {
                rotate(45, [0, 1, 0]) {
                    cube(size=[thickness * sqrt(2), 999, 999], center=true);
                }
            }
        }
    }
 }
 
 function calc_bridge_base_center_offset(hole_width, hole_height, semicylinder_offset, hole_offset, bbth) = (
    hole_height * sqrt(1 - (semicylinder_offset - hole_offset)^2/hole_width^2) + bbth/2
 );
 
 function calc_bridge_base_thickness(ring_width, ring_height, hole_width, hole_height, semicylinder_offset, hole_offset) = (
    ring_height * sqrt(1 - semicylinder_offset^2/ring_width^2) - hole_height * sqrt(1 - (semicylinder_offset - hole_offset)^2/hole_width^2)
 );
 
 
 