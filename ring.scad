use <bridge.scad>

ORIENTATION_LEFT = -1;
ORIENTATION_RIGHT = 1;

module base_ring(ring_width, ring_height, hole_width, hole_height, bridge_length, thickness, hole_offset, semicylinder_offset, eps) {
    union() {
        translate([(bridge_length + semicylinder_offset*2 - eps)/2, 0, thickness/2]) {
            _semicylinder(
                orientation=ORIENTATION_LEFT,
                ring_width=ring_width,
                ring_height=ring_height,
                hole_width=hole_width,
                hole_height=hole_height,
                bridge_length=bridge_length,
                thickness=thickness,
                hole_offset=hole_offset,
                semicylinder_offset=semicylinder_offset,
                eps=eps
            );
        }
        translate([-(bridge_length + semicylinder_offset*2 - eps)/2, 0, -thickness/2]) {
            _semicylinder(
                orientation=ORIENTATION_RIGHT,
                ring_width=ring_width,
                ring_height=ring_height,
                hole_width=hole_width,
                hole_height=hole_height,
                bridge_length=bridge_length,
                thickness=thickness,
                hole_offset=hole_offset,
                semicylinder_offset=semicylinder_offset,
                eps=eps
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
            semicylinder_offset=semicylinder_offset,
            eps=eps
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
            semicylinder_offset=semicylinder_offset,
            eps=eps
        );
    }
}

module _semicylinder(orientation, ring_width, ring_height, hole_width, hole_height, bridge_length, thickness, hole_offset, semicylinder_offset, eps) {
    difference() {
        scale([ring_width/10, ring_height/10, thickness/10]) {
            cylinder(h=10, r1=10, r2=10, center=true);
        }
        scale([hole_width/10, hole_height/10, 999]) {
            translate([orientation * (hole_offset / hole_width * 10), 0, 0]) {
                cylinder(h=10, r1=10, r2=10, center=true);
            }
        }
        scale([ring_width/10, ring_height/10, 999]) {
            translate([orientation * (5 + (semicylinder_offset/ ring_width * 10)), 0, 0]) {
                cube(size=[10, 4*10, 10], center=true);
            }
        }
    }
 }