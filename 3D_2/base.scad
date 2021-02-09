
$fn=90;

// motor
motor_d=28;
motor_shaft_d=10;
motor_shaft_gap=3.8;
motor_screw_spacing=35;
motor_screw_in_d=4;
motor_screw_out_d=7;
motor_screw_thread_d=3.2;
motor_shaft_spacing=8;

// plate
plate_w=motor_screw_spacing+7;
plate_l=59;
plate_h=motor_shaft_gap;
plate_hedge=3;
tip_d=10;

// screws
screw_t_d=2.8;

// hull
hull_h=4;
hull_gap=1;


module drv_neg() {
    s_d=3;
    s_h=plate_h;
    
    translate([-5,0,0]) {
        cylinder(s_h, d=s_d);
    }
    translate([5,0,0]) {
        cylinder(s_h, d=s_d);
    }
}

module spark_neg() {
    s_s=13.5;
    s_h=plate_h;
    s_d=2.8;
    pier_d=5;
    pier_h=s_h;
    
    translate([0,s_s/2,0]) {
        cylinder(s_h, d=s_d);
    }
    translate([0,-s_s/2,0]) {
        cylinder(s_h, d=s_d);
    }    
}

module plate_pos() {
    // motor
    hull() {
        // shaft
        translate([0,-motor_shaft_spacing,0]) {
            cylinder(motor_shaft_gap, d=motor_d);
        }
        // motor piers
        translate([motor_screw_spacing/2,-motor_shaft_spacing,0]) {
            cylinder(motor_shaft_gap, d=motor_screw_out_d);
        }
        translate([-motor_screw_spacing/2,-motor_shaft_spacing,0]) {
            cylinder(motor_shaft_gap, d=motor_screw_out_d);
        }
        // end piers
        translate([-motor_screw_spacing/2,-plate_l-motor_shaft_spacing,0]) {
            cylinder(plate_h, d=motor_screw_out_d);
        }
        translate([motor_screw_spacing/2,-plate_l-motor_shaft_spacing,0]) {
            cylinder(plate_h, d=motor_screw_out_d);
        }
        
    }
    // tip
    translate([0,-plate_l-motor_shaft_spacing-motor_screw_out_d/2-2,0]) {
        intersection() {
            union() {
                cylinder(plate_h+hull_h, d=tip_d);
                translate([0,0,plate_h+hull_h]) {
                    cylinder(hull_gap, d=tip_d+2);
                }
            }
            /*
            translate([-tip_d/2,2,0]) {
                cube([tip_d,tip_d,plate_h+hull_h+hull_gap]);
            }
            */
        }
    }
}

module plate_neg() {
    // shaft
    cylinder(motor_shaft_gap, d=motor_shaft_d);
    // motor piers
    translate([motor_screw_spacing/2,-motor_shaft_spacing,0]) {
        cylinder(motor_shaft_gap, d=motor_screw_thread_d);
    }
    translate([-motor_screw_spacing/2,-motor_shaft_spacing,0]) {
        cylinder(motor_shaft_gap, d=motor_screw_thread_d);
    }
    // end piers
    translate([-motor_screw_spacing/2,-plate_l-motor_shaft_spacing,0]) {
        cylinder(plate_h, d=screw_t_d);
    }
    translate([motor_screw_spacing/2,-plate_l-motor_shaft_spacing,0]) {
        cylinder(plate_h, d=screw_t_d);
    }
    // tip
    translate([0,-plate_l-motor_shaft_spacing-motor_screw_out_d/2-2,0]) {
        cylinder(plate_h+hull_h+hull_gap, d=tip_d-3);
    }
}


/// MAIN

difference() {
    union() {
        plate_pos();
    }
    plate_neg();
    
    translate([5,-36,0]) {
        drv_neg();
    }
    
    translate([-motor_screw_spacing/2+0.5,-54,0]) {
        spark_neg();
    }
}