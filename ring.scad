use <bridge.scad>

ORIENTATION_LEFT = -1;
ORIENTATION_RIGHT = 1;
INTERSECTION_EPS = 0.001;

module base_ring(ring_width, ring_height, hole_width, hole_height, bridge_length, thickness, hole_offset, semicylinder_offset) {
    union() {
        translate([(bridge_length + semicylinder_offset*2 - INTERSECTION_EPS)/2, 0, thickness/2]) {
            _semicylinder(
                orientation=ORIENTATION_LEFT,
                ring_width=ring_width,
                ring_height=ring_height,
                hole_width=hole_width,
                hole_height=hole_height,
                bridge_length=bridge_length,
                thickness=thickness,
                hole_offset=hole_offset,
                semicylinder_offset=semicylinder_offset
            );
        }
        translate([-(bridge_length + semicylinder_offset*2 - INTERSECTION_EPS)/2, 0, -thickness/2]) {
            _semicylinder(
                orientation=ORIENTATION_RIGHT,
                ring_width=ring_width,
                ring_height=ring_height,
                hole_width=hole_width,
                hole_height=hole_height,
                bridge_length=bridge_length,
                thickness=thickness,
                hole_offset=hole_offset,
                semicylinder_offset=semicylinder_offset
            );
        }
        bridge_base(
            orientation=ORIENTATION_LEFT,
            ring_width=ring_width,
            ring_height=ring_height,
            hole_width=hole_width,
            hole_height=hole_height,
            bridge_length=bridge_length,
            thickness=thickness,
            hole_offset=hole_offset,
            semicylinder_offset=semicylinder_offset
        );
        bridge_base(
            orientation=ORIENTATION_RIGHT,
            ring_width=ring_width,
            ring_height=ring_height,
            hole_width=hole_width,
            hole_height=hole_height,
            bridge_length=bridge_length,
            thickness=thickness,
            hole_offset=hole_offset,
            semicylinder_offset=semicylinder_offset
        );
    }
}

module _semicylinder(orientation, ring_width, ring_height, hole_width, hole_height, bridge_length, thickness, hole_offset, semicylinder_offset) {
    difference() {
        scale([ring_width, ring_height, 1]) {
            cylinder(h=thickness, r1=1, r2=1, center=true);
        }
        scale([hole_width, hole_height, 999]) {
            translate([orientation * (hole_offset / hole_width), 0, 0]) {
                cylinder(h=1, r1=1, r2=1, center=true);
            }
        }
        scale([ring_width, ring_height, 999]) {
            translate([orientation * (0.5 + (semicylinder_offset/ ring_width)), 0, 0]) {
                cube(size=[1, 4*1, 1], center=true);
            }
        }
    }
 }