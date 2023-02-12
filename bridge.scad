  // left orientation = negative
 module bridge_base(orientation, ring_width, ring_height, hole_width, hole_height, bridge_length, thickness, hole_offset, semicylinder_offset, eps) {
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
            scale([bridge_length/10, bbth/10, thickness/10]) {
                cube(size=[10, 10, 2*10], center=true);
            }
            translate([bridge_length/2, 0, -bbth]) {
                rotate(45, [0, 1, 0]) {
                    cube(size=[10/sqrt(2), 10, 10/sqrt(2)], center=true);
                }
            }
            translate([-bridge_length/2, 0, bbth]) {
                rotate(45, [0, 1, 0]) {
                    cube(size=[10/sqrt(2), 10, 10/sqrt(2)], center=true);
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
 
 
 