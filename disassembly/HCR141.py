from commands import *
from acorn import *

config.set_label_references(False);
config.set_hex_dump(False);

bbc()


# Load the program to be disassembled into the debugger's memory.
# The md5sum is optional but helps avoid confusion if there are multiple versions
# of the same program.
load(0x8000, "HCR141.orig", "6502", None)

entry(0x8000)
entry(0x8003)
entry(0x83c2, "brk_handler")


label(0xfcc0, "PIA1_PortA_Addr_Lo")
label(0xfcc1, "PIA1_ControlA")
label(0xfcc2, "PIA1_PortB_Addr_Hi")
label(0xfcc3, "PIA1_ControlB")
label(0xfcc4, "PIA2_PortA_Data")
label(0xfcc5, "PIA2_ControlA")
label(0xfcc6, "PIA2_PortB_Misc")
label(0xfcc7, "PIA2_ControlB")


label(0x8845, "Cursor_Off")
label(0x820d, "Print_Device_Type")
label(0x82fb, "Print_VPP_Voltage")
label(0x8332, "Print_Slow_Fast")


label(0x946b, "Set_ROM_Page")
label(0x9532, "Set_ROM_Page_If_Needed")

label(0x94c2, "Enter_ROM_Page_If_Needed")
label(0x9978, "Enter_Address_Space_If_Needed")

label(0x9ab3, "Handle_24Pin_Device");

# Blank Check

label(0x971b, "Blank_Check_24pin")
label(0x95b0, "Blank_Check_28pin")
label(0x967a, "Blank_Check_28pin_More")

# Programming
label(0x9fde, "Program_ROM_27513_27011")
label(0xa31b, "Program_ROM_27512")
label(0x9be8, "Program_ROM_27256_27128_2764")
label(0xa7a4, "Program_ROM_2732_2716_2564_2532")

# Jump Block and Main Entry Points

label(0xbf00, "jmp_Rom_Image_Creator")
label(0xa989, "Rom_Image_Creator")

label(0xbf03, "jmp_Set_Device_Variables")
label(0x91cb, "Set_Device_Variables")

label(0xbf06, "jmp_Reset_Hardware")
label(0x927a, "Reset_Hardware")

label(0xbf09, "jmp_Copy_ROM")
label(0x92b6, "Copy_ROM")

label(0xbf0c, "jmp_Blank_Check_ROM")
label(0x9599, "Blank_Check_ROM")

label(0xbf0f, "jmp_Program_ROM")
label(0x9bb7, "Program_ROM")

label(0xbf12, "jmp_Verify_ROM")
label(0x9750, "Verify_ROM")

label(0xbf15, "jmp_Verify_ROM_Inner")
label(0x9756, "Verify_ROM_Inner")

label(0xbf18, "jmp_Verify_ROM_Inner_28pin")
label(0x9767, "Verify_ROM_Inner_28pin")

label(0xbf1b, "jmp_Verify_ROM_Inner_24pin")
label(0x9a69, "Verify_ROM_Inner_24pin")

label(0xbf1e, "jmp_Set_MiscA")
label(0x992c, "Set_MiscA")

label(0xbf21, "jmp_Set_MiscB")
label(0x991b, "Set_MiscB")

label(0xbf24, "jmp_Press_Any_Key_To_Return")
label(0x9948, "Press_Any_Key_To_Return")

label(0x81eb, "Summary_Screen")
label(0xbf27, "jmp_Summary_Screen")

hook_subroutine(0xbf2a, "jmp_print_string", stringz_hook)
hook_subroutine(0x8359, "print_string", stringz_hook)

label(0xbf2d, "jmp_PrintHexA");
label(0x8deb, "PrintHexA");
label(0x9fd3, "PrintHexAddress");

# These contain identical code
label(0x9fb5, "Calculate_Pulse_WidthA");
label(0xa2f2, "Calculate_Pulse_WidthB");
label(0xa5f8, "Calculate_Pulse_WidthC");
label(0xa766, "Calculate_Pulse_WidthD");

label(0xbf30, "jmp_Failed")
label(0x9f26, "Failed")

label(0xbf33, "jmp_Get_Y_Or_N")
label(0x993d, "Get_Y_Or_N")

label(0xbf36, "jmp_Get_Rom_Page")
label(0x96e5, "Get_Rom_Page")



byte(0x91da, 0xa0, 16)
byte(0xb02c)
byte(0xb02d)
entry(0xb02e)

label(0x0400, "l0400_device_type")
label(0x0401, "l0401_misca_shadow")
label(0x0402, "l0402_miscb_shadow")

# Use all the information provided to actually disassemble the program.
go()
