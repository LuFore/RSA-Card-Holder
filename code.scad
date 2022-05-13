module clip(wall,x,y,z){
	module trap(x,y,z){//trapezoid
		module trap_edge(mv,x,y,z){
			translate([mv,0,0])
			rotate([0,0,45])
			cube([x,y,z]);
		}
		difference(){
			translate([-x,0,0])
			cube([x*2,y,z]);
			union(){ //make shape
				trap_edge( x,x*2,y*2,z);
				trap_edge(-x,x*2,y*2,z);
			};
		};
	};
	difference(){
    trap(x+wall*2,y+wall,z);
    trap(x,y,z);
    };
};

module card (x,y,z){ //ID card for holder
	cube([x,y,z]);
};


module RSA(bulb_dia,total_length,height,end_dia){
//wierd RSA bulb shape translate([bulb_dia/2,0,height/2])
	union(){
		cylinder(d=bulb_dia,h=height,center=true);
		translate([(total_length-bulb_dia/2)/2,0,0])
	//may need to change end 2 around
		cube([total_length-bulb_dia/2,end_dia,height],true);
	};
};

module card_handles(x,y,z,clip_len,clip_height,clip_wall){
	union(){
		cube([x,y,z]);
		translate([x/2,y/2,0])
		for(i=[0:1])rotate([0,0,180*i])translate([0,y/2,0])
			clip(clip_wall,clip_len,clip_height,z);
	};
}


module RSA_holder(rsa_bulb,rsa_len,rsa_height,rsa_width,wall){
	translate([rsa_bulb/2 + wall, rsa_bulb/2 + wall,(rsa_height+wall)/2])//de-center
	difference(){
		RSA(rsa_bulb+wall*2,rsa_len+wall*2,rsa_height+wall,rsa_width+wall*2);
		union(){
			translate([0,0,-wall])
			RSA(rsa_bulb       ,rsa_len     ,rsa_height  ,rsa_width);
			translate([0, 0,wall])
			RSA(rsa_bulb-wall*2,rsa_len-wall*2,rsa_height,rsa_width-wall*2);
		};
	};
};


module card_cutout(x,y,z,wall){
 union(){
		card(x,y,z);
		translate([wall,wall,wall])
		card(x-wall*2,y-wall*2,wall+z);
	};
};


module handle_cutout(x,y,z,midspace){
	union(){
		for(i=[0:1])rotate([0,180*i,0])translate([midspace/2,0,0])
			cube([x,y,z]);
	};
};



module holder(wall,
	card_x, card_y, card_z,
	clip_len,clip_height,
	rsa_bulb,rsa_len,rsa_height,rsa_width){

	RSA_correction = [(card_x-rsa_len)/2,(card_y-rsa_bulb)/2,wall];

	difference(){
		union(){
			translate([0,0,0])
			card_handles(card_x+wall*2,card_y+wall*2, card_z+wall*2, clip_len,clip_height,wall);
			translate(RSA_correction)mirror([0,0,1])RSA_holder(rsa_bulb,rsa_len,rsa_height,rsa_width,wall);
		}
	//cutout portion
		union(){
			translate([wall,-wall*4,wall])
				card(card_x,card_y+wall*4,card_z);
			translate([wall*2,wall*2,wall])
				card(card_x-wall*2,card_y-wall*2,wall+card_z);
			translate([rsa_bulb/2 + wall, rsa_bulb/2 + wall,0])//de-center
			translate(RSA_correction)RSA(rsa_bulb,rsa_len,rsa_height,rsa_width);
		};
	};
};

holder(
	3,//wall thickness
	85.5, 53.8 ,0.7 ,//card size
	20  , 5,         //size of tabs
	27.1, 78   ,10  ,20.1//rsa bulb
	);
