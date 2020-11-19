/*
This is a 3d printable ROM carrier for mounting ROMs in the capsule sockets of the Epson PX-8 and PX-4 computers.

When printing you will need to enable supports to allow the horizontal tabs to print successfully.

Andy Anderson 2020
*/

// Dimension of the flat base
base_width = 16.6;
base_depth = 37.9;
base_height = 3;

// The distance between centres of the IC legs
pin_spacing = 2.54;

// Count of pins per side of the IC
pin_count = 14;

// IC leg dimension
pin_width = 2;
pin_clearance = 0.1;


// The gap cut into the base for each IC leg
pin_cut_depth = 1;
pin_gap = pin_width + pin_clearance;

// The size of the non-cut space between each IC leg
pin_non_gap = pin_spacing - pin_gap;

// The total base length that needs cuts for IC legs (easier to centre it)
active_pin_area = ((pin_count-1) * pin_non_gap) + (pin_count * pin_gap);
pin_start = (base_depth - active_pin_area)/2;

// The end wall dimensions
end_width = 19;
end_depth = 1;
end_height = 8;

// End wall strengthening bar dimensions
strength_width = 1.8;
strength_depth = 1.5;
strength_height = end_height;

// The dimensions of the flat tab on top of each end wall
tab_width = 9;
tab_depth = 4;
tab_height = 1;

// The dimensions of the locating tangs on each end wall
tang_width = 1.5;
tang_depth = 2;
tang_height = 4;


module base()
{
    difference()
    {
        cube([base_width, base_depth, base_height]);
        for(leg = [0: 1: pin_count-1])
        {
            translate([-pin_cut_depth, pin_start+(leg*pin_spacing), -1])
                cube([pin_cut_depth*2, pin_width, base_height+2]);
            
            translate([base_width-pin_cut_depth, pin_start+(leg*pin_spacing), -1])
                cube([pin_cut_depth*2, pin_width, base_height+2]);
        }
    }
}

// End with single tang and chamfered strengtheners
module end1()
{
    union()
    {
        // End wall
        cube([end_width, end_depth, end_height]);
        
        // Wall strength - with hacky chamfer
        hull()
        {
            cube([strength_width/2, end_depth, strength_height]); 
            translate([strength_width/2, 0, 0])
                cube([strength_width/2, strength_depth, strength_height]);        
        }
        
        hull()
        {
            translate([end_width-strength_width/2, 0, 0])
                cube([strength_width/2, end_depth, strength_height]); 
            translate([end_width-strength_width, 0, 0])
                cube([strength_width/2, strength_depth, strength_height]);
        }
                
        // Horizontal tab
        translate([end_width/2 - tab_width/2, -tab_depth, end_height-tab_height])
            cube([tab_width, tab_depth, tab_height]);
        
        // Single tang
        translate([end_width/2 - tang_width/2, -tang_depth, end_height-tang_height-tab_height])
            cube([tang_width, tang_depth, tang_height]);
    }
}

// End with double tang
module end2()
{
    union()
    {
        // End wall
        cube([end_width, end_depth, end_height]);
       
        // Wall strengthener
        cube([strength_width, strength_depth, strength_height]);
        
        translate([end_width-strength_width, 0, 0])
            cube([strength_width, strength_depth, strength_height]);
        
        // Horizontal tab
        translate([end_width/2 - tab_width/2, -tab_depth, end_height-tab_height])
            cube([tab_width, tab_depth, tab_height]);
        
        // double tangs
        translate([end_width/2-tab_width/2, -tang_depth, end_height-tang_height-tab_height])
            cube([tang_width, tang_depth, tang_height]);
        
        translate([(end_width/2+tab_width/2)-tang_width, -tang_depth, end_height-tang_height-tab_height])
            cube([tang_width, tang_depth, tang_height]);
    }
}

module carrier()
{
    union()
    {
        translate([0, -end_depth, 0])
            end1();
        
        translate([(end_width-base_width)/2, 0, 0])
            base();
        
        translate([end_width, base_depth + end_depth, 0])
            rotate(a = [0, 0, 180])
                end2();
    }
}





carrier();
