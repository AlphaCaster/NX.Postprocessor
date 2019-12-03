#################################################################
# Post for DECKEL DIALOG 11
# Generated by Javier Garcia - UG * 23-Apr-2007
#################################################################

#source [MOM_ask_env_var UGII_CAM_DEBUG_DIR]mom_review.tcl;  MOM_set_debug_mode ON

source [MOM_ask_env_var UGII_CAM_POST_DIR]ugpost_base.tcl

####### KINEMATIC VARIABLE DECLARATIONS ##############
  set mom_kin_arc_output_mode                   "QUADRANT"
  #set mom_kin_arc_output_mode                   "LINEAR"
  set mom_kin_arc_valid_plane                   "XY"
  set mom_kin_helical_arc_output_mode           "LINEAR"
  set mom_kin_machine_resolution                "0.001"
  set mom_kin_machine_type                      "3_axis_mill"
  set mom_kin_max_arc_radius                    "9999.999"
  set mom_kin_min_arc_length                    "0.01"
  set mom_kin_min_arc_radius                    "0.01"
  set mom_kin_output_unit                       "MM"
  set mom_kin_post_data_unit                    "MM"
  set mom_kin_rapid_feed_rate                   "10000"
  set mom_kin_tool_change_time                  "2"



####### M code declaration

set mom_sys_program_stop_code                   1
set mom_sys_optional_stop_code                  1
set mom_sys_end_of_program_code                 30

set mom_sys_spindle_direction_code(CLW)         3
set mom_sys_spindle_direction_code(CCLW)        4
set mom_sys_spindle_direction_code(OFF)         5

set mom_sys_coolant_code(MIST)                  8
set mom_sys_coolant_code(FLOOD)                 8
set mom_sys_coolant_code(TAP)                   8
set mom_sys_coolant_code(OFF)                   9



####### G code declaration

set mom_sys_rapid_code                          1
set mom_sys_linear_code                         1
set mom_sys_circle_code(CLW)                    2
set mom_sys_circle_code(CCLW)                   3

set mom_sys_cutcom_plane_code(XY)               17
set mom_sys_cutcom_plane_code(ZX)               18
set mom_sys_cutcom_plane_code(YZ)               19

set mom_sys_cutcom_code(OFF)                    40
set mom_sys_cutcom_code(LEFT)                   41
set mom_sys_cutcom_code(RIGHT)                  42

set mom_sys_cycle_off                           80
set mom_sys_cycle_drill                         81
set mom_sys_cycle_drill_deep                    83
set mom_sys_cycle_tap(CLW)                      84
set mom_sys_cycle_tap(CCLW)                     74



####### Javi's variables

set coolant_flag                                0
set parametros_avance                           "G64 M62"

##############################
# SHOP DOCUMENTATION
# Set the following line to point to the correct location of the file!
  set jg_html_procs_file C:\\Downloads\\Postprocessors\\DMU\\listado_htas_html.tcl
  if {[file exists $jg_html_procs_file]} {
    source $jg_html_procs_file
    set jg_html_included 1
  } else {
    set jg_html_included 0
  }

##############################

#--------------------------------------------------------------------

proc  MOM_start_of_program {} { }

#--------------------------------------------------------------------

proc  MOM_end_of_program {} {

   global mom_machine_time
   global mom_group_name mom_path_name
   global mom_output_file_full_name
   global mom_output_file_directory
   global jg_html_included

   if {$jg_html_included == 1} {
      JG_foot_of_html ; JG_close_html_file
   }

   MOM_output_literal "G0*1 Z100"
   MOM_output_literal "G0*1 X0 Y0 Z100"
   MOM_do_template end_of_program
   MOM_output_text "?"
   MOM_output_text "0000"
   MOM_output_text "\004"

   set nctime [expr 1.15 * $mom_machine_time]
   MOM_output_to_listing_device "[format "TOTAL TIME: %5.2f MINUTES" $nctime]"

   # Cierra el fichero y lo renombra
   if {[info exists mom_group_name]} {
      set nombre [string range $mom_group_name 1 10 ]
   } else {
      set nombre $mom_path_name
   }
   set extension ".d11"

   MOM_close_output_file $mom_output_file_full_name
   set new_file $mom_output_file_directory$nombre$extension
   file rename -force $mom_output_file_full_name  $new_file
}

#--------------------------------------------------------------------

proc  MOM_start_of_group {} {

   global jg_html_included

   if {$jg_html_included == 1} {
      JG_open_html_file ; JG_start_of_html
   }
}

#--------------------------------------------------------------------

proc  MOM_end_of_group {} { }

#--------------------------------------------------------------------

proc  MOM_start_of_path {} { }

#--------------------------------------------------------------------

proc  MOM_end_of_path {} { }

#--------------------------------------------------------------------

proc  MOM_first_tool {} {

   global mom_group_name mom_path_name
   global mom_part_name
   global mom_seqnum
   global mom_tool_name
   global mom_tool_diameter
   global mom_tool_length
   global mom_tool_corner1_radius
   global jg_html_included

   if {$jg_html_included == 1} {
      JG_write_tool
   }

   if {[info exists mom_group_name]} {
      set nombre [string range $mom_group_name 1 10]
   } else {
      set nombre $mom_path_name
   }
   MOM_output_text "%${nombre}(M-D11-000000- - -)"
   MOM_output_text "?"
   MOM_output_text "0000\n"
   MOM_output_text "%$nombre*T (M-D11-000000- - - )"
   MOM_output_text "T1 I/M:M R0 L0 FE200 FZ200 S4000"
   MOM_output_text "?"
   MOM_output_text "0000"
   MOM_output_text "%$nombre*% (M-D11-000000- - - )"

   set mom_seqnum 20
   MOM_output_literal "\[Part   : $mom_part_name\]"
   MOM_output_literal "\[Tool   : $mom_tool_name\]"
   MOM_output_literal "\[Dia    : [format "%2.2f" $mom_tool_diameter] \]"
   MOM_output_literal "\[Radius : [format "%2.2f" $mom_tool_corner1_radius] \]"
   MOM_output_literal "\[Length : [format "%2.2f" $mom_tool_length] \]"
   MOM_do_template tool_change_2
   MOM_do_template rapid_0_0_100
   MOM_force once motion_g F
}

#--------------------------------------------------------------------

proc  MOM_tool_change {} {

   global mom_tool_name
   global mom_tool_diameter
   global mom_tool_length
   global mom_tool_corner1_radius
   global jg_html_included

   if {$jg_html_included == 1} {
      JG_write_tool
   }

   MOM_output_literal "\[Tool   : $mom_tool_name\]"
   MOM_output_literal "\[Dia    : [format "%2.2f" $mom_tool_diameter] \]"
   MOM_output_literal "\[Radius : [format "%2.2f" $mom_tool_corner1_radius] \]"
   MOM_output_literal "\[Length : [format "%2.2f" $mom_tool_length] \]"
   MOM_force once plane_g T
   MOM_do_template tool_change_2
   MOM_force once motion_g X Y Z spindle_m
   MOM_do_template rapid_0_0_100
   MOM_force once motion_g F
}

#--------------------------------------------------------------------

proc  MOM_initial_move {} {

   global mom_coolant_status mom_coolant_mode
   global coolant_flag

   if {$coolant_flag == 1} {
      if {$mom_coolant_mode == "" && $mom_coolant_status == "SAME"} {
         set mom_coolant_mode TAP
      }
      if {$mom_coolant_status != "OFF"} {
         set mom_coolant_status $mom_coolant_mode
         MOM_force once coolant_m
      }
      set coolant_flag 0
   }

   MOM_force once motion_g X Y Z
   MOM_do_template rapid
   MOM_force once motion_g F
}

#--------------------------------------------------------------------

proc  MOM_first_move {} {

   global mom_coolant_status mom_coolant_mode
   global coolant_flag

   if {$coolant_flag == 1} {
      if {$mom_coolant_mode == "" && $mom_coolant_status == "SAME"} {
         set mom_coolant_mode TAP
      }
      if {$mom_coolant_status != "OFF"} {
         set mom_coolant_status $mom_coolant_mode
         MOM_force once coolant_m
      }
      set coolant_flag 0
   }

   MOM_do_template rapid
   MOM_force once motion_g F
}

#--------------------------------------------------------------------

proc  MOM_rapid_move {} {

   global mom_coolant_status mom_coolant_mode
   global coolant_flag

   if {$coolant_flag == 1} {
      if {$mom_coolant_mode == "" && $mom_coolant_status == "SAME"} {
         set mom_coolant_mode TAP
      }
      if {$mom_coolant_status != "OFF"} {
         set mom_coolant_status $mom_coolant_mode
         MOM_force once coolant_m
      }
      set coolant_flag 0
   }

   MOM_do_template rapid
   MOM_force once motion_g F
}

#--------------------------------------------------------------------

proc  MOM_linear_move {} {

   global mom_cutcom_mode mom_cutcom_status

   if {$mom_cutcom_status == "ON"} {
      set mom_cutcom_status $mom_cutcom_mode
   } elseif {$mom_cutcom_status == "OFF"} {
      MOM_suppress once cutcom_g
   }

   MOM_do_template linear
}

#--------------------------------------------------------------------

proc  MOM_circular_move {} {

   global mom_pos_arc_axis
   global mom_cutcom_mode mom_cutcom_status

   if {$mom_cutcom_status == "ON"} {
      set mom_cutcom_status $mom_cutcom_mode
   } elseif {$mom_cutcom_status == "OFF"} {
      MOM_suppress once cutcom_g
   }

   if {[EQ_is_equal abs($mom_pos_arc_axis(2)) 1.0]} {
      MOM_suppress once K
      MOM_force once X Y I J
   } elseif {[EQ_is_equal abs($mom_pos_arc_axis(1)) 1.0]} {
      MOM_suppress once J
      MOM_force once X Z I K
   } elseif {[EQ_is_equal abs($mom_pos_arc_axis(0)) 1.0]} {
      MOM_suppress once I
      MOM_force once Y Z J K
   }

   MOM_do_template circle
}

#--------------------------------------------------------------------

proc  MOM_before_output {} { }
proc  MOM_load_tool {} { }
proc  MOM_before_motion {} { }
proc  MOM_msys {} { }
proc  MOM_set_csys {} { }
proc  MOM_opskip_on {} { }
proc  MOM_opskip_off {} { }
proc  MOM_delay {} { }
proc  MOM_length_compensation {} { }
proc  MOM_tool_preselect {} { }
proc  MOM_machine_mode {} { }
proc  MOM_delay {} { }

#--------------------------------------------------------------------

proc  MOM_cutcom_on {} { }
proc  MOM_cutcom_off {} { }

#--------------------------------------------------------------------

proc  MOM_spindle_rpm {} { }
proc  MOM_spindle_off {} { MOM_do_template spindle_off }

#--------------------------------------------------------------------

proc  MOM_coolant_on {} {
   global coolant_flag
   set coolant_flag 1
}

proc  MOM_coolant_off {} { 
   global mom_coolant_mode
   set mom_coolant_mode OFF
   MOM_do_template coolant_off
}

#--------------------------------------------------------------------

proc  MOM_opstop {} { MOM_do_template opstop }
proc  MOM_stop {} { MOM_do_template stop }
proc  MOM_auxfun {} { MOM_do_template auxiliary }
proc  MOM_prefun {} { MOM_do_template preparatory }

#--------------------------------------------------------------------

proc MOM_insert {} {
  global mom_Instruction
  MOM_output_literal "$mom_Instruction"
}

proc MOM_pprint {} {
  global mom_pprint
  MOM_output_text "($mom_pprint)"
}

proc MOM_operator_message {} {
  global mom_operator_message
  MOM_output_literal "($mom_operator_message)"
}

proc MOM_text {} {
  global mom_user_defined_text
  MOM_output_literal "($mom_user_defined_text)"
}

#--------------------------------------------------------------------

proc MOM_catch_warning { } {

   global mom_warning_info

   MOM_output_to_listing_device " * WARNING GENERATED *"
   MOM_output_to_listing_device "$mom_warning_info"
   MOM_output_literal "\[ WARNING * $mom_warning_info \]"
}

#--------------------------------------------------------------------

proc  MOM_cycle_off {} { MOM_do_template cycle_off }

#--------------------------------------------------------------------

proc  MOM_drill {} {
  MOM_force once cycle_g Z R
}

proc  MOM_drill_move {} {
  MOM_do_template cycle_drill
}

#--------------------------------------------------------------------

proc  MOM_drill_deep {} {
  MOM_force once cycle_g Z R Q
}

proc  MOM_drill_deep_move {} {
  MOM_do_template cycle_drill_deep
}

#--------------------------------------------------------------------

proc  MOM_tap {} {
   MOM_force once cycle_g Z R F
   MOM_force once S_tap
   MOM_output_literal "G80"
   MOM_do_template spindle_tap
}

proc  MOM_tap_move {} {
  MOM_do_template cycle_tap
}
