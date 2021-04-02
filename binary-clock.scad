led_gap = 11.6;
led_edge = 5;
width = led_edge * 2 + led_gap * 3;
length = led_edge * 6 + led_gap * 7;
height = 57; 

module hours_and_minutes() {
  for ( led_position = [led_gap : led_gap+led_edge : length - led_gap ] ){
    translate([led_gap, led_position, 1]) cube([led_edge,led_edge,5]);  
  };

  for ( led_position = [led_gap : led_gap+led_edge : length - led_gap * 2] ){
    translate([led_gap*2+led_edge, led_position, 1]) cube([led_edge,led_edge,5]); 
  };
}

module esp32() {
  esp32_length = height+5;
  cube([width,esp32_length,2]);  
  translate([19, esp32_length - 14, 0]) { 
    difference() {
      cylinder($fn=128, h = 4, d = 4);
      cylinder($fn=128, h = 5, d = 2);
    }
  }
  translate([width-5, esp32_length - 53, 0]) {
    difference() {
      cylinder($fn=128, h = 4, d = 4);
      cylinder($fn=128, h = 5, d = 2);  
    }
  }

}

module front(case_width,case_length,case_height) {
  intersection() {
    translate([0,0,-12]) rotate([80,0,0]) cube([case_width,case_height*2,2]);
    translate([0,0,0]) cube([case_width,case_length,case_height]);
  }
}

module back(case_width,case_length,case_height) {
  translate([0,case_length+10.2,case_height]) rotate([180,0,0]) front(case_width,case_length,case_height);
}

module case_brick() {
  hull() {
    front(width,length,height);
    back(width,length,height);
  }
}

module case_space(wall_width) {
  hull() {
    translate([wall_width,-wall_width,wall_width]) {
      front(width-wall_width*2,length,height);
      back(width-wall_width*2,length,height);
    }
  }  
}

module touch_sensor() { 
  touch_sensor_length = 20;

  translate([0,length,0]) rotate([80,0,0])  {
    //cube([width,height,2]);

    translate([width/2-10, (height/2) - 6 + 10, 0]) { 
      translate([20,0,0]) difference() {
        cylinder($fn=128, h = 4, d = 4);
        cylinder($fn=128, h = 5, d = 2);
      }
    }

    translate([width/2-10, (height/2) - 6 - 10, 0]) { 
      difference() {
        cylinder($fn=128, h = 4, d = 4);
        cylinder($fn=128, h = 5, d = 2);
      }
    }

  }
}

module leg() {
  difference() {
    cylinder($fn=128, h = 4, d = 4);
    cylinder($fn=128, h = 5, d = 2);
  }
}

module case() {
  difference() {
    case_brick();
    case_space(2);
    hours_and_minutes();
  }
  cover_guides();
  touch_sensor();
  translate([width/2,length/3,0]) leg();
  translate([width/2,length/1.5,0]) leg(); 
}

module cover_guides() {
  difference() {
    translate([0,14.8,height-4]) {

      intersection() {
        union() {
          cube([6,length-7,2]);
          //translate([1,0,-8.6]) rotate([0,-60,0]) cube([10,length,6]);
        }
        //translate([0,0,-10]) cube([6,length-7,12]);
      }

      intersection() {
        union() {
          translate([width-6,0,0]) {
            cube([6,length-7,2]);
            //translate([0,0,0]) rotate([0,60,0]) cube([10,length,6]);
          }
        }
        //translate([width-6,0,-10]) cube([6,length-7,12]);
      }

    }
    translate([width-4,length+4,0]) cylinder($fn=128, h = 70, d = 1.75);
    translate([4,length+4,0]) cylinder($fn=128, h = 70, d = 1.75);
  }
  rotate([80,0,0]) {
    //translate([width-6,2,-9]) cube([6,54.74,4]);
    //translate([0,2,-9]) cube([6,54.74,4]);
    
    difference() {
      translate([width-6,1,-5.6]) cube([6,5,4]);
      translate([width-4,4.4,-8]) cylinder($fn=128, h = 7, d = 1.75);
    }
    difference() {
      translate([0,1,-5.6]) cube([6,5,4]);
      translate([4,4.4,-8]) cylinder($fn=128, h = 7, d = 1.75);
    }
  }
}



module top_cover() {
  intersection() {
    intersection() {
      case_space(2);
      case_brick();
    }
    translate([width,-0.4,0]) rotate([-80,180,0]) esp32();
  }

  intersection() {
    case_space(2);
    case_brick();
    translate([0,0,height-2]) cube([500,500,2]);
  }

}

module top_cover_with_holes() {
  difference() {
    top_cover();
    translate([(width-8)/2,14,height-3]) cube([8,3,50]); // micro usb
    rotate([80,0,0]) {
      translate([width-4,4.4,-5]) cylinder($fn=128, h = 7, d = 1.75);
      translate([4,4.4,-50]) cylinder($fn=128, h = 70, d = 1.75);
    }

    translate([width-4,length+4,0]) cylinder($fn=128, h = 70, d = 1.75);
    translate([4,length+4,0]) cylinder($fn=128, h = 70, d = 1.75);
  }
}
module display_cover() {
  translate([width+10,0,0]) {
    difference() {
      translate([(width-(led_gap*2+led_edge))/2,led_gap,0]) {
        cube([led_gap*2+led_edge,length-led_gap*2,2]);
      }

      translate([width/2,length/3,-0.1]) cylinder($fn=128, h = 5, d = 2);
      translate([width/2,length/3,1]) cylinder($fn=128, h = 2, d = 4);

      translate([width/2,length/1.5,-0.1]) cylinder($fn=128, h = 5, d = 2);
      translate([width/2,length/1.5,1]) cylinder($fn=128, h = 2, d = 4);
    }
  }
}

//rotate([0,-90,0]) translate([-2,0,0]) top_cover_with_holes();
case();
//display_cover();
