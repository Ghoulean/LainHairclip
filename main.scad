use <bridge.scad>
use <ring.scad>
use <spike.scad>

RING_WIDTH = 35;
RING_HEIGHT = 15;

HOLE_WIDTH = 26;
HOLE_HEIGHT = 10;

RING_THICKNESS = 5;

HOLE_OFFSET = -4.5;
HALFRING_OFFSET = 1;

BRIDGE_LENGTH = 15;

SIDE_SPIKE_LENGTH = 13;
SIDE_SPIKE_BASE_R = 2;

RING_SPIKE_LENGTH = 9;
RING_SPIKE_BASE_R = 2;
RING_SPIKE_OFFSET_X = 23;
RING_SPIKE_OFFSET_Y = 1;
RING_SPIKE_ROTATION_DEG = 1;

CONNECTOR_SPIKE_LENGTH = 5;
CONNECTOR_SPIKE_BASE_R = 2;

CAP_THICKNESS = 1;
CAP_SPREAD = 1;

//epsilon
EPS = 0.01;

$fn = 64;
// $fs = 0.1;

bbth = calc_bridge_base_thickness(
    ring_width=RING_WIDTH,
    ring_height=RING_HEIGHT,
    hole_width=HOLE_WIDTH,
    hole_height=HOLE_HEIGHT,
    semicylinder_offset=HALFRING_OFFSET,
    hole_offset=HOLE_OFFSET
);
bbco = calc_bridge_base_center_offset(
    hole_width=HOLE_WIDTH,
    hole_height=HOLE_HEIGHT,
    semicylinder_offset=HALFRING_OFFSET,
    hole_offset=HOLE_OFFSET,
    bbth=bbth
);

main();

module main() {
    translate([0, 0, 10]) {
        outer_ring();
    }
    translate([0, 0, -10]) {
        inner_ring();
    }
}

module outer_ring() {
    union() {
        difference() {
            decorated_base_ring();
            cube(size=[BRIDGE_LENGTH, 2*bbco + EPS, 999], center=true);
        }
        translate([0, (bbco - EPS), 0]) {
            rotate(90, [1, 0, 0]) {
                cylinder(h=bbth, r=CONNECTOR_SPIKE_BASE_R, center=true);
            }
        }
        translate([0, (bbco - bbth/2 - EPS), 0]) {
            rotate(90, [1, 0, 0]) {
                spike(radius=CONNECTOR_SPIKE_BASE_R, height=CONNECTOR_SPIKE_LENGTH);
            }
        }
        translate([0, (bbco + bbth/2 - EPS), 0]) {
            rotate(90, [1, 0, 0]) {
                cylinder(h=CAP_THICKNESS, r2=CONNECTOR_SPIKE_BASE_R + CAP_SPREAD, r1=CONNECTOR_SPIKE_BASE_R, center=true);
            }
        }
        translate([0, -(bbco - EPS), 0]) {
            rotate(90, [1, 0, 0]) {
                cylinder(h=bbth, r=CONNECTOR_SPIKE_BASE_R, center=true);
            }
        }
        translate([0, -(bbco - bbth/2 - EPS), 0]) {
            rotate(90, [-1, 0, 0]) {
                spike(radius=CONNECTOR_SPIKE_BASE_R, height=CONNECTOR_SPIKE_LENGTH);
            }
        }
        translate([0, -(bbco + bbth/2 - EPS), 0]) {
            rotate(90, [-1, 0, 0]) {
                cylinder(h=CAP_THICKNESS, r2=CONNECTOR_SPIKE_BASE_R + CAP_SPREAD, r1=CONNECTOR_SPIKE_BASE_R, center=true);
            }
        }
    }
}

module inner_ring() {
    difference() {
        decorated_base_ring();
        difference() {
            cube(size=[BRIDGE_LENGTH, 999, 999], center=true);
            cube(size=[BRIDGE_LENGTH, 2*bbco + EPS, 999], center=true);
        }
        rotate(90, [1, 0, 0]) {
            cylinder(h=999, r=CONNECTOR_SPIKE_BASE_R + EPS*2, center=true);
        }
    }
}

module decorated_base_ring() {
    union() {
        base_ring(
            ring_width=RING_WIDTH,
            ring_height=RING_HEIGHT,
            hole_width=HOLE_WIDTH,
            hole_height=HOLE_HEIGHT,
            bridge_length=BRIDGE_LENGTH,
            thickness=RING_THICKNESS,
            hole_offset=HOLE_OFFSET,
            semicylinder_offset=HALFRING_OFFSET,
            eps=EPS
        );
        side_spikes();
        ring_spikes();
    }
}

module side_spikes() {
    translate([-(HOLE_WIDTH + HALFRING_OFFSET - HOLE_OFFSET + BRIDGE_LENGTH/2 + EPS), 0, -RING_THICKNESS/2]) {
        rotate(90, [0, 1, 0]) {
            spike(radius=SIDE_SPIKE_BASE_R, height=SIDE_SPIKE_LENGTH);
        }
    }
    translate([(HOLE_WIDTH + HALFRING_OFFSET - HOLE_OFFSET + BRIDGE_LENGTH/2 + EPS), 0, RING_THICKNESS/2]) {
        rotate(90, [0, -1, 0]) {
            spike(radius=SIDE_SPIKE_BASE_R, height=SIDE_SPIKE_LENGTH);
        }
    }
}

module ring_spikes() {
    translate([-RING_SPIKE_OFFSET_X, (RING_SPIKE_OFFSET_Y + HOLE_HEIGHT), -RING_THICKNESS/2]) {
        rotate(90, [1, 0, 0]) {
            rotate(20, [0, 1, 0]) {
                spike(radius=RING_SPIKE_BASE_R, height=RING_SPIKE_LENGTH);
            }
        }
    }
    translate([-RING_SPIKE_OFFSET_X, -(RING_SPIKE_OFFSET_Y + HOLE_HEIGHT), -RING_THICKNESS/2]) {
        rotate(90, [-1, 0, 0]) {
            rotate(20, [0, 1, 0]) {
                spike(radius=RING_SPIKE_BASE_R, height=RING_SPIKE_LENGTH);
            }
        }
    }
    translate([RING_SPIKE_OFFSET_X, (RING_SPIKE_OFFSET_Y + HOLE_HEIGHT), RING_THICKNESS/2]) {
        rotate(90, [1, 0, 0]) {
            rotate(20, [0, -1, 0]) {
                spike(radius=RING_SPIKE_BASE_R, height=RING_SPIKE_LENGTH);
            }
        }
    }
    translate([RING_SPIKE_OFFSET_X, -(RING_SPIKE_OFFSET_Y + HOLE_HEIGHT), RING_THICKNESS/2]) {
        rotate(90, [-1, 0, 0]) {
            rotate(20, [0, -1, 0]) {
                spike(radius=RING_SPIKE_BASE_R, height=RING_SPIKE_LENGTH);
            }
        }
    }
}