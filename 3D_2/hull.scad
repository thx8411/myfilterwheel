
$fn=90;

gap=0.2;

wall=2;
base_h=4;

// screws
s_recess=4;
s_out_d=6;

// motor
motor_d=28;
motor_screw_spacing=35;
motor_screw_in_d=4;
motor_screw_out_d=7;
motor_screw_thread_d=3.2;
motor_shaft_spacing=8;

// plate
plate_w=motor_screw_spacing+7;
plate_l=59;
plate_h=17+base_h;
plate_hedge=3;
tip_d=10;

module screw_recess_neg() {
    // motor piers
    translate([motor_screw_spacing/2,-motor_shaft_spacing,plate_h-5]) {
        cylinder(plate_h, d=s_out_d);
    }
    translate([-motor_screw_spacing/2,-motor_shaft_spacing,plate_h-5]) {
        cylinder(plate_h, d=s_out_d);
    }
    // end piers
    translate([-motor_screw_spacing/2,-plate_l-motor_shaft_spacing,plate_h-5]) {
        cylinder(plate_h, d=s_out_d);
    }
    translate([motor_screw_spacing/2,-plate_l-motor_shaft_spacing,plate_h-5]) {
        cylinder(plate_h, d=s_out_d);
    }    
}

module plate_pos() {
    // motor
    hull() {
        // motor piers
        translate([motor_screw_spacing/2,-motor_shaft_spacing,0]) {
            cylinder(plate_h, d=motor_screw_out_d+2*wall);
        }
        translate([-motor_screw_spacing/2,-motor_shaft_spacing,0]) {
            cylinder(plate_h, d=motor_screw_out_d+2*wall);
        }
        // end piers
        translate([-motor_screw_spacing/2,-plate_l-motor_shaft_spacing,0]) {
            cylinder(plate_h, d=motor_screw_out_d+2*wall);
        }
        translate([motor_screw_spacing/2,-plate_l-motor_shaft_spacing,0]) {
            cylinder(plate_h, d=motor_screw_out_d+2*wall);
        }
        
    }
    // tip
    translate([0,-plate_l-motor_shaft_spacing-motor_screw_out_d/2-2,0]) {
        cylinder(plate_h, d=tip_d+2*wall);
    }
}

module plate_neg() {
    hull() {
        // shaft
        translate([0,-motor_shaft_spacing,0]) {
            cylinder(4, d=motor_d);
        }
        // motor piers
        translate([motor_screw_spacing/2,-motor_shaft_spacing,0]) {
            cylinder(4, d=motor_screw_out_d);
        }
        translate([-motor_screw_spacing/2,-motor_shaft_spacing,0]) {
            cylinder(4, d=motor_screw_out_d);
        }
    }
    hull() {
        // motor piers
        translate([motor_screw_spacing/2,-motor_shaft_spacing,0]) {
            cylinder(plate_h-wall, d=motor_screw_out_d);
        }
        translate([-motor_screw_spacing/2,-motor_shaft_spacing,0]) {
            cylinder(plate_h-wall, d=motor_screw_out_d);
        }
        // end piers
        translate([-motor_screw_spacing/2,-plate_l-motor_shaft_spacing,0]) {
            cylinder(plate_h-wall, d=motor_screw_out_d);
        }
        translate([motor_screw_spacing/2,-plate_l-motor_shaft_spacing,0]) {
            cylinder(plate_h-wall, d=motor_screw_out_d);
        }
    }
    
    // motor piers
    translate([motor_screw_spacing/2,-motor_shaft_spacing,0]) {
        cylinder(plate_h, d=motor_screw_thread_d);
    }
    translate([-motor_screw_spacing/2,-motor_shaft_spacing,0]) {
        cylinder(plate_h, d=motor_screw_thread_d);
    }
    // end piers
    translate([-motor_screw_spacing/2,-plate_l-motor_shaft_spacing,0]) {
        cylinder(plate_h, d=motor_screw_thread_d);
    }
    translate([motor_screw_spacing/2,-plate_l-motor_shaft_spacing,0]) {
        cylinder(plate_h, d=motor_screw_thread_d);
    }
    
    // tip
    translate([0,-plate_l-motor_shaft_spacing-motor_screw_out_d/2-2,0]) {
        cylinder(plate_h-wall, d=tip_d+gap);
    }
    
    // motor hole
    translate([0,-motor_shaft_spacing,0]) {
        cylinder(plate_h, d=motor_d+1);
    }
    
    screw_recess_neg();
    
    // usb hole
    translate([motor_screw_spacing/2+3.5,-11-50+1.5,9-3.5]) {
        cube([wall,11,7]);
    }
}



// main hull
difference() {
    union() {
        plate_pos();
    }
    plate_neg();
}

// inside piers
difference() {
    union() {
        // motor piers
        translate([motor_screw_spacing/2,-motor_shaft_spacing,base_h+0.5]) {
            cylinder(plate_h-wall-base_h-0.5, d=motor_screw_out_d);
        }
        translate([-motor_screw_spacing/2,-motor_shaft_spacing,base_h+0.5]) {
            cylinder(plate_h-wall-base_h-0.5, d=motor_screw_out_d);
        }
        // end piers
        translate([-motor_screw_spacing/2,-plate_l-motor_shaft_spacing,base_h]) {
            cylinder(plate_h-wall-base_h, d=motor_screw_out_d);
        }
        translate([motor_screw_spacing/2,-plate_l-motor_shaft_spacing,base_h]) {
            cylinder(plate_h-wall-base_h, d=motor_screw_out_d);
        }
    }
    
    // motor piers
    translate([motor_screw_spacing/2,-motor_shaft_spacing,0]) {
        cylinder(plate_h, d=motor_screw_thread_d);
    }
    translate([-motor_screw_spacing/2,-motor_shaft_spacing,0]) {
        cylinder(plate_h, d=motor_screw_thread_d);
    }
    // end piers
    translate([-motor_screw_spacing/2,-plate_l-motor_shaft_spacing,0]) {
        cylinder(plate_h, d=motor_screw_thread_d);
    }
    translate([motor_screw_spacing/2,-plate_l-motor_shaft_spacing,0]) {
        cylinder(plate_h, d=motor_screw_thread_d);
    }
    
    // motor hole
    translate([0,-motor_shaft_spacing,0]) {
        cylinder(plate_h, d=motor_d+1);
    }
    
    // screws recess
    screw_recess_neg();
    
}