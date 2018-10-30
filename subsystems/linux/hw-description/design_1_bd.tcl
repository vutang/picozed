
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2015.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   puts "ERROR: This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If you do not already have a project created,
# you can create a project using the following command:
#    create_project project_1 myproj -part xc7z010clg400-1

# CHECKING IF PROJECT EXISTS
if { [get_projects -quiet] eq "" } {
   puts "ERROR: Please open or create a project!"
   return 1
}



# CHANGE DESIGN NAME HERE
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "ERROR: Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      puts "INFO: Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   puts "INFO: Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "ERROR: Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   puts "INFO: Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   puts "INFO: Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

puts "INFO: Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   puts $errMsg
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     puts "ERROR: Unable to find parent cell <$parentCell>!"
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     puts "ERROR: Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]

  # Create ports
  set PL_PMOD_PIN1 [ create_bd_port -dir I PL_PMOD_PIN1 ]
  set PL_PMOD_PIN2 [ create_bd_port -dir O PL_PMOD_PIN2 ]
  set PL_PMOD_PIN3 [ create_bd_port -dir I PL_PMOD_PIN3 ]
  set PL_PMOD_PIN4 [ create_bd_port -dir O PL_PMOD_PIN4 ]
  set PL_PMOD_PIN7 [ create_bd_port -dir O PL_PMOD_PIN7 ]
  set PL_PMOD_PIN8 [ create_bd_port -dir I PL_PMOD_PIN8 ]
  set WL_CLK [ create_bd_port -dir O WL_CLK ]
  set WL_CMD [ create_bd_port -dir IO WL_CMD ]
  set WL_DAT [ create_bd_port -dir IO -from 3 -to 0 WL_DAT ]
  set WL_HOST_WAKE [ create_bd_port -dir I WL_HOST_WAKE ]
  set WL_REG_ON [ create_bd_port -dir O WL_REG_ON ]
  set dac_clk_out [ create_bd_port -dir O dac_clk_out ]
  set dac_data_out [ create_bd_port -dir O -from 13 -to 0 dac_data_out ]

  # Create instance: PL_pmod_mgr_0, and set properties
  set PL_pmod_mgr_0 [ create_bd_cell -type ip -vlnv vttek.vn:user:PL_pmod_mgr:1.0 PL_pmod_mgr_0 ]

  # Create instance: axi_bram_ctrl_0, and set properties
  set axi_bram_ctrl_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.0 axi_bram_ctrl_0 ]
  set_property -dict [ list \
CONFIG.ECC_TYPE {Hamming} \
CONFIG.PROTOCOL {AXI4} \
 ] $axi_bram_ctrl_0

  # Create instance: axi_bram_ctrl_0_bram, and set properties
  set axi_bram_ctrl_0_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.3 axi_bram_ctrl_0_bram ]
  set_property -dict [ list \
CONFIG.Memory_Type {True_Dual_Port_RAM} \
 ] $axi_bram_ctrl_0_bram

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [ list \
CONFIG.C_GPIO_WIDTH {8} \
CONFIG.C_IS_DUAL {1} \
 ] $axi_gpio_0

  # Create instance: dac_core_0, and set properties
  set dac_core_0 [ create_bd_cell -type ip -vlnv vttek.vn:user:dac_core:1.0 dac_core_0 ]

  # Create instance: gpio_mgr_0, and set properties
  set gpio_mgr_0 [ create_bd_cell -type ip -vlnv vttek.vn:user:gpio_mgr:1.0 gpio_mgr_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_ENET_RESET_ENABLE {1} \
CONFIG.PCW_EN_CLK0_PORT {1} \
CONFIG.PCW_EN_CLK1_PORT {1} \
CONFIG.PCW_EN_CLK2_PORT {0} \
CONFIG.PCW_EN_CLK3_PORT {0} \
CONFIG.PCW_EN_RST0_PORT {1} \
CONFIG.PCW_EN_RST1_PORT {0} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {100.000000} \
CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {25} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} \
CONFIG.PCW_GPIO_EMIO_GPIO_IO {4} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
CONFIG.PCW_I2C_RESET_ENABLE {0} \
CONFIG.PCW_IRQ_F2P_INTR {1} \
CONFIG.PCW_MIO_0_PULLUP {disabled} \
CONFIG.PCW_MIO_0_SLEW {slow} \
CONFIG.PCW_MIO_10_PULLUP {disabled} \
CONFIG.PCW_MIO_10_SLEW {slow} \
CONFIG.PCW_MIO_11_PULLUP {disabled} \
CONFIG.PCW_MIO_11_SLEW {slow} \
CONFIG.PCW_MIO_12_PULLUP {disabled} \
CONFIG.PCW_MIO_12_SLEW {slow} \
CONFIG.PCW_MIO_13_PULLUP {disabled} \
CONFIG.PCW_MIO_13_SLEW {slow} \
CONFIG.PCW_MIO_14_PULLUP {disabled} \
CONFIG.PCW_MIO_14_SLEW {slow} \
CONFIG.PCW_MIO_15_PULLUP {disabled} \
CONFIG.PCW_MIO_15_SLEW {slow} \
CONFIG.PCW_MIO_16_PULLUP {disabled} \
CONFIG.PCW_MIO_16_SLEW {slow} \
CONFIG.PCW_MIO_17_PULLUP {disabled} \
CONFIG.PCW_MIO_17_SLEW {slow} \
CONFIG.PCW_MIO_18_PULLUP {disabled} \
CONFIG.PCW_MIO_18_SLEW {slow} \
CONFIG.PCW_MIO_19_PULLUP {disabled} \
CONFIG.PCW_MIO_19_SLEW {slow} \
CONFIG.PCW_MIO_1_PULLUP {disabled} \
CONFIG.PCW_MIO_1_SLEW {slow} \
CONFIG.PCW_MIO_20_PULLUP {disabled} \
CONFIG.PCW_MIO_20_SLEW {slow} \
CONFIG.PCW_MIO_21_PULLUP {disabled} \
CONFIG.PCW_MIO_21_SLEW {slow} \
CONFIG.PCW_MIO_22_PULLUP {disabled} \
CONFIG.PCW_MIO_22_SLEW {slow} \
CONFIG.PCW_MIO_23_PULLUP {disabled} \
CONFIG.PCW_MIO_23_SLEW {slow} \
CONFIG.PCW_MIO_24_PULLUP {disabled} \
CONFIG.PCW_MIO_24_SLEW {slow} \
CONFIG.PCW_MIO_25_PULLUP {disabled} \
CONFIG.PCW_MIO_25_SLEW {slow} \
CONFIG.PCW_MIO_26_PULLUP {disabled} \
CONFIG.PCW_MIO_26_SLEW {slow} \
CONFIG.PCW_MIO_27_PULLUP {disabled} \
CONFIG.PCW_MIO_27_SLEW {slow} \
CONFIG.PCW_MIO_28_PULLUP {disabled} \
CONFIG.PCW_MIO_28_SLEW {slow} \
CONFIG.PCW_MIO_29_PULLUP {disabled} \
CONFIG.PCW_MIO_29_SLEW {slow} \
CONFIG.PCW_MIO_2_PULLUP {disabled} \
CONFIG.PCW_MIO_2_SLEW {slow} \
CONFIG.PCW_MIO_30_PULLUP {disabled} \
CONFIG.PCW_MIO_30_SLEW {slow} \
CONFIG.PCW_MIO_31_PULLUP {disabled} \
CONFIG.PCW_MIO_31_SLEW {slow} \
CONFIG.PCW_MIO_32_PULLUP {disabled} \
CONFIG.PCW_MIO_32_SLEW {slow} \
CONFIG.PCW_MIO_33_PULLUP {disabled} \
CONFIG.PCW_MIO_33_SLEW {slow} \
CONFIG.PCW_MIO_34_PULLUP {disabled} \
CONFIG.PCW_MIO_34_SLEW {slow} \
CONFIG.PCW_MIO_35_PULLUP {disabled} \
CONFIG.PCW_MIO_35_SLEW {slow} \
CONFIG.PCW_MIO_36_PULLUP {disabled} \
CONFIG.PCW_MIO_36_SLEW {slow} \
CONFIG.PCW_MIO_37_PULLUP {disabled} \
CONFIG.PCW_MIO_37_SLEW {slow} \
CONFIG.PCW_MIO_38_PULLUP {disabled} \
CONFIG.PCW_MIO_38_SLEW {slow} \
CONFIG.PCW_MIO_39_PULLUP {disabled} \
CONFIG.PCW_MIO_39_SLEW {slow} \
CONFIG.PCW_MIO_3_PULLUP {disabled} \
CONFIG.PCW_MIO_3_SLEW {slow} \
CONFIG.PCW_MIO_40_PULLUP {disabled} \
CONFIG.PCW_MIO_40_SLEW {slow} \
CONFIG.PCW_MIO_41_PULLUP {disabled} \
CONFIG.PCW_MIO_41_SLEW {slow} \
CONFIG.PCW_MIO_42_PULLUP {disabled} \
CONFIG.PCW_MIO_42_SLEW {slow} \
CONFIG.PCW_MIO_43_PULLUP {disabled} \
CONFIG.PCW_MIO_43_SLEW {slow} \
CONFIG.PCW_MIO_44_PULLUP {disabled} \
CONFIG.PCW_MIO_44_SLEW {slow} \
CONFIG.PCW_MIO_45_PULLUP {disabled} \
CONFIG.PCW_MIO_45_SLEW {slow} \
CONFIG.PCW_MIO_46_PULLUP {disabled} \
CONFIG.PCW_MIO_46_SLEW {slow} \
CONFIG.PCW_MIO_47_PULLUP {disabled} \
CONFIG.PCW_MIO_47_SLEW {slow} \
CONFIG.PCW_MIO_48_PULLUP {disabled} \
CONFIG.PCW_MIO_48_SLEW {slow} \
CONFIG.PCW_MIO_49_PULLUP {disabled} \
CONFIG.PCW_MIO_49_SLEW {slow} \
CONFIG.PCW_MIO_4_PULLUP {disabled} \
CONFIG.PCW_MIO_4_SLEW {slow} \
CONFIG.PCW_MIO_50_PULLUP {disabled} \
CONFIG.PCW_MIO_50_SLEW {slow} \
CONFIG.PCW_MIO_51_PULLUP {disabled} \
CONFIG.PCW_MIO_51_SLEW {slow} \
CONFIG.PCW_MIO_52_PULLUP {disabled} \
CONFIG.PCW_MIO_52_SLEW {slow} \
CONFIG.PCW_MIO_53_PULLUP {disabled} \
CONFIG.PCW_MIO_53_SLEW {slow} \
CONFIG.PCW_MIO_5_PULLUP {disabled} \
CONFIG.PCW_MIO_5_SLEW {slow} \
CONFIG.PCW_MIO_6_PULLUP {disabled} \
CONFIG.PCW_MIO_6_SLEW {slow} \
CONFIG.PCW_MIO_7_PULLUP {disabled} \
CONFIG.PCW_MIO_7_SLEW {slow} \
CONFIG.PCW_MIO_8_PULLUP {disabled} \
CONFIG.PCW_MIO_8_SLEW {slow} \
CONFIG.PCW_MIO_9_PULLUP {disabled} \
CONFIG.PCW_MIO_9_SLEW {slow} \
CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} \
CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {1} \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_IO {MIO 46} \
CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
CONFIG.PCW_SD0_GRP_WP_IO {MIO 50} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_UART0_GRP_FULL_ENABLE {1} \
CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {.294} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {.298} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {.338} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {.334} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {-0.073} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {-0.072} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.024} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.023} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {1} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_USB0_RESET_ENABLE {1} \
CONFIG.PCW_USB0_RESET_IO {MIO 7} \
CONFIG.PCW_USB_RESET_ENABLE {1} \
CONFIG.PCW_USE_FABRIC_INTERRUPT {0} \
CONFIG.PCW_USE_M_AXI_GP0 {1} \
CONFIG.PCW_USE_S_AXI_HP0 {0} \
 ] $processing_system7_0

  # Create instance: processing_system7_0_axi_periph, and set properties
  set processing_system7_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 processing_system7_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {2} \
 ] $processing_system7_0_axi_periph

  # Create instance: rst_processing_system7_0_50M, and set properties
  set rst_processing_system7_0_50M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processing_system7_0_50M ]

  # Create instance: wireless_mgr_0, and set properties
  set wireless_mgr_0 [ create_bd_cell -type ip -vlnv vttek.vn:user:wireless_mgr:1.0 wireless_mgr_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins axi_bram_ctrl_0_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins processing_system7_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M00_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net processing_system7_0_axi_periph_M01_AXI [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins processing_system7_0_axi_periph/M01_AXI]

  # Create port connections
  connect_bd_net -net Net1 [get_bd_ports WL_DAT] [get_bd_pins wireless_mgr_0/WL_DAT]
  connect_bd_net -net Net2 [get_bd_ports WL_CMD] [get_bd_pins wireless_mgr_0/WL_CMD]
  connect_bd_net -net PL_PMOD_PIN1_1 [get_bd_ports PL_PMOD_PIN1] [get_bd_pins PL_pmod_mgr_0/PL_PMOD_PIN1]
  connect_bd_net -net PL_PMOD_PIN3_1 [get_bd_ports PL_PMOD_PIN3] [get_bd_pins PL_pmod_mgr_0/PL_PMOD_PIN3]
  connect_bd_net -net PL_PMOD_PIN8_1 [get_bd_ports PL_PMOD_PIN8] [get_bd_pins PL_pmod_mgr_0/PL_PMOD_PIN8]
  connect_bd_net -net PL_pmod_mgr_0_BT_HOST_WAKE [get_bd_pins PL_pmod_mgr_0/BT_HOST_WAKE] [get_bd_pins gpio_mgr_0/pin_io_01]
  connect_bd_net -net PL_pmod_mgr_0_PL_PMOD_PIN2 [get_bd_ports PL_PMOD_PIN2] [get_bd_pins PL_pmod_mgr_0/PL_PMOD_PIN2]
  connect_bd_net -net PL_pmod_mgr_0_PL_PMOD_PIN4 [get_bd_ports PL_PMOD_PIN4] [get_bd_pins PL_pmod_mgr_0/PL_PMOD_PIN4]
  connect_bd_net -net PL_pmod_mgr_0_PL_PMOD_PIN7 [get_bd_ports PL_PMOD_PIN7] [get_bd_pins PL_pmod_mgr_0/PL_PMOD_PIN7]
  connect_bd_net -net PL_pmod_mgr_0_ZYNQ_UART_CTS [get_bd_pins PL_pmod_mgr_0/ZYNQ_UART_CTS] [get_bd_pins processing_system7_0/UART0_CTSN]
  connect_bd_net -net PL_pmod_mgr_0_ZYNQ_UART_RX [get_bd_pins PL_pmod_mgr_0/ZYNQ_UART_RX] [get_bd_pins processing_system7_0/UART0_RX]
  connect_bd_net -net WL_HOST_WAKE_1 [get_bd_ports WL_HOST_WAKE] [get_bd_pins gpio_mgr_0/pin_io_03]
  connect_bd_net -net axi_bram_ctrl_0_bram_doutb [get_bd_pins axi_bram_ctrl_0_bram/doutb] [get_bd_pins dac_core_0/data_in]
  connect_bd_net -net axi_bram_ctrl_0_bram_en_b [get_bd_pins axi_bram_ctrl_0/bram_en_b] [get_bd_pins axi_bram_ctrl_0_bram/enb]
  connect_bd_net -net axi_bram_ctrl_0_bram_rst_b [get_bd_pins axi_bram_ctrl_0/bram_rst_b] [get_bd_pins axi_bram_ctrl_0_bram/rstb]
  connect_bd_net -net axi_gpio_0_gpio2_io_o [get_bd_pins axi_gpio_0/gpio2_io_i] [get_bd_pins axi_gpio_0/gpio2_io_o] [get_bd_pins dac_core_0/n_sample]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins axi_gpio_0/gpio_io_i] [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_pins dac_core_0/start_i]
  connect_bd_net -net dac_core_0_bram_rd_addr [get_bd_pins axi_bram_ctrl_0_bram/addrb] [get_bd_pins dac_core_0/bram_rd_addr]
  connect_bd_net -net dac_core_0_clk_out [get_bd_ports dac_clk_out] [get_bd_pins dac_core_0/clk_out]
  connect_bd_net -net dac_core_0_data_out [get_bd_ports dac_data_out] [get_bd_pins dac_core_0/data_out]
  connect_bd_net -net gpio_mgr_0_pin_io_00 [get_bd_pins PL_pmod_mgr_0/BT_REG_ON] [get_bd_pins gpio_mgr_0/pin_io_00]
  connect_bd_net -net gpio_mgr_0_pin_io_02 [get_bd_ports WL_REG_ON] [get_bd_pins gpio_mgr_0/pin_io_02]
  connect_bd_net -net gpio_mgr_0_to_cpu_out [get_bd_pins gpio_mgr_0/to_cpu_out] [get_bd_pins processing_system7_0/GPIO_I]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins axi_bram_ctrl_0_bram/clkb] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins dac_core_0/clk_in] [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins processing_system7_0_axi_periph/ACLK] [get_bd_pins processing_system7_0_axi_periph/M00_ACLK] [get_bd_pins processing_system7_0_axi_periph/M01_ACLK] [get_bd_pins processing_system7_0_axi_periph/S00_ACLK] [get_bd_pins rst_processing_system7_0_50M/slowest_sync_clk]
  connect_bd_net -net processing_system7_0_FCLK_CLK1 [get_bd_pins PL_pmod_mgr_0/clk_in] [get_bd_pins processing_system7_0/FCLK_CLK1]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins PL_pmod_mgr_0/resetn_in] [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins rst_processing_system7_0_50M/ext_reset_in]
  connect_bd_net -net processing_system7_0_GPIO_O [get_bd_pins gpio_mgr_0/from_cpu_in] [get_bd_pins processing_system7_0/GPIO_O]
  connect_bd_net -net processing_system7_0_GPIO_T [get_bd_pins gpio_mgr_0/dir_in] [get_bd_pins processing_system7_0/GPIO_T]
  connect_bd_net -net processing_system7_0_SDIO1_CLK [get_bd_pins processing_system7_0/SDIO1_CLK] [get_bd_pins wireless_mgr_0/SDIO_CLK]
  connect_bd_net -net processing_system7_0_SDIO1_CMD_O [get_bd_pins processing_system7_0/SDIO1_CMD_O] [get_bd_pins wireless_mgr_0/SDIO_CMD_I]
  connect_bd_net -net processing_system7_0_SDIO1_CMD_T [get_bd_pins processing_system7_0/SDIO1_CMD_T] [get_bd_pins wireless_mgr_0/SDIO_CMD_T]
  connect_bd_net -net processing_system7_0_SDIO1_DATA_O [get_bd_pins processing_system7_0/SDIO1_DATA_O] [get_bd_pins wireless_mgr_0/SDIO_DATA_I]
  connect_bd_net -net processing_system7_0_SDIO1_DATA_T [get_bd_pins processing_system7_0/SDIO1_DATA_T] [get_bd_pins wireless_mgr_0/SDIO_DATA_T]
  connect_bd_net -net processing_system7_0_UART0_RTSN [get_bd_pins PL_pmod_mgr_0/ZYNQ_UART_RTS] [get_bd_pins processing_system7_0/UART0_RTSN]
  connect_bd_net -net processing_system7_0_UART0_TX [get_bd_pins PL_pmod_mgr_0/ZYNQ_UART_TX] [get_bd_pins processing_system7_0/UART0_TX]
  connect_bd_net -net rst_processing_system7_0_50M_interconnect_aresetn [get_bd_pins processing_system7_0_axi_periph/ARESETN] [get_bd_pins rst_processing_system7_0_50M/interconnect_aresetn]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_aresetn [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins processing_system7_0_axi_periph/M00_ARESETN] [get_bd_pins processing_system7_0_axi_periph/M01_ARESETN] [get_bd_pins processing_system7_0_axi_periph/S00_ARESETN] [get_bd_pins rst_processing_system7_0_50M/peripheral_aresetn]
  connect_bd_net -net rst_processing_system7_0_50M_peripheral_reset [get_bd_pins dac_core_0/reset] [get_bd_pins rst_processing_system7_0_50M/peripheral_reset]
  connect_bd_net -net wireless_mgr_0_SDIO_CDN [get_bd_pins processing_system7_0/SDIO1_CDN] [get_bd_pins wireless_mgr_0/SDIO_CDN]
  connect_bd_net -net wireless_mgr_0_SDIO_CLK_FB [get_bd_pins processing_system7_0/SDIO1_CLK_FB] [get_bd_pins wireless_mgr_0/SDIO_CLK_FB]
  connect_bd_net -net wireless_mgr_0_SDIO_CMD_O [get_bd_pins processing_system7_0/SDIO1_CMD_I] [get_bd_pins wireless_mgr_0/SDIO_CMD_O]
  connect_bd_net -net wireless_mgr_0_SDIO_DATA_O [get_bd_pins processing_system7_0/SDIO1_DATA_I] [get_bd_pins wireless_mgr_0/SDIO_DATA_O]
  connect_bd_net -net wireless_mgr_0_SDIO_WP [get_bd_pins processing_system7_0/SDIO1_WP] [get_bd_pins wireless_mgr_0/SDIO_WP]
  connect_bd_net -net wireless_mgr_0_WL_CLK [get_bd_ports WL_CLK] [get_bd_pins wireless_mgr_0/WL_CLK]

  # Create address segments
  create_bd_addr_seg -range 0x4000 -offset 0x40000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] SEG_axi_bram_ctrl_0_Mem0
  create_bd_addr_seg -range 0x1000 -offset 0x50000000 [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] SEG_axi_gpio_0_Reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.5.5  2015-06-26 bk=1.3371 VDI=38 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port DDR -pg 1 -y 820 -defaultsOSRD
preplace port PL_PMOD_PIN1 -pg 1 -y 610 -defaultsOSRD
preplace port WL_CMD -pg 1 -y 1140 -defaultsOSRD
preplace port PL_PMOD_PIN2 -pg 1 -y 670 -defaultsOSRD
preplace port PL_PMOD_PIN3 -pg 1 -y 630 -defaultsOSRD
preplace port WL_CLK -pg 1 -y 1120 -defaultsOSRD
preplace port PL_PMOD_PIN4 -pg 1 -y 690 -defaultsOSRD
preplace port PL_PMOD_PIN7 -pg 1 -y 710 -defaultsOSRD
preplace port PL_PMOD_PIN8 -pg 1 -y 650 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 840 -defaultsOSRD
preplace port WL_HOST_WAKE -pg 1 -y 680 -defaultsOSRD
preplace port WL_REG_ON -pg 1 -y 790 -defaultsOSRD
preplace port dac_clk_out -pg 1 -y 280 -defaultsOSRD
preplace portBus WL_DAT -pg 1 -y 1160 -defaultsOSRD
preplace portBus dac_data_out -pg 1 -y 300 -defaultsOSRD
preplace inst axi_bram_ctrl_0_bram -pg 1 -lvl 4 -y 440 -defaultsOSRD
preplace inst PL_pmod_mgr_0 -pg 1 -lvl 4 -y 670 -defaultsOSRD
preplace inst axi_gpio_0 -pg 1 -lvl 3 -y 110 -defaultsOSRD
preplace inst gpio_mgr_0 -pg 1 -lvl 3 -y 720 -defaultsOSRD
preplace inst rst_processing_system7_0_50M -pg 1 -lvl 1 -y 400 -defaultsOSRD
preplace inst wireless_mgr_0 -pg 1 -lvl 4 -y 1090 -defaultsOSRD
preplace inst dac_core_0 -pg 1 -lvl 3 -y 300 -defaultsOSRD
preplace inst axi_bram_ctrl_0 -pg 1 -lvl 3 -y 470 -defaultsOSRD
preplace inst processing_system7_0_axi_periph -pg 1 -lvl 2 -y 460 -defaultsOSRD
preplace inst processing_system7_0 -pg 1 -lvl 1 -y 1000 -defaultsOSRD
preplace netloc processing_system7_0_DDR 1 1 4 NJ 820 NJ 820 NJ 820 NJ
preplace netloc wireless_mgr_0_SDIO_CLK_FB 1 1 4 NJ 1000 NJ 1000 NJ 1230 1550
preplace netloc PL_pmod_mgr_0_ZYNQ_UART_CTS 1 1 4 N 920 NJ 920 NJ 920 1540
preplace netloc PL_pmod_mgr_0_ZYNQ_UART_RX 1 1 4 NJ 940 NJ 940 NJ 940 1510
preplace netloc dac_core_0_data_out 1 3 2 NJ 300 NJ
preplace netloc wireless_mgr_0_WL_CLK 1 4 1 NJ
preplace netloc PL_PMOD_PIN3_1 1 0 4 NJ 630 NJ 630 NJ 630 NJ
preplace netloc gpio_mgr_0_pin_io_00 1 3 1 1150
preplace netloc rst_processing_system7_0_50M_peripheral_reset 1 1 2 NJ 280 N
preplace netloc processing_system7_0_axi_periph_M00_AXI 1 2 1 N
preplace netloc processing_system7_0_SDIO1_DATA_T 1 1 3 NJ 1120 NJ 1120 1140
preplace netloc wireless_mgr_0_SDIO_CMD_O 1 1 4 NJ 1040 NJ 1040 NJ 1240 1540
preplace netloc PL_pmod_mgr_0_PL_PMOD_PIN7 1 4 1 NJ
preplace netloc processing_system7_0_GPIO_O 1 1 2 450 690 NJ
preplace netloc rst_processing_system7_0_50M_interconnect_aresetn 1 1 1 N
preplace netloc axi_bram_ctrl_0_BRAM_PORTA 1 3 1 1160
preplace netloc processing_system7_0_M_AXI_GP0 1 1 1 440
preplace netloc wireless_mgr_0_SDIO_DATA_O 1 1 4 NJ 1080 NJ 1080 NJ 1210 1520
preplace netloc gpio_mgr_0_pin_io_02 1 3 2 NJ 790 NJ
preplace netloc processing_system7_0_UART0_RTSN 1 1 3 NJ 880 NJ 880 1170
preplace netloc PL_pmod_mgr_0_BT_HOST_WAKE 1 2 3 850 560 NJ 550 1550
preplace netloc processing_system7_0_FCLK_RESET0_N 1 0 4 30 640 430 640 NJ 620 NJ
preplace netloc processing_system7_0_SDIO1_CLK 1 1 3 NJ 980 NJ 980 1230
preplace netloc rst_processing_system7_0_50M_peripheral_aresetn 1 1 2 430 600 830
preplace netloc processing_system7_0_SDIO1_CMD_O 1 1 3 NJ 1020 NJ 1020 1220
preplace netloc processing_system7_0_UART0_TX 1 1 3 NJ 650 NJ 640 N
preplace netloc wireless_mgr_0_SDIO_CDN 1 1 4 NJ 1140 NJ 1140 NJ 1220 1510
preplace netloc processing_system7_0_GPIO_T 1 1 2 480 710 NJ
preplace netloc axi_gpio_0_gpio_io_o 1 2 2 840 10 1230
preplace netloc processing_system7_0_FIXED_IO 1 1 4 NJ 840 NJ 840 NJ 840 NJ
preplace netloc PL_PMOD_PIN8_1 1 0 4 NJ 660 NJ 660 NJ 800 NJ
preplace netloc axi_bram_ctrl_0_bram_rst_b 1 3 1 N
preplace netloc processing_system7_0_SDIO1_DATA_O 1 1 3 NJ 1100 NJ 1100 1190
preplace netloc Net1 1 4 1 NJ
preplace netloc PL_pmod_mgr_0_PL_PMOD_PIN2 1 4 1 NJ
preplace netloc axi_gpio_0_gpio2_io_o 1 2 2 850 210 1230
preplace netloc processing_system7_0_FCLK_CLK0 1 0 4 20 490 470 620 820 550 NJ
preplace netloc wireless_mgr_0_SDIO_WP 1 1 4 NJ 1160 NJ 1160 NJ 1250 1530
preplace netloc processing_system7_0_SDIO1_CMD_T 1 1 3 NJ 1060 NJ 1060 1210
preplace netloc Net2 1 4 1 NJ
preplace netloc PL_PMOD_PIN1_1 1 0 4 NJ 610 NJ 610 NJ 610 NJ
preplace netloc processing_system7_0_FCLK_CLK1 1 1 3 NJ 1240 NJ 1240 1160
preplace netloc gpio_mgr_0_to_cpu_out 1 1 3 N 760 NJ 810 1140
preplace netloc processing_system7_0_axi_periph_M01_AXI 1 2 1 810
preplace netloc PL_pmod_mgr_0_PL_PMOD_PIN4 1 4 1 NJ
preplace netloc WL_HOST_WAKE_1 1 0 3 NJ 680 NJ 680 NJ
preplace netloc axi_bram_ctrl_0_bram_en_b 1 3 1 N
preplace netloc axi_bram_ctrl_0_bram_doutb 1 2 2 850 390 NJ
preplace netloc dac_core_0_clk_out 1 3 2 NJ 280 NJ
preplace netloc dac_core_0_bram_rd_addr 1 3 1 1230
levelinfo -pg 1 -10 230 660 1000 1370 1570 -top 0 -bot 1310
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


