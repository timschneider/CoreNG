#
#  Copyright (c) 2012 Arduino.  All right reserved.
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Lesser General Public
#  License as published by the Free Software Foundation; either
#  version 2.1 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#  See the GNU Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public
#  License along with this library; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

# Makefile for compiling libArduino
.SUFFIXES: .o .a .c .s

CHIP=__SAM3X8E__
VARIANT=duet
LIBNAME=CoreNG
TOOLCHAIN=gcc

#-------------------------------------------------------------------------------
# Path
#-------------------------------------------------------------------------------

# Output directories
OUTPUT_BIN = ../../../SAM3X8E
OUTPUT_LIB=lib$(LIBNAME).a

# Libraries
PROJECT_BASE_PATH = ..
LIBRARY_PATH = ../../../libraries

ASF_PATH = ../../../asf
ARDUINO_PATH = ../../../cores/arduino
VARIANT_BASE_PATH = ../../../variants
VARIANT_PATH = ../../../variants/$(VARIANT)

#-------------------------------------------------------------------------------
# Files
#-------------------------------------------------------------------------------

#vpath %.h $(PROJECT_BASE_PATH) $(SYSTEM_PATH) $(VARIANT_PATH)

VPATH+=$(PROJECT_BASE_PATH)

INCLUDES =
INCLUDES += -I$(ARDUINO_PATH)
INCLUDES += -I$(ASF_PATH)
INCLUDES += -I$(ASF_PATH)/sam/utils
INCLUDES += -I$(ASF_PATH)/sam/utils/header_files
INCLUDES += -I$(ASF_PATH)/sam/utils/preprocessor
INCLUDES += -I$(ASF_PATH)/sam/drivers
INCLUDES += -I$(ASF_PATH)/sam/drivers/dmac
INCLUDES += -I$(ASF_PATH)/sam/drivers/efc
INCLUDES += -I$(ASF_PATH)/sam/drivers/hsmci
INCLUDES += -I$(ASF_PATH)/sam/drivers/pio
INCLUDES += -I$(ASF_PATH)/sam/drivers/pmc
INCLUDES += -I$(ASF_PATH)/sam/drivers/spi
INCLUDES += -I$(ASF_PATH)/sam/drivers/usart
INCLUDES += -I$(ASF_PATH)/common/utils
INCLUDES += -I$(ASF_PATH)/common/services/clock
INCLUDES += -I$(ASF_PATH)/common/services/ioport
INCLUDES += -I$(ASF_PATH)/common/services/sleepmgr
INCLUDES += -I$(ASF_PATH)/common/services/usb
INCLUDES += -I$(ASF_PATH)/common/services/usb/udc
INCLUDES += -I$(ASF_PATH)/common/services/usb/class/cdc
INCLUDES += -I$(ASF_PATH)/common/services/usb/class/cdc/device
INCLUDES += -I$(ASF_PATH)/thirdparty/CMSIS/Include
INCLUDES += -I$(ASF_PATH)/sam/utils/cmsis/sam3x/include
INCLUDES += -I$(VARIANT_PATH)

# Standard Duet libraries (more of them may be incorporated into the Arduino core)
INCLUDES += -I$(LIBRARY_PATH)/Storage

#-------------------------------------------------------------------------------
ifdef DEBUG
include debug.mk
else
include release.mk
endif

#-------------------------------------------------------------------------------
# Tools
#-------------------------------------------------------------------------------

include $(TOOLCHAIN).mk
CFLAGS += -c -mcpu=cortex-m3 -mthumb -ffunction-sections -fdata-sections -nostdlib -Wundef -Wdouble-promotion -fsingle-precision-constant "-Wa,-ahl=$*.s"
CFLAGS += -std=gnu99
CFLAGS += -DUDD_ENABLE -DUDD_NO_SLEEP_MGR

CPPFLAGS += -c -mcpu=cortex-m3 -mthumb -ffunction-sections -fdata-sections -fno-threadsafe-statics -fno-rtti -fno-exceptions -nostdlib -Wundef -Wdouble-promotion -fsingle-precision-constant "-Wa,-ahl=$*.s"
CPPFLAGS += -std=gnu++17
CPPFLAGS += -DUDD_ENABLE -DUDD_NO_SLEEP_MGR

#-------------------------------------------------------------------------------
ifdef DEBUG
OUTPUT_OBJ=debug
OUTPUT_LIB_POSTFIX=dbg
else
OUTPUT_OBJ=release
OUTPUT_LIB_POSTFIX=rel
endif

OUTPUT_PATH=$(OUTPUT_OBJ)_$(VARIANT)

#-------------------------------------------------------------------------------
# C source files and objects
#-------------------------------------------------------------------------------
# Make does not offer a recursive wildcard function
# from https://stackoverflow.com/a/12959694:
rwildcard=$(wildcard $1$2)$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))
C_SRC := $(wildcard $(PROJECT_BASE_PATH)/*.c) $(call rwildcard,$(ASF_PATH),*.c) $(call rwildcard,$(ARDUINO_PATH),*.c) $(call rwildcard,$(LIBRARY_PATH),*.c)
#C_SRC=$(wildcard $(PROJECT_BASE_PATH)/*.c)

C_OBJ_FILTER= 
C_OBJ_FILTER += $(ASF_PATH)/sam/drivers/gmac/%
C_OBJ_FILTER += $(ASF_PATH)/sam/drivers/mpu/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/usb/uhc/%
C_OBJ_FILTER += $(ASF_PATH)/sam/drivers/usbhs/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/clock/same70/%
C_OBJ_FILTER += $(ASF_PATH)/sam/drivers/mcan/%
C_OBJ_FILTER += $(ASF_PATH)/sam/drivers/twihs/%
C_OBJ_FILTER += $(ASF_PATH)/sam/drivers/cmcc/%
C_OBJ_FILTER += $(ASF_PATH)/sam/drivers/rswdt/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/storage/ecc_hamming/%
C_OBJ_FILTER += $(ASF_PATH)/sam/utils/syscalls/gcc/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/spi/%
C_OBJ_FILTER += $(ASF_PATH)/common/components/memory/sd_mmc/sd_mmc_spi.h
C_OBJ_FILTER += $(ASF_PATH)/common/components/memory/sd_mmc/sd_mmc_spi.c
C_OBJ_FILTER += $(ASF_PATH)/common/components/memory/sd_mmc/module_config_spi/%
C_OBJ_FILTER += $(ASF_PATH)/common/utils/osprintf/%
C_OBJ_FILTER += $(ASF_PATH)/common/utils/membag/%
C_OBJ_FILTER += $(ASF_PATH)/common/utils/stdio/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/clock/sam4s/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/clock/sam3s/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/clock/sam4e/%
C_OBJ_FILTER += $(ASF_PATH)/sam/components/ethernet_phy/%
C_OBJ_FILTER += $(ASF_PATH)/sam/drivers/acc/%
C_OBJ_FILTER += $(ASF_PATH)/sam/drivers/aes/%
C_OBJ_FILTER += $(ASF_PATH)/sam/drivers/crccu/%
C_OBJ_FILTER += $(ASF_PATH)/sam/drivers/afec/%
C_OBJ_FILTER += $(ASF_PATH)/sam/drivers/udp/%
C_OBJ_FILTER += $(ASF_PATH)/sam/drivers/xdmac/%
C_OBJ_FILTER += $(ASF_PATH)/sam/drivers/abdacb/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/delay/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/serial/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/fifo/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/crc32/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/isp/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/gfx_mono/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/gfx/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/sensors/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/hugemem/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/freertos/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/calendar/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/adp/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/usb/class/phdc/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/usb/class/msc/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/usb/class/hid/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/usb/class/dfu_flip/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/usb/class/composite/%
C_OBJ_FILTER += $(ASF_PATH)/common/services/usb/class/aoa/%
C_OBJ_FILTER += $(ASF_PATH)/common/drivers/%
C_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/same70/%
C_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/samg/%
C_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam4s/%
C_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam4n/%
C_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam4l/%
C_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam4e/%
C_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam4cp/%
C_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam4cm32/%
C_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sams70/%
C_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/samv70/%
C_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/samv71/%
C_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam4cm/%
C_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam4c/%
C_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam3u/%
C_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam3s8/%
C_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam3s/%
C_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam3n/%
C_OBJ_FILTER += $(ASF_PATH)/thirdparty/CMSIS/DSP_Lib/%
C_OBJ_FILTER += $(ASF_PATH)/common/applications/%
C_OBJ_FILTER += $(ASF_PATH)/sam/applications/%
C_OBJ_FILTER += $(LIBRARY_PATH)/SPI/%
C_OBJ_FILTER += $(LIBRARY_PATH)/HID/%
C_OBJ_FILTER += $(VARIANT_BASE_PATH)/same70/%
C_OBJ_FILTER += $(VARIANT_BASE_PATH)/sam4s/%
C_OBJ_FILTER += $(VARIANT_BASE_PATH)/alligator/%
C_OBJ_FILTER += $(VARIANT_BASE_PATH)/RADDS/%
C_OBJ_FILTER += $(VARIANT_BASE_PATH)/duetNG/%


C_SRC_TEMP := $(filter-out $(C_OBJ_FILTER), $(C_SRC))
C_OBJ_TEMP = $(patsubst %.c, %.o, $(notdir $(C_SRC_TEMP)))

C_SRC_PATHS := $(sort $(dir $(C_SRC_TEMP)))

C_OBJ=$(C_OBJ_TEMP)

#-------------------------------------------------------------------------------
# CPP source files and objects
#-------------------------------------------------------------------------------
#CPP_SRC=$(wildcard $(PROJECT_BASE_PATH)/*.cpp)
CPP_SRC := $(wildcard $(PROJECT_BASE_PATH)/*.cpp) $(call rwildcard,$(ASF_PATH),*.cpp) $(call rwildcard,$(ARDUINO_PATH),*.cpp) $(call rwildcard,$(LIBRARY_PATH),*.cpp)

CPP_OBJ_FILTER=
CPP_OBJ_FILTER += $(ASF_PATH)/sam/drivers/gmac/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/drivers/mpu/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/usb/uhc/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/drivers/usbhs/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/clock/same70/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/drivers/mcan/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/drivers/twihs/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/drivers/cmcc/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/drivers/rswdt/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/storage/ecc_hamming/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/utils/syscalls/gcc/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/spi/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/components/memory/sd_mmc/sd_mmc_spi.h
CPP_OBJ_FILTER += $(ASF_PATH)/common/components/memory/sd_mmc/sd_mmc_spi.c
CPP_OBJ_FILTER += $(ASF_PATH)/common/components/memory/sd_mmc/module_config_spi/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/utils/osprintf/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/utils/membag/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/utils/stdio/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/clock/sam4s/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/clock/sam3s/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/clock/sam4e/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/components/ethernet_phy/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/drivers/acc/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/drivers/aes/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/drivers/crccu/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/drivers/afec/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/drivers/udp/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/drivers/xdmac/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/drivers/abdacb/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/delay/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/serial/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/fifo/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/crc32/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/isp/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/gfx_mono/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/gfx/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/sensors/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/hugemem/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/freertos/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/calendar/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/adp/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/usb/class/phdc/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/usb/class/msc/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/usb/class/hid/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/usb/class/dfu_flip/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/usb/class/composite/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/services/usb/class/aoa/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/drivers/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/same70/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/samg/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam4s/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam4n/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam4l/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam4e/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam4cp/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam4cm32/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sams70/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/samv70/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/samv71/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam4cm/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam4c/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam3u/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam3s8/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam3s/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/utils/cmsis/sam3n/%
CPP_OBJ_FILTER += $(ASF_PATH)/thirdparty/CMSIS/DSP_Lib/%
CPP_OBJ_FILTER += $(ASF_PATH)/common/applications/%
CPP_OBJ_FILTER += $(ASF_PATH)/sam/applications/%
CPP_OBJ_FILTER += $(LIBRARY_PATH)/SPI/%
CPP_OBJ_FILTER += $(LIBRARY_PATH)/HID/%
CPP_OBJ_FILTER += $(VARIANT_BASE_PATH)/same70/%
CPP_OBJ_FILTER += $(VARIANT_BASE_PATH)/sam4s/%
CPP_OBJ_FILTER += $(VARIANT_BASE_PATH)/alligator/%
CPP_OBJ_FILTER += $(VARIANT_BASE_PATH)/RADDS/%
CPP_OBJ_FILTER += $(VARIANT_BASE_PATH)/duetNG/%

CPP_SRC_TEMP := $(filter-out $(CPP_OBJ_FILTER), $(CPP_SRC))
CPP_OBJ_TEMP = $(patsubst %.cpp, %.o, $(notdir $(CPP_SRC_TEMP)))

CPP_SRC_PATHS := $(sort $(dir $(CPP_SRC_TEMP)))
CPP_OBJ=$(CPP_OBJ_TEMP)

INCLUDES_TEMP = $(addprefix -I,$(CPP_SRC_PATHS)) $(addprefix -I,$(C_SRC_PATHS))
INCLUDES += $(sort $(dir $(INCLUDES_TEMP)))

vpath %.cpp $(PROJECT_BASE_PATH) $(CPP_SRC_PATHS)
vpath %.hpp $(CPP_SRC_PATHS)
vpath %.c $(PROJECT_BASE_PATH) $(C_SRC_PATHS)
vpath %.h $(C_SRC_PATHS) $(CPP_SRC_PATHS)

#-------------------------------------------------------------------------------
# Assembler source files and objects
#-------------------------------------------------------------------------------
A_SRC=$(wildcard $(PROJECT_BASE_PATH)/*.s)

A_OBJ_TEMP=$(patsubst %.s, %.o, $(notdir $(A_SRC)))

# during development, remove some files
A_OBJ_FILTER=

A_OBJ=$(filter-out $(A_OBJ_FILTER), $(A_OBJ_TEMP))

#-------------------------------------------------------------------------------
# Rules
#-------------------------------------------------------------------------------
all: $(VARIANT)

$(VARIANT): create_output $(OUTPUT_LIB)

.PHONY: create_output
create_output:
	@echo ------------------------------------------------------------------------------------
	@echo -------------------------
	@echo --- Preparing variant $(VARIANT) files in $(OUTPUT_PATH) $(OUTPUT_BIN)
	@echo -------------------------
#	@echo *$(INCLUDES)
#	@echo -------------------------
#	@echo *$(C_SRC)
#	@echo -------------------------
#	@echo *$(C_OBJ)
#	@echo -------------------------
#	@echo *$(addprefix $(OUTPUT_PATH)/, $(C_OBJ))
#	@echo -------------------------
#	@echo *$(CPP_SRC)
#	@echo -------------------------
#	@echo *$(CPP_OBJ)
#	@echo -------------------------
#	@echo *$(addprefix $(OUTPUT_PATH)/, $(CPP_OBJ))
#	@echo -------------------------
#	@echo *$(A_SRC)
#	@echo -------------------------

	-@mkdir -p $(OUTPUT_PATH) 1>NUL 2>&1
	@echo ------------------------------------------------------------------------------------

$(addprefix $(OUTPUT_PATH)/,$(C_OBJ)): $(OUTPUT_PATH)/%.o: %.c
#	@"$(CC)" -v -c $(CFLAGS) $< -o $@
	@"$(CC)" -c $(CFLAGS) $< -o $@

$(addprefix $(OUTPUT_PATH)/,$(CPP_OBJ)): $(OUTPUT_PATH)/%.o: %.cpp
#	@"$(CC)" -c $(CPPFLAGS) $< -o $@
	@"$(CC)" -xc++ -c $(CPPFLAGS) $< -o $@

$(addprefix $(OUTPUT_PATH)/,$(A_OBJ)): $(OUTPUT_PATH)/%.o: %.s
	@"$(AS)" -c $(ASFLAGS) $< -o $@

$(OUTPUT_LIB): $(addprefix $(OUTPUT_PATH)/, $(C_OBJ)) $(addprefix $(OUTPUT_PATH)/, $(CPP_OBJ)) $(addprefix $(OUTPUT_PATH)/, $(A_OBJ))
	@mkdir -p $(OUTPUT_BIN) 1>NUL 2>&1
	@"$(AR)" -v -r "$(OUTPUT_BIN)/$@" $^
	@"$(NM)" "$(OUTPUT_BIN)/$@" > "$(OUTPUT_BIN)/$@.txt"


.PHONY: clean
clean:
	@echo ------------------------------------------------------------------------------------
	@echo --- Cleaning $(VARIANT) files [$(OUTPUT_PATH)$(SEP)*.o]
	-@$(RM) $(OUTPUT_PATH) 1>NUL 2>&1
	-@$(RM) $(OUTPUT_BIN)/$(OUTPUT_LIB) 1>NUL 2>&1
	@echo ------------------------------------------------------------------------------------

