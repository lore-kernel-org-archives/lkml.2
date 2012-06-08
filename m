Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab2FHPqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:46:43 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39085 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932273Ab2FHPql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:46:41 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org, rob@landley.net
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] Documentation: Fix typo in devicetree/bindings
Date: Sat,  9 Jun 2012 00:46:58 +0900
Message-Id: <1339170418-9999-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.11.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in Documentation/devicetree/bindings

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/devicetree/bindings/arm/atmel-aic.txt                | 2 +-
 Documentation/devicetree/bindings/arm/gic.txt                      | 4 ++--
 Documentation/devicetree/bindings/arm/omap/omap.txt                | 6 +++---
 Documentation/devicetree/bindings/i2c/samsung-i2c.txt              | 2 +-
 Documentation/devicetree/bindings/mips/cavium/dma-engine.txt       | 2 +-
 Documentation/devicetree/bindings/powerpc/4xx/emac.txt             | 2 +-
 Documentation/devicetree/bindings/regulator/tps62360-regulator.txt | 4 ++--
 Documentation/devicetree/bindings/rtc/s3c-rtc.txt                  | 2 +-
 Documentation/devicetree/bindings/watchdog/samsung-wdt.txt         | 2 +-
 9 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/atmel-aic.txt b/Documentation/devicetree/bindings/arm/atmel-aic.txt
index aabca4f..e397917 100644
--- a/Documentation/devicetree/bindings/arm/atmel-aic.txt
+++ b/Documentation/devicetree/bindings/arm/atmel-aic.txt
@@ -4,7 +4,7 @@ Required properties:
 - compatible: Should be "atmel,<chip>-aic"
 - interrupt-controller: Identifies the node as an interrupt controller.
 - interrupt-parent: For single AIC system, it is an empty property.
-- #interrupt-cells: The number of cells to define the interrupts. It sould be 2.
+- #interrupt-cells: The number of cells to define the interrupts. It should be 2.
   The first cell is the IRQ number (aka "Peripheral IDentifier" on datasheet).
   The second cell is used to specify flags:
     bits[3:0] trigger type and level flags:
diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
index 62eb8df..3dfb0c0 100644
--- a/Documentation/devicetree/bindings/arm/gic.txt
+++ b/Documentation/devicetree/bindings/arm/gic.txt
@@ -42,7 +42,7 @@ Main node required properties:
 
 Optional
 - interrupts	: Interrupt source of the parent interrupt controller on
-  secondary GICs, or VGIC maintainance interrupt on primary GIC (see
+  secondary GICs, or VGIC maintenance interrupt on primary GIC (see
   below).
 
 - cpu-offset	: per-cpu offset within the distributor and cpu interface
@@ -74,7 +74,7 @@ Required properties:
   virtual interface control register base and size. The 2nd additional
   region is the GIC virtual cpu interface register base and size.
 
-- interrupts : VGIC maintainance interrupt.
+- interrupts : VGIC maintenance interrupt.
 
 Example:
 
diff --git a/Documentation/devicetree/bindings/arm/omap/omap.txt b/Documentation/devicetree/bindings/arm/omap/omap.txt
index e78e8bc..cc8108c 100644
--- a/Documentation/devicetree/bindings/arm/omap/omap.txt
+++ b/Documentation/devicetree/bindings/arm/omap/omap.txt
@@ -36,14 +36,14 @@ Boards:
 - OMAP3 BeagleBoard : Low cost community board
   compatible = "ti,omap3-beagle", "ti,omap3"
 
-- OMAP4 SDP : Software Developement Board
+- OMAP4 SDP : Software Development Board
   compatible = "ti,omap4-sdp", "ti,omap4430"
 
 - OMAP4 PandaBoard : Low cost community board
   compatible = "ti,omap4-panda", "ti,omap4430"
 
-- OMAP3 EVM : Software Developement Board for OMAP35x, AM/DM37x
+- OMAP3 EVM : Software Development Board for OMAP35x, AM/DM37x
   compatible = "ti,omap3-evm", "ti,omap3"
 
-- AM335X EVM : Software Developement Board for AM335x
+- AM335X EVM : Software Development Board for AM335x
   compatible = "ti,am335x-evm", "ti,am33xx", "ti,omap3"
diff --git a/Documentation/devicetree/bindings/i2c/samsung-i2c.txt b/Documentation/devicetree/bindings/i2c/samsung-i2c.txt
index b6cb5a1..ccdf9c9 100644
--- a/Documentation/devicetree/bindings/i2c/samsung-i2c.txt
+++ b/Documentation/devicetree/bindings/i2c/samsung-i2c.txt
@@ -18,7 +18,7 @@ Optional properties:
     The gpio specifier depends on the gpio controller. Required in all
     cases except for "samsung,s3c2440-hdmiphy-i2c" whose input/output
     lines are permanently wired to the respective client
-  - samsung,i2c-slave-addr: Slave address in multi-master enviroment. If not
+  - samsung,i2c-slave-addr: Slave address in multi-master environment. If not
     specified, default value is 0.
   - samsung,i2c-max-bus-freq: Desired frequency in Hz of the bus. If not
     specified, the default value in Hz is 100000.
diff --git a/Documentation/devicetree/bindings/mips/cavium/dma-engine.txt b/Documentation/devicetree/bindings/mips/cavium/dma-engine.txt
index cb4291e..a5bdff4 100644
--- a/Documentation/devicetree/bindings/mips/cavium/dma-engine.txt
+++ b/Documentation/devicetree/bindings/mips/cavium/dma-engine.txt
@@ -1,7 +1,7 @@
 * DMA Engine.
 
 The Octeon DMA Engine transfers between the Boot Bus and main memory.
-The DMA Engine will be refered to by phandle by any device that is
+The DMA Engine will be referred to by phandle by any device that is
 connected to it.
 
 Properties:
diff --git a/Documentation/devicetree/bindings/powerpc/4xx/emac.txt b/Documentation/devicetree/bindings/powerpc/4xx/emac.txt
index 2161334..712baf6 100644
--- a/Documentation/devicetree/bindings/powerpc/4xx/emac.txt
+++ b/Documentation/devicetree/bindings/powerpc/4xx/emac.txt
@@ -1,7 +1,7 @@
     4xx/Axon EMAC ethernet nodes
 
     The EMAC ethernet controller in IBM and AMCC 4xx chips, and also
-    the Axon bridge.  To operate this needs to interact with a ths
+    the Axon bridge.  To operate this needs to interact with a this
     special McMAL DMA controller, and sometimes an RGMII or ZMII
     interface.  In addition to the nodes and properties described
     below, the node for the OPB bus on which the EMAC sits must have a
diff --git a/Documentation/devicetree/bindings/regulator/tps62360-regulator.txt b/Documentation/devicetree/bindings/regulator/tps62360-regulator.txt
index c8ca6b8..1b20c3d 100644
--- a/Documentation/devicetree/bindings/regulator/tps62360-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/tps62360-regulator.txt
@@ -17,9 +17,9 @@ Optional properties:
 - ti,vsel1-gpio: Gpio for controlling VSEL1 line.
   If this property is missing, then assume that there is no GPIO
   for vsel1 control.
-- ti,vsel0-state-high: Inital state of vsel0 input is high.
+- ti,vsel0-state-high: Initial state of vsel0 input is high.
   If this property is missing, then assume the state as low (0).
-- ti,vsel1-state-high: Inital state of vsel1 input is high.
+- ti,vsel1-state-high: Initial state of vsel1 input is high.
   If this property is missing, then assume the state as low (0).
 
 Any property defined as part of the core regulator binding, defined in
diff --git a/Documentation/devicetree/bindings/rtc/s3c-rtc.txt b/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
index 90ec45f..7ac7259 100644
--- a/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
+++ b/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
@@ -7,7 +7,7 @@ Required properties:
 - reg: physical base address of the controller and length of memory mapped
   region.
 - interrupts: Two interrupt numbers to the cpu should be specified. First
-  interrupt number is the rtc alarm interupt and second interrupt number
+  interrupt number is the rtc alarm interrupt and second interrupt number
   is the rtc tick interrupt. The number of cells representing a interrupt
   depends on the parent interrupt controller.
 
diff --git a/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt b/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt
index 79ead82..ce0d8e7 100644
--- a/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt
+++ b/Documentation/devicetree/bindings/watchdog/samsung-wdt.txt
@@ -2,7 +2,7 @@
 
 The Samsung's Watchdog controller is used for resuming system operation
 after a preset amount of time during which the WDT reset event has not
-occured.
+occurred.
 
 Required properties:
 - compatible : should be "samsung,s3c2410-wdt"
-- 
1.7.11.rc2

