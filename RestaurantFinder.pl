% CS 312 Project 1

% DATABASE

% restaurant(id, name, cuisine, location, price, rating)

restaurant(bento_sushi).
restaurant(flip_side).
restaurant(grand_noodle_emporium).
restaurant(honour_roll).
restaurant(ike's_cafe).
restaurant(loop_cafe).
restaurant(mercante).
restaurant(the_point_grill).
restaurant(triple_o).

american(flip_side).
american(the_point_grill).
american(triple_o).
cafe(ike's_cafe).
cafe(loop_cafe).
chinese(grand_noodle_emporium).
italian(mercante).
japanese(bento_sushi).
japanese(honour_roll).

location(david_lam_research_centre).
location(the_nest).
location(irving).
location(cirs).
location(ponderosa).
location(marine_residence).

in(bento_sushi, david_lam_research_centre).
in(flip_side, the_nest).
in(grand_noodle_emporium, the_nest).
in(honour_roll, the_nest).
in(ike's_cafe, irving).
in(loop_cafe, cirs).
in(mercante, ponderosa).
in(the_point_grill, marine_residence).
in(triple_o, david_lam_research_centre).

expensive(the_point_grill).
cheap(ike'scafe).
cheap(loop_cafe).
cheap(triple_o).