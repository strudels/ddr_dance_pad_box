
enclosure_inner_length = 60;
enclosure_inner_width = 40;
enclosure_inner_depth = 30;

enclosure_thickness = 2;

cover_thickness = 3;

part = "enclosure"; // [enclosure:Enclosure, cover:Cover, both:Enclosure and Cover]

print_part();

// Positive vga_port dye. This object will need to be subtracted (e.g. via difference())
// from something to make a hole.
module vga_port(in_x, in_y, in_z) {
	translate([in_x, in_y, in_z]) rotate([0, 90, 90]) union() {
		// vga object taken from the WALLY_Customizer project
		translate([0,-12.5,3]) cylinder(r=1.75, h=10, center = true);
		translate([0,12.5,3]) cylinder(r=1.75, h=10, center = true);
		difference() {
				cube([10,19,13], center=true);
				translate([-5,-9.2,1]) rotate([0,0,-35.6]) cube([4.4,2.4,15], center=true);
				translate([.9,-11.2,0]) rotate([0,0,9.6]) cube([10,4.8,15], center=true);
				translate([4.6,-8.5,0]) rotate([0,0,37.2]) cube([4.4,2.4,15], center=true);
				translate([-5,9.2,1]) rotate([0,0,35.6]) cube([4.4,2.4,15], center=true);
				translate([0.9,11.2,0]) rotate([0,0,-9.6]) cube([10,4.8,15], center=true);
				translate([4.6,8.5,0]) rotate([0,0,-37.2]) cube([4.4,2.4,15], center=true);
		}
	}
}

module print_part() {
	if (part == "enclosure") {
		box2(enclosure_inner_length,enclosure_inner_width,enclosure_inner_depth,enclosure_thickness,enclosure_thickness/2-0.10,cover_thickness);
	} else if (part == "cover") {
		lid2(enclosure_inner_length,enclosure_inner_width,enclosure_inner_depth,enclosure_thickness,enclosure_thickness/2+0.10,cover_thickness);
	} else {
		both();
	}
}

module both() {

box2(enclosure_inner_length,enclosure_inner_width,enclosure_inner_depth,enclosure_thickness,enclosure_thickness/2-0.10,cover_thickness);
lid2(enclosure_inner_length,enclosure_inner_width,enclosure_inner_depth,enclosure_thickness,enclosure_thickness/2+0.10,cover_thickness);

}

module screws(in_x, in_y, in_z, shell) {

	sx = in_x/2 - 4;
	sy = in_y/2 - 4;
	sh = shell + in_z - 12;
	nh = shell + in_z - 4;

translate([0,0,0]) {
	translate([sx , sy, sh]) cylinder(r=1.5, h = 15, $fn=32);
	translate([sx , -sy, sh ]) cylinder(r=1.5, h = 15, $fn=32);
	translate([-sx , sy, sh ]) cylinder(r=1.5, h = 15, $fn=32);
	translate([-sx , -sy, sh ]) cylinder(r=1.5, h = 15, $fn=32);


	translate([-sx , -sy, nh ]) rotate([0,0,-45]) 
		translate([-5.75/2, -5.6/2, -0.7]) cube ([5.75, 10, 2.8]);
	translate([sx , -sy, nh ]) rotate([0,0,45]) 
		translate([-5.75/2, -5.6/2, -0.7]) cube ([5.75, 10, 2.8]);
	translate([sx , sy, nh ]) rotate([0,0,90+45]) 
		translate([-5.75/2, -5.6/2, -0.7]) cube ([5.75, 10, 2.8]);
	translate([-sx , sy, nh ]) rotate([0,0,-90-45]) 
		translate([-5.75/2, -5.6/2, -0.7]) cube ([5.75, 10, 2.8]);
}
}

module bottom(in_x, in_y, in_z, shell) {

	hull() {
   	 	translate([-in_x/2+shell, -in_y/2+shell, 0]) cylinder(r=shell*2,h=shell, $fn=32);
		translate([+in_x/2-shell, -in_y/2+shell, 0]) cylinder(r=shell*2,h=shell, $fn=32);
		translate([+in_x/2-shell, in_y/2-shell, 0]) cylinder(r=shell*2,h=shell, $fn=32);
		translate([-in_x/2+shell, in_y/2-shell, 0]) cylinder(r=shell*2,h=shell, $fn=32);
	}
}

module sides(in_x, in_y, in_z, shell) {
translate([0,0,shell])
// Walls
difference() {

	hull() {
   	 	translate([-in_x/2+shell, -in_y/2+shell, 0]) cylinder(r=shell*2,h=in_z, $fn=32);
		translate([+in_x/2-shell, -in_y/2+shell, 0]) cylinder(r=shell*2,h=in_z, $fn=32);
		translate([+in_x/2-shell, in_y/2-shell, 0]) cylinder(r=shell*2,h=in_z, $fn=32);
		translate([-in_x/2+shell, in_y/2-shell, 0]) cylinder(r=shell*2,h=in_z, $fn=32);
	}

	hull() {
   	 	translate([-in_x/2+shell, -in_y/2+shell, 0]) cylinder(r=shell,h=in_z+1, $fn=32);
		translate([+in_x/2-shell, -in_y/2+shell, 0]) cylinder(r=shell,h=in_z+1, $fn=32);
		translate([+in_x/2-shell, in_y/2-shell, 0]) cylinder(r=shell,h=in_z+1, $fn=32);
		translate([-in_x/2+shell, in_y/2-shell, 0]) cylinder(r=shell,h=in_z+1, $fn=32);
	}
	vga_port(0, in_y/2, in_z/2);
}

// Beveled edge
intersection() {
	translate([-in_x/2, -in_y/2, shell]) cube([in_x, in_y, in_z+2]);

	union() {
	translate([-in_x/2 , -in_y/2,shell + in_z -6]) cylinder(r=9, h = 6, $fn=64);
	translate([-in_x/2 , -in_y/2,shell + in_z -10]) cylinder(r1=3, r2=9, h = 4, $fn=64);

	translate([in_x/2 , -in_y/2, shell + in_z -6]) cylinder(r=9, h = 6, $fn=64);
	translate([in_x/2 , -in_y/2, shell + in_z -10]) cylinder(r1=3, r2=9, h = 4, $fn=64);

	translate([in_x/2 , in_y/2,  shell + in_z -6]) cylinder(r=9, h = 6, $fn=64);
	translate([in_x/2 , in_y/2,  shell + in_z -10]) cylinder(r1=3, r2=9, h = 4, $fn=64);

	translate([-in_x/2 , in_y/2, shell + in_z -6]) cylinder(r=9, h = 6, $fn=64);
	translate([-in_x/2 , in_y/2, shell + in_z -10]) cylinder(r1=3, r2=9, h = 4, $fn=64);
	}

}
}

module lid_top_lip2(in_x, in_y, in_z, shell, top_lip, top_thickness) {

	cxm = -in_x/2 - (shell-top_lip);
	cxp = in_x/2 + (shell-top_lip);
	cym = -in_y/2 - (shell-top_lip);
	cyp = in_y/2 + (shell-top_lip);

	translate([0,0,shell+in_z])

difference() {

	hull() {
   	 	translate([-in_x/2+shell, -in_y/2+shell, 0]) cylinder(r=shell*2,h=top_thickness, $fn=32);
		translate([+in_x/2-shell, -in_y/2+shell, 0]) cylinder(r=shell*2,h=top_thickness, $fn=32);
		translate([+in_x/2-shell, in_y/2-shell, 0]) cylinder(r=shell*2,h=top_thickness, $fn=32);
		translate([-in_x/2+shell, in_y/2-shell, 0]) cylinder(r=shell*2,h=top_thickness, $fn=32);
	}

	
	translate([0, 0, -1]) linear_extrude(height = top_thickness + 2) polygon(points = [
		[cxm+5, cym],
		[cxm, cym+5],
		[cxm, cyp-5],
		[cxm+5, cyp],
		[cxp-5, cyp],
		[cxp, cyp-5],
		[cxp, cym+5],
		[cxp-5, cym]]);
}
}

module lid2(in_x, in_y, in_z, shell, top_lip, top_thickness) {

	cxm = -in_x/2 - (shell-top_lip);
	cxp = in_x/2 + (shell-top_lip);
	cym = -in_y/2 - (shell-top_lip);
	cyp = in_y/2 + (shell-top_lip);	

difference() {
	translate([0, 0, in_z+shell]) linear_extrude(height = top_thickness ) polygon(points = [
		[cxm+5, cym],
		[cxm, cym+5],
		[cxm, cyp-5],
		[cxm+5, cyp],
		[cxp-5, cyp],
		[cxp, cyp-5],
		[cxp, cym+5],
		[cxp-5, cym]]);
		

		screws(in_x, in_y, in_z, shell);

	
}
}

module box2(in_x, in_y, in_z, shell, top_lip, top_thickness) {
	bottom(in_x, in_y, in_z, shell);
	difference() {
		sides(in_x, in_y, in_z, shell);
		screws(in_x, in_y, in_z, shell);
	}
	lid_top_lip2(in_x, in_y, in_z, shell, top_lip, top_thickness);
}



