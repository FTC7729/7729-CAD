// Parametric Modular Rack Andrew Ziobro
//Based on the work of MattMoses and Fdavies and Mark "Ckaos" Moissette:
//http://forums.reprap.org/read.php?1,51452,52099#msg-52099
//and Forrest Higgs:
// http://technocraticanarchist.blogspot.com/2010/01/high-speed-alternative-to-belts.html
//and http://www.thingiverse.com/thing:6011 info at :www.kaosat.net 
//and http://www.thingiverse.com/thing:3575 Parametic_involute_gear_v5.0
//It is licensed under the Creative Commons - GNU GPL license.
// © 2011 by Andrew Ziobro


//Download parametric_involute_gear_v5.0.scad from http://www.thingiverse.com/thing:3575
use <parametric_involute_gear_v5.0.scad>;

$fn=50;
pi=3.1415926535897932384626433832795;
innerRadius=3.1;//shaft radius, in mm
borders=2.5;//how thick should the borders around the central "shaft" be, in mm
diametralPitch=12; // was 12
numberOfTeeth=43;
pressureAngle=20*pi/180;
centerAngle=25;//angle at center of teeth

// Uncomment a line below to make a part.
//makeTetrixDoubleRack(); Make a rack
//makeTetrixGearLeft(); //Make a Gear Left
//translate([20,0,0]) makeTetrixGearRight();
//makeTetrixPlate(); //Makes a Tetrix Plate with holes.


module makeTetrixHole(d1=8,d2=3.7,rd2=16,nh=8,tn=3)
{
//d1 = 8; //Diameter of Center Hole
//d2 = 3.7; //Diameter of Outside Holes
//rd2 = 16; //Diameter of Circle for Outside Holes 
//nh = 8; //Number of Holes
//tn = 3; //Thickness of cut
  	union(){
	translate([0,0,0]){
		cylinder(h=tn,r=d1/2,center=true);
	}
	for (i=[0:nh])
		{
		 rotate(i*360/nh)
			translate([0,rd2/2,0])
			 cylinder(h=tn,r=d2/2,center=true);
		}
   }
}


module makeTetrixGearLeft()
{ difference() 
	{
		demo_gear();//test_double_helix_gear();
		rotate([0,90,0]) translate([0,8,0]) union(){
			cylinder(h=40,r=3.7/2,center=true);
			translate([0,0,-2.4]) cylinder(h=5, r=3,center=true,$fn=100);
		}
		rotate([0,90,0]) translate([8,0,0]) union(){
			cylinder(h=40,r=3.7/2,center=true);
			translate([0,0,-2.4]) cylinder(h=5, r=3,center=true,$fn=100);
		}	
		rotate([0,90,0]) translate([-8,0,0]) union(){
			cylinder(h=40,r=3.7/2,center=true);
			translate([0,0,-2.4]) cylinder(h=5, r=3,center=true,$fn=100);
		}
		rotate([0,90,0]) translate([0,-8,0]) union(){
			cylinder(h=40,r=3.7/2,center=true);
			translate([0,0,-2.4]) cylinder(h=5, r=3,center=true,$fn=100);
		}
	}	
}	

module makeTetrixGearRight()
{ difference() 
	{
		demo_gear();//test_double_helix_gear();
		rotate([0,90,0]) translate([0,8,0]) union(){
			cylinder(h=40,r=3.7/2,center=true);
			translate([0,0,-12+2.4]) cylinder(h=5, r=3,center=true,$fn=100);
		}
		rotate([0,90,0]) translate([8,0,0]) union(){
			cylinder(h=40,r=3.7/2,center=true);
			translate([0,0,-12+2.4]) cylinder(h=5, r=3,center=true,$fn=100);
		}	
		rotate([0,90,0]) translate([-8,0,0]) union(){
			cylinder(h=40,r=3.7/2,center=true);
			translate([0,0,-12+2.4]) cylinder(h=5, r=3,center=true,$fn=100);
		}
		rotate([0,90,0]) translate([0,-8,0]) union(){
			cylinder(h=40,r=3.7/2,center=true);
			translate([0,0,-12+2.4]) cylinder(h=5, r=3,center=true,$fn=100);
		}
	}	
}	

//example usage
module makeTetrixDoubleRack()
{
difference(){ 
	union(){ rack(innerRadius,borders,diametralPitch,numberOfTeeth,pressureAngle,centerAngle);
	         rotate(a=[180,0,0]) translate([0,0,-11.2]) rack(innerRadius,borders,diametralPitch,numberOfTeeth,pressureAngle,centerAngle);
	}
	rotate([0,0,90]) for(i=[-7:7]) translate([0,i*16+4,0]) cylinder(h=24 ,r=3.7/2,center=true,$fn=100);
	rotate([0,0,90]) for(i=[-7:7]) translate([0,i*16+4,9]) cylinder(h=5, r=3,center=true,$fn=100);
	translate([97,-20,-20])cube([200,40,40]); //Cut Off Ends
	rotate([0,0,180]) translate([97,-20,-20])cube([200,40,40]); //Cut Off Other End
}
}
			
//rotate (a=[0,0,0]) translate([0,0,-1]) difference(){

	

module makeTetrixPlate(sw=64)
{
	difference(){
		translate([0,0,0]){
			cube(size=[sw+32,32,2],center=true);
		}
	for(i=[0:2:sw/32/2+2])
	 {
      translate([16*i,0,0]) makeTetrixHole();
      translate([16*(i+1),0,0]) makeTetrixHole(nh=4);
      translate([16*(-i),0,0]) makeTetrixHole();
      translate([16*(-i-1),0,0]) makeTetrixHole(nh=4);

     }

	}
	
}



module rack(innerRadius,borders,P,N,PA,CA)
{
	// P = diametral pitch
	// N = number of teeth
	// PA = pressure angle in radians
	// x, y = linear offset distances
	a = 1/P; // addendum (also known as "module")
	d = 1.25/P; // dedendum (this is set by a standard)
	multiplier=20;//20
	height=(d+a)*multiplier;
	echo(height);
	
	// find the tangent of pressure angle once
	tanPA = tan(PA*(180/pi));
	// length of bottom and top horizontal segments of tooth profile
	botL = (pi/P/2 - 2*d*tanPA)*multiplier;
	topL =( pi/P/2 - 2*a*tanPA)*multiplier;

	slantLng=tanPA*height;
	realBase=2*slantLng+topL;
	
	
	offset=topL+botL+2*slantLng;
	length=(realBase+botL)*N;
	echo("Offset:",offset);
	supportSize=(innerRadius+borders)*2;

	//calculate tooth params
	basesegmentL=realBase/2;
	basesegmentW=supportSize/2;

	topsegmentL=topL/2;
	topsegmentW=supportSize/2;

	baseoffsetY=tan(CA)*basesegmentW;
	topoffsetY=tan(CA)*topsegmentW;
	
	//calculate support params

	totalSupportLength=(N)*(offset);
	supportL=totalSupportLength/2;
	supportW=supportSize/1.99;
	
	echo("Total length",totalSupportLength+baseoffsetY);
	echo("Total height",supportSize);

	
	rotate([90,90,0])
	{
	translate([-supportSize/2,supportSize/2,0])
	{
	union()
	{
		difference()
		{
			support(supportL,supportW,supportSize,baseoffsetY);
			 
		}

	
		for (i = [0:N-1]) 
		{
			translate([0,i*offset-length/2+realBase/2,supportSize/2+height/2]) 
			{	
				
				tooth(basesegmentL,basesegmentW,topsegmentL,topsegmentW,height,baseoffsetY,topoffsetY);
				
			}
		}
	}
	
	}
	}
}

module support(supportL,supportW,height,offsetY)
{
	 tooth(supportL,supportW,supportL,supportW,height,offsetY,offsetY);
}



module tooth(basesegmentL,basesegmentW,topsegmentL,topsegmentW,height,baseoffsetY,topoffsetY)//top : width*length, same for base
{
	
	////////////////
	basePT1=[
	-basesegmentW,
	basesegmentL-baseoffsetY,
	-height/2];

	basePT2=[
	0,
	basesegmentL,
	-height/2];

	basePT3=[
	basesegmentW,
	basesegmentL-baseoffsetY,
	-height/2];

	basePT4=[
	basesegmentW,
	basesegmentL-(baseoffsetY+basesegmentL*2),
	-height/2];
	
	basePT5=[
	0,
	-basesegmentL,
	-height/2];

	basePT6=[
	-basesegmentW,
	basesegmentL-(baseoffsetY+basesegmentL*2),
	-height/2];
	//////////////////////////
	topPT1=[
	-topsegmentW,
	topsegmentL-topoffsetY,
	height/2];

	topPT2=[
	0,
	topsegmentL,
	height/2];

	topPT3=[
	topsegmentW,
	topsegmentL-topoffsetY,
	height/2];

	topPT4=[
	topsegmentW,
	topsegmentL-(topoffsetY+topsegmentL*2),
	height/2];
	
	topPT5=[
	0,
	-topsegmentL,
	height/2];

	topPT6=[
	-topsegmentW,
	topsegmentL-(topoffsetY+topsegmentL*2),
	height/2];
	//////////////////////////

	//////////////////////////

	polyhedron(
	points=[
		basePT1,
		basePT2,
		basePT3,
		basePT4,
		basePT5,
		basePT6,
		topPT1,
		topPT2,
		topPT3,
		topPT4,
		topPT5,
		topPT6],
	triangles=[
	//base
	[5,1,0],
	[4,1,5],
	[4,2,1],
	[3,2,4],	

	//front
	[1,6,0],
	[7,6,1],
	[2,7,1],
	[8,7,2],
	//back
	[11,10,5],
	[5,10,4],
	[10,9,4],
	[4,9,3],	
	//side 1
	[0,11,5],
	[6,11,0],
	//side 2
	[3,8,2],
	[9,8,3],
	//top
	[9,10,8],
	[10,7,8],
	[11,7,10],
	[6,7,11],
	]
	);
}

module demo_gear(position,diametralPitch)
{
	wheelSize=12;
rotate([0,90,180])
translate(position)

{
gear (
	number_of_teeth=32,
//	circular_pitch=300, 
	diametral_pitch=.6,
	pressure_angle=19.34,
	gear_thickness=wheelSize/2,
	rim_thickness=wheelSize/2,
	hub_thickness=0,
	bore_diameter=8,
	backlash=0,twist=centerAngle/4,involute_facets=15);

translate([0,0,wheelSize/2])
rotate([0,0,-centerAngle/4])
gear (
	number_of_teeth=32,
	circular_pitch=300, 
//	diametral_pitch=.6,
	pressure_angle=19.34,
	gear_thickness=wheelSize/2,
	rim_thickness=wheelSize/2,
	hub_thickness=0,
	bore_diameter=8,
	backlash=0,twist=-centerAngle/4,involute_facets=15);

}

}


