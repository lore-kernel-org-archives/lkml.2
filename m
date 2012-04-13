Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab2DMPOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 11:14:20 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62387 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2DMPOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 11:14:18 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] Fix typo in various Kconfig file
Date: Sat, 14 Apr 2012 00:14:11 +0900
Message-Id: <1334330051-20051-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10.128.g7945c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in various Kconfig file.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/m68k/Kconfig.cpu                  |    2 +-
 arch/mips/Kconfig                      |    4 ++--
 arch/mips/Kconfig.debug                |    2 +-
 arch/openrisc/Kconfig                  |    2 +-
 arch/powerpc/platforms/Kconfig.cputype |    4 ++--
 arch/powerpc/platforms/pseries/Kconfig |    2 +-
 arch/sh/Kconfig.cpu                    |    2 +-
 drivers/devfreq/Kconfig                |    2 +-
 drivers/hid/Kconfig                    |    2 +-
 drivers/hwmon/Kconfig                  |    2 +-
 drivers/i2c/busses/Kconfig             |    2 +-
 drivers/mfd/Kconfig                    |    6 +++---
 drivers/ptp/Kconfig                    |    2 +-
 drivers/watchdog/Kconfig               |    2 +-
 drivers/xen/Kconfig                    |    2 +-
 15 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index 8a9c767..51b3274 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -7,7 +7,7 @@ choice
 	help
 	  The Freescale (was Motorola) M68K family of processors implements
 	  the full 68000 processor instruction set.
-	  The Freescale ColdFire family of processors is a modern derivitive
+	  The Freescale ColdFire family of processors is a modern derivative
 	  of the 68000 processor family. They are mainly targeted at embedded
 	  applications, and are all System-On-Chip (SOC) devices, as opposed
 	  to stand alone CPUs. They implement a subset of the original 68000
diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ce30e2f..923a6c3 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1001,12 +1001,12 @@ config HOLES_IN_ZONE
 	bool
 
 #
-# Endianess selection.  Sufficiently obscure so many users don't know what to
+# Endianness selection.  Sufficiently obscure so many users don't know what to
 # answer,so we try hard to limit the available choices.  Also the use of a
 # choice statement should be more obvious to the user.
 #
 choice
-	prompt "Endianess selection"
+	prompt "Endianness selection"
 	help
 	  Some MIPS machines can be configured for either little or big endian
 	  byte order. These modes require different kernels and a different
diff --git a/arch/mips/Kconfig.debug b/arch/mips/Kconfig.debug
index 83ed00a..5a43aa0 100644
--- a/arch/mips/Kconfig.debug
+++ b/arch/mips/Kconfig.debug
@@ -57,7 +57,7 @@ config CMDLINE
 	  options.
 
 config CMDLINE_OVERRIDE
-	bool "Built-in command line overrides firware arguments"
+	bool "Built-in command line overrides firmware arguments"
 	default n
 	depends on CMDLINE_BOOL
 	help
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index a478719..66dff20 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -141,7 +141,7 @@ config DEBUG_STACKOVERFLOW
 	bool "Check for kernel stack overflow"
 	default y
 	help
-	  Make extra checks for space avaliable on stack in some
+	  Make extra checks for space available on stack in some
           critical functions. This will cause kernel to run a bit slower,
 	  but will catch most of kernel stack overruns and exit gracefuly.
 
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index 425db18..9c80fc0 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -258,7 +258,7 @@ config PPC_ICSWX_PID
 	default y
 	---help---
 	  The PID register in server is used explicitly for ICSWX.  In
-	  embedded systems PID managment is done by the system.
+	  embedded systems PID management is done by the system.
 
 config PPC_ICSWX_USE_SIGILL
 	bool "Should a bad CT cause a SIGILL?"
@@ -266,7 +266,7 @@ config PPC_ICSWX_USE_SIGILL
 	default n
 	---help---
 	  Should a bad CT used for "non-record form ICSWX" cause an
-	  illegal intruction signal or should it be silent as
+	  illegal instruction signal or should it be silent as
 	  architected.
 
 	  If in doubt, say N here.
diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platforms/pseries/Kconfig
index aadbe4f..10ad207 100644
--- a/arch/powerpc/platforms/pseries/Kconfig
+++ b/arch/powerpc/platforms/pseries/Kconfig
@@ -67,7 +67,7 @@ config IO_EVENT_IRQ
 
 	  This option will only enable the IO event platform code. You
 	  will still need to enable or compile the actual drivers
-	  that use this infrastruture to handle IO event interrupts.
+	  that use this infrastructure to handle IO event interrupts.
 
 	  Say Y if you are unsure.
 
diff --git a/arch/sh/Kconfig.cpu b/arch/sh/Kconfig.cpu
index ddf096c..770ff2d 100644
--- a/arch/sh/Kconfig.cpu
+++ b/arch/sh/Kconfig.cpu
@@ -1,7 +1,7 @@
 menu "Processor features"
 
 choice
-	prompt "Endianess selection" 
+	prompt "Endianness selection" 
 	default CPU_LITTLE_ENDIAN
 	help
 	  Some SuperH machines can be configured for either little or big
diff --git a/drivers/devfreq/Kconfig b/drivers/devfreq/Kconfig
index 464fa21..f6b0a6e2 100644
--- a/drivers/devfreq/Kconfig
+++ b/drivers/devfreq/Kconfig
@@ -16,7 +16,7 @@ menuconfig PM_DEVFREQ
 	  is attached to a single device and returns a "representative"
 	  clock frequency of the device, which is also attached
 	  to a device by 1-to-1. The device registering devfreq takes the
-	  responsiblity to "interpret" the representative frequency and
+	  responsibility to "interpret" the representative frequency and
 	  to set its every clock accordingly with the "target" callback
 	  given to devfreq.
 
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index a3d0332..478eb4a 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -448,7 +448,7 @@ config HID_PICOLCD_FB
 	select FB_SYS_FOPS
 	---help---
 	  Provide access to PicoLCD's 256x64 monochrome display via a
-	  frambuffer device.
+	  framebuffer device.
 
 config HID_PICOLCD_BACKLIGHT
 	bool "Backlight control" if EXPERT
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 8deedc1..e466ecb 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -318,7 +318,7 @@ config SENSORS_EXYNOS4_TMU
 	tristate "Temperature sensor on Samsung EXYNOS4"
 	depends on ARCH_EXYNOS4
 	help
-	  If you say yes here you get support for TMU (Thermal Managment
+	  If you say yes here you get support for TMU (Thermal Management
 	  Unit) on SAMSUNG EXYNOS4 series of SoC.
 
 	  This driver can also be built as a module. If so, the module
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index d2c5095..94468a6 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -351,7 +351,7 @@ config I2C_DAVINCI
 	  For details please see http://www.ti.com/davinci
 
 config I2C_DESIGNWARE_PLATFORM
-	tristate "Synopsys DesignWare Platfrom"
+	tristate "Synopsys DesignWare Platform"
 	depends on HAVE_CLK
 	help
 	  If you say yes to this option, support will be included for the
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 29f463c..639e1fc 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -407,7 +407,7 @@ config MFD_MAX8925
 	select MFD_CORE
 	help
 	  Say yes here to support for Maxim Semiconductor MAX8925. This is
-	  a Power Management IC. This driver provies common support for
+	  a Power Management IC. This driver provides common support for
 	  accessing the device, additional drivers must be enabled in order
 	  to use the functionality of the device.
 
@@ -430,7 +430,7 @@ config MFD_MAX8998
 	help
 	  Say yes here to support for Maxim Semiconductor MAX8998 and
 	  National Semiconductor LP3974. This is a Power Management IC.
-	  This driver provies common support for accessing the device,
+	  This driver provides common support for accessing the device,
 	  additional drivers must be enabled in order to use the functionality
 	  of the device.
 
@@ -441,7 +441,7 @@ config MFD_S5M_CORE
 	select REGMAP_I2C
 	help
 	 Support for the Samsung Electronics S5M MFD series.
-	 This driver provies common support for accessing the device,
+	 This driver provides common support for accessing the device,
 	 additional drivers must be enabled in order to use the functionality
 	 of the device
 
diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index cd9bc3b..b4b918a 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -70,7 +70,7 @@ config DP83640_PHY
 	  using the SO_TIMESTAMPING API.
 
 	  In order for this to work, your MAC driver must also
-	  implement the skb_tx_timetamp() function.
+	  implement the skb_tx_timestamp() function.
 
 config PTP_1588_CLOCK_PCH
 	tristate "Intel PCH EG20T as PTP clock"
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 3709624..eeea76f 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -937,7 +937,7 @@ config BCM47XX_WDT
 	tristate "Broadcom BCM47xx Watchdog Timer"
 	depends on BCM47XX
 	help
-	  Hardware driver for the Broadcom BCM47xx Watchog Timer.
+	  Hardware driver for the Broadcom BCM47xx Watchdog Timer.
 
 config RC32434_WDT
 	tristate "IDT RC32434 SoC Watchdog Timer"
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 9424313..73f1c99 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -71,7 +71,7 @@ config XEN_DEV_EVTCHN
 	tristate "Xen /dev/xen/evtchn device"
 	default y
 	help
-	  The evtchn driver allows a userspace process to triger event
+	  The evtchn driver allows a userspace process to trigger event
 	  channels and to receive notification of an event channel
 	  firing.
 	  If in doubt, say yes.
-- 
1.7.10.128.g7945c

