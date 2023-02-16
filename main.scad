use <bridge.scad>
use <ring.scad>
use <spike.scad>

RING_WIDTH = 17.5;
RING_HEIGHT = 7.5;

HOLE_WIDTH = 13;
HOLE_HEIGHT = 5;

RING_THICKNESS = 2.5;

HOLE_OFFSET = -2.25;
HALFRING_OFFSET = 0.5;

BRIDGE_LENGTH = 7.5;

SIDE_SPIKE_LENGTH = 6.5;
SIDE_SPIKE_BASE_R = 1;

RING_SPIKE_LENGTH = 4.5;
RING_SPIKE_BASE_R = 1;
RING_SPIKE_OFFSET_X = 11.5;
RING_SPIKE_OFFSET_Y = 0.5;
RING_SPIKE_ROTATION_DEG = 1;

CONNECTOR_SPIKE_LENGTH = 2.5;
CONNECTOR_SPIKE_BASE_R = 1;

CAP_THICKNESS = 0.5;
CAP_SPREAD = 0.5;

// epsilon to ensure intersection
EPS = 0.001;
// epsilon to ensure non-intersection
HOLE_EPS = 0.2;

DISPLAY_OUTER_ONLY = 0;
DISPLAY_INNER_ONLY = 1;
DISPLAY_BOTH = 2;
DISPLAY_ASSEMBLED = 3;

DISPLAY_MODE = DISPLAY_ASSEMBLED;

$fn = 64;

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
    if (DISPLAY_MODE == DISPLAY_BOTH) {
        translate([0, 1.5 * RING_HEIGHT, 0]) {
            outer_ring();
        }
        translate([0, -1.5 * RING_HEIGHT, 0]) {
            inner_ring();
        }
    } else if (DISPLAY_MODE == DISPLAY_ASSEMBLED) {
        rotate(90, [1, 0, 0]) {
            outer_ring();
            rotate(90, [0, 1, 0]) {
                inner_ring();
            }
        }
    } else if (DISPLAY_MODE == DISPLAY_OUTER_ONLY) {
        outer_ring();
    } else if (DISPLAY_MODE == DISPLAY_INNER_ONLY) {
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
            cube(size=[BRIDGE_LENGTH, 2*bbco - HOLE_EPS, 999], center=true);
        }
        rotate(90, [1, 0, 0]) {
            cylinder(h=999, r=CONNECTOR_SPIKE_BASE_R + HOLE_EPS, center=true);
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
            semicylinder_offset=HALFRING_OFFSET
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