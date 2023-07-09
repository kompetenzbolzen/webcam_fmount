$fn=50;

// diameter (not radius!)
throat = 44.5;
inner = 47.5;
outer = 57;

lip_width = 1.7;
lip_height = 1.9;
lip_positions = [[50,-35], [55,-155], [55,-270]];
lip_offset = 0.8;

flange_height = 10;

module rounding_circle(radius, corner_radius, angle) {
  rotate_extrude() {
    translate([radius, angle>=180?corner_radius:0]) difference() {
      rotate([0,0,angle]) square(corner_radius);
      circle(corner_radius);
    }
  }
}

module lip(angle, offs) {
  rotate([0,0,offs]) translate([0,0,lip_height/2])
   rotate_extrude(angle=angle)
    translate([inner/2 +0.1 - lip_width/2,0,0]) square([lip_width,lip_height], center=true);
}

module nikon_f_flange() {
  difference() {
    linear_extrude(flange_height) difference() {
      circle(outer/2);
      circle(inner/2);
    }
    translate([0,0,flange_height-1]) rounding_circle(29,1,0);
  }

  translate([0,0,flange_height - lip_height - lip_offset]) {
    for (i = lip_positions) {
      lip(i[0],i[1]);
    }
  }

}

screw_distance = 18.6;
mount_base = 13.3;
mount_wall = 1.2;
sensor_distance = 46.5;

base_thickness = 4;
// if the sensor pertrudes from the mounting plane
sensor_offset = 1;

module filter_mount() {
  tolerance = 0.6;
  l = 6.5 + tolerance;
  h = 1.5;
  lip = 0.3;
  lip_h = 0.6;

  translate([0,0,-h]) {
    linear_extrude(lip_h) difference() {
      square(l, center=true);
      offset(delta=-lip) square(l, center=true);
    }

    linear_extrude(h) difference() {
      square(mount_base-mount_wall, center=true);
      square(l, center=true);
    }

    slant_h = base_thickness;
    translate([0,0,-slant_h]) difference() {
      linear_extrude(slant_h)
        square(mount_base-mount_wall, center=true);
      linear_extrude(slant_h, scale=(l - 2*lip)/(mount_base-mount_wall))
        square(mount_base-mount_wall, center=true);
    }
  }
}

module screwpost_2d() {
  r = 2;
  screw=1;
  difference() {
    union() {
      circle(r);
      translate([0,-r]) square([(screw_distance-mount_base)/2,2*r]);
    }

    circle(screw);
  }
}

module mount_base_2d() {
  difference() {
    square(mount_base,center=true);
    offset(-mount_wall) square(mount_base, center=true);
  }
}

module sensor_mount() {
  mount_base_2d();
  translate([-screw_distance/2,0]) screwpost_2d();
  translate([ screw_distance/2,0]) rotate([0,0,180]) screwpost_2d();
}


translate([0,0,base_thickness]) {
  h = sensor_distance-flange_height-base_thickness;
  difference() {
    hull() {
      linear_extrude(0.01) square(mount_base, center=true);
      translate([0,0,h]) linear_extrude(0.01) circle(d=outer);
    }
    hull() {
      linear_extrude(0.01) offset(-mount_wall)square(mount_base, center=true);
      translate([0,0,h]) linear_extrude(0.01) circle(d=inner);
    }
  }
}

translate([0,0,-sensor_offset]) linear_extrude(base_thickness + sensor_offset) sensor_mount();
translate([0,0,sensor_distance-flange_height]) nikon_f_flange();
translate([0,0,base_thickness + sensor_offset]) filter_mount();
