ROUNDED_TIP_R = 0.4;

module spike(radius, height) {
    minkowski() {
        cylinder(h=height - 2 * ROUNDED_TIP_R, r1=radius - ROUNDED_TIP_R, r2=0, center=false);
        sphere(r=ROUNDED_TIP_R);
    }
}