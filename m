Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab1JNMaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:30:12 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:58455 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab1JNMaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:30:09 -0400
Subject: [PATCH 12/21] m68k: drop unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:29:31 +0200
Message-ID: <1318595371.6132.70.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/m68k/Kconfig       |   28 +---------------------------
 arch/m68k/Kconfig.nommu |   44 --------------------------------------------
 2 files changed, 1 insertions(+), 71 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 9e8ee9d..58c6496 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -149,32 +149,6 @@ config MULTIFACE_III_TTY
 
 	  To compile this driver as a module, choose M here.
 
-config GVPIOEXT
-	tristate "GVP IO-Extender support"
-	depends on PARPORT=n && ZORRO
-	help
-	  If you want to use a GVP IO-Extender serial card in Linux, say Y.
-	  Otherwise, say N.
-
-config GVPIOEXT_LP
-	tristate "GVP IO-Extender parallel printer support"
-	depends on GVPIOEXT
-	help
-	  Say Y to enable driving a printer from the parallel port on your
-	  GVP IO-Extender card, N otherwise.
-
-config GVPIOEXT_PLIP
-	tristate "GVP IO-Extender PLIP support"
-	depends on GVPIOEXT
-	help
-	  Say Y to enable doing IP over the parallel port on your GVP
-	  IO-Extender card, N otherwise.
-
-config MAC_HID
-	bool
-	depends on INPUT_ADBHID
-	default y
-
 config HPDCA
 	tristate "HP DCA serial support"
 	depends on DIO && SERIAL_8250
@@ -217,7 +191,7 @@ config DN_SERIAL
 
 config SERIAL_CONSOLE
 	bool "Support for serial port console"
-	depends on (AMIGA || ATARI || SUN3 || SUN3X || VME || APOLLO) && (ATARI_MFPSER=y || ATARI_MIDI=y || AMIGA_BUILTIN_SERIAL=y || GVPIOEXT=y || MULTIFACE_III_TTY=y || SERIAL=y || MVME147_SCC || SERIAL167 || MVME162_SCC || BVME6000_SCC || DN_SERIAL)
+	depends on (AMIGA || ATARI || SUN3 || SUN3X || VME || APOLLO) && (ATARI_MFPSER=y || ATARI_MIDI=y || AMIGA_BUILTIN_SERIAL=y || MULTIFACE_III_TTY=y || SERIAL=y || MVME147_SCC || SERIAL167 || MVME162_SCC || BVME6000_SCC || DN_SERIAL)
 	---help---
 	  If you say Y here, it will be possible to use a serial port as the
 	  system console (the system console is the device which receives all
diff --git a/arch/m68k/Kconfig.nommu b/arch/m68k/Kconfig.nommu
index ff46383..2b7f1e9 100644
--- a/arch/m68k/Kconfig.nommu
+++ b/arch/m68k/Kconfig.nommu
@@ -542,13 +542,6 @@ config SAVANTrosie1
 	help
 	  Support for the Savant Rosie1 board.
 
-config ROMFS_FROM_ROM
-	bool "ROMFS image not RAM resident"
-	depends on (NETtel || SNAPGEAR)
-	help
-	  The ROMfs filesystem will stay resident in the FLASH/ROM, not be
-	  moved into RAM.
-
 config PILOT
 	bool
 	default y
@@ -564,21 +557,11 @@ config FREESCALE
 	default y
 	depends on (M5206eC3 || M5208EVB || M5235EVB || M5249C3 || M5271EVB || M5272C3 || M5275EVB || M5282EVB || M5307C3 || M5329EVB || M5407C3)
 
-config HW_FEITH
-	bool
-	default y
-	depends on (CLEOPATRA || CANCam || SCALES)
-
 config senTec
 	bool
 	default y
 	depends on (COBRA5272 || COBRA5282)
 	
-config EMAC_INC
-	bool
-	default y
-	depends on (SOM5282EM)
-
 config SNEHA
 	bool
 	default y
@@ -673,33 +656,6 @@ config KERNELBASE
 	  a system with the RAM based at address 0, and leaving enough room
 	  for the theoretical maximum number of 256 vectors.
 
-choice
-	prompt "RAM bus width"
-	default RAMAUTOBIT
-
-config RAMAUTOBIT
-	bool "AUTO"
-	help
-	  Select the physical RAM data bus size. Not needed on most platforms,
-	  so you can generally choose AUTO.
-
-config RAM8BIT
-	bool "8bit"
-	help
-	  Configure RAM bus to be 8 bits wide.
-
-config RAM16BIT
-	bool "16bit"
-	help
-	  Configure RAM bus to be 16 bits wide.
-
-config RAM32BIT
-	bool "32bit"
-	help
-	  Configure RAM bus to be 32 bits wide.
-
-endchoice
-
 comment "ROM configuration"
 
 config ROM
-- 
1.7.4.4




