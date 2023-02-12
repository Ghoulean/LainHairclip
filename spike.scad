ROUNDED_TIP_R = 0.4;

module spike(radius, height) {
    h = sqrt((height * ROUNDED_TIP_R / radius)^2 + ROUNDED_TIP_R^2);
    union() {
        difference() {
            cylinder(h=height, r1=radius, r2=0, center=false);
            translate([0, 0, height]) {
                cube(size=[999, 999, 2*h], center=true);
            }
        }
        translate([0, 0, height - h]) {
            sphere(r=ROUNDED_TIP_R);
        }
    }
}