include <threads.scad>

gap=0.2;

rotor_d=145;
rotor_h=4;

filter_offset=45;

wheel_h=22;
hull_h=4;

shaft_d1=15;
shaft_d2=8;
shaft_offset=1.5;

$fn=90;

/////////////////

rotor();
//shaft();
//shaft_ring();

/////////////////

module byj_hole() {
    // 28BYJ shaft hole
    intersection() {
        cylinder(6, d=5);
        translate([-2.5,-1.5,0]) {
            cube([5,3,6]);
        }
    }
}

module rotor() {
    difference() {
        // positiv
        union() {
            // main disk
            cylinder(rotor_h, d=rotor_d);

            // shaft
            cylinder(rotor_h+shaft_offset, d=shaft_d1);
            cylinder(rotor_h+shaft_offset+hull_h, d=shaft_d2);
        }
    
        // negativ
        union() {
            // filter holders
            for ( i = [0 : 5] ){
                rotate([0,0,72*i]) {
                    translate([filter_offset,0,0]) {
                        //
                        metric_thread (diameter=48.3, pitch=0.75, length=rotor_h, internal=true);
                        //
                        //cylinder(rotor_h, d=48.3);
                        //
                    }
                }
            }
        
            // motor shaft
            translate([0,0,rotor_h+shaft_offset+hull_h-6]) {
                byj_hole();
            }
        
            // shaft hole
            cylinder(rotor_h/2,d=shaft_d2+gap);
            
            // magnet hole
            translate([-rotor_d/2+2,0,2]) {
                cylinder(2, d=4);
            }
        }
    }
}

module shaft() {
    cylinder(wheel_h-rotor_h-hull_h-shaft_offset+rotor_h/2, d=shaft_d2+gap);
}

module shaft_ring() {
    difference() {
        cylinder(wheel_h-rotor_h-hull_h-shaft_offset+rotor_h/2-hull_h-rotor_h/2, d=shaft_d1);
        cylinder(wheel_h-rotor_h-hull_h-shaft_offset+rotor_h/2-hull_h-rotor_h/2, d=shaft_d2+3*gap);
    }
}
