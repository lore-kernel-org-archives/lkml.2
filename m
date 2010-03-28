Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0C1R3x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 13:29:53 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:45854 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab0C1R3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 13:29:51 -0400
From: Gilles Espinasse <g.esp@free.fr>
To: jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org, Gilles Espinasse <g.esp@free.fr>
Subject: [PATCH] Fix requr typo on various files comments Signed-off-by: Gilles Espinasse <g.esp@free.fr>
Date: Sun, 28 Mar 2010 19:29:39 +0200
Message-Id: <1269797379-4724-1-git-send-email-g.esp@free.fr>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 Documentation/powerpc/dts-bindings/xilinx.txt |    2 +-
 arch/mips/sibyte/bcm1480/irq.c                |    2 +-
 arch/mips/sibyte/sb1250/irq.c                 |    2 +-
 drivers/gpu/drm/i915/intel_display.c          |    4 ++--
 drivers/gpu/drm/radeon/atombios.h             |    4 ++--
 drivers/isdn/hardware/mISDN/hfcmulti.c        |    2 +-
 drivers/net/bnx2x_hsi.h                       |    2 +-
 drivers/net/ps3_gelic_wireless.c              |    2 +-
 drivers/usb/wusbcore/wa-xfer.c                |    2 +-
 net/ipv4/ipmr.c                               |    2 +-
 scripts/package/mkspec                        |    2 +-
 11 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/powerpc/dts-bindings/xilinx.txt b/Documentation/powerpc/dts-bindings/xilinx.txt
index ea68046..299d092 100644
--- a/Documentation/powerpc/dts-bindings/xilinx.txt
+++ b/Documentation/powerpc/dts-bindings/xilinx.txt
@@ -11,7 +11,7 @@
    control how the core is synthesized.  Historically, the EDK tool would
    extract the device parameters relevant to device drivers and copy them
    into an 'xparameters.h' in the form of #define symbols.  This tells the
-   device drivers how the IP cores are configured, but it requres the kernel
+   device drivers how the IP cores are configured, but it requires the kernel
    to be recompiled every time the FPGA bitstream is resynthesized.
 
    The new approach is to export the parameters into the device tree and
diff --git a/arch/mips/sibyte/bcm1480/irq.c b/arch/mips/sibyte/bcm1480/irq.c
index 06e25d9..3fbb033 100644
--- a/arch/mips/sibyte/bcm1480/irq.c
+++ b/arch/mips/sibyte/bcm1480/irq.c
@@ -254,7 +254,7 @@ void __init init_bcm1480_irqs(void)
  * On the second cpu, everything is set to IP5, which is
  * ignored, EXCEPT the mailbox interrupt.  That one is
  * set to IP[2] so it is handled.  This is needed so we
- * can do cross-cpu function calls, as requred by SMP
+ * can do cross-cpu function calls, as required by SMP
  */
 
 #define IMR_IP2_VAL	K_BCM1480_INT_MAP_I0
diff --git a/arch/mips/sibyte/sb1250/irq.c b/arch/mips/sibyte/sb1250/irq.c
index ab44a2f..b452e3c 100644
--- a/arch/mips/sibyte/sb1250/irq.c
+++ b/arch/mips/sibyte/sb1250/irq.c
@@ -237,7 +237,7 @@ void __init init_sb1250_irqs(void)
  * On the second cpu, everything is set to IP5, which is
  * ignored, EXCEPT the mailbox interrupt.  That one is
  * set to IP[2] so it is handled.  This is needed so we
- * can do cross-cpu function calls, as requred by SMP
+ * can do cross-cpu function calls, as required by SMP
  */
 
 #define IMR_IP2_VAL	K_INT_MAP_I0
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 58fc7fa..c90d980 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -904,9 +904,9 @@ intel_g4x_find_best_PLL(const intel_limit_t *limit, struct drm_crtc *crtc,
 
 	memset(best_clock, 0, sizeof(*best_clock));
 	max_n = limit->n.max;
-	/* based on hardware requriment prefer smaller n to precision */
+	/* based on hardware requirement, prefer smaller n to precision */
 	for (clock.n = limit->n.min; clock.n <= max_n; clock.n++) {
-		/* based on hardware requirment prefere larger m1,m2 */
+		/* based on hardware requirement, prefere larger m1,m2 */
 		for (clock.m1 = limit->m1.max;
 		     clock.m1 >= limit->m1.min; clock.m1--) {
 			for (clock.m2 = limit->m2.max;
diff --git a/drivers/gpu/drm/radeon/atombios.h b/drivers/gpu/drm/radeon/atombios.h
index 6732b5d..e91a815 100644
--- a/drivers/gpu/drm/radeon/atombios.h
+++ b/drivers/gpu/drm/radeon/atombios.h
@@ -3780,7 +3780,7 @@ typedef struct _ATOM_ASIC_SS_ASSIGNMENT
 	UCHAR								ucReserved[2];
 }ATOM_ASIC_SS_ASSIGNMENT;
 
-//Define ucClockIndication, SW uses the IDs below to search if the SS is requried/enabled on a clock branch/signal type.
+//Define ucClockIndication, SW uses the IDs below to search if the SS is required/enabled on a clock branch/signal type.
 //SS is not required or enabled if a match is not found.
 #define ASIC_INTERNAL_MEMORY_SS			1
 #define ASIC_INTERNAL_ENGINE_SS			2
@@ -5895,7 +5895,7 @@ typedef struct _ATOM_PPLIB_RS780_CLOCK_INFO
       UCHAR  ucPadding;                   // For proper alignment and size.
       USHORT usVDDC;                      // For the 780, use: None, Low, High, Variable
       UCHAR  ucMaxHTLinkWidth;            // From SBIOS - {2, 4, 8, 16}
-      UCHAR  ucMinHTLinkWidth;            // From SBIOS - {2, 4, 8, 16}. Effective only if CDLW enabled. Minimum down stream width could be bigger as display BW requriement.
+      UCHAR  ucMinHTLinkWidth;            // From SBIOS - {2, 4, 8, 16}. Effective only if CDLW enabled. Minimum down stream width could be bigger as display BW requirement.
       USHORT usHTLinkFreq;                // See definition ATOM_PPLIB_RS780_HTLINKFREQ_xxx or in MHz(>=200).
       ULONG  ulFlags; 
 } ATOM_PPLIB_RS780_CLOCK_INFO;
diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 8affba3..68e321e 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -117,7 +117,7 @@
  *	NOTE: only one mode value must be given for every card.
  *	-> See hfc_multi.h for HFC_IO_MODE_* values
  *	By default, the IO mode is pci memory IO (MEMIO).
- *	Some cards requre specific IO mode, so it cannot be changed.
+ *	Some cards require specific IO mode, so it cannot be changed.
  *	It may be usefull to set IO mode to register io (REGIO) to solve
  *	PCI bridge problems.
  *	If unsure, don't give this parameter.
diff --git a/drivers/net/bnx2x_hsi.h b/drivers/net/bnx2x_hsi.h
index 7600693..fd1f29e 100644
--- a/drivers/net/bnx2x_hsi.h
+++ b/drivers/net/bnx2x_hsi.h
@@ -683,7 +683,7 @@ struct drv_func_mb {
 #define DRV_MSG_CODE_GET_MANUF_KEY			0x82000000
 #define DRV_MSG_CODE_LOAD_L2B_PRAM			0x90000000
 	/*
-	 * The optic module verification commands requris bootcode
+	 * The optic module verification commands require bootcode
 	 * v5.0.6 or later
 	 */
 #define DRV_MSG_CODE_VRFY_OPT_MDL			0xa0000000
diff --git a/drivers/net/ps3_gelic_wireless.c b/drivers/net/ps3_gelic_wireless.c
index 2663b2f..7fe54c2 100644
--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -95,7 +95,7 @@ static inline int precise_ie(void)
  * post_eurus_cmd helpers
  */
 struct eurus_cmd_arg_info {
-	int pre_arg; /* command requres arg1, arg2 at POST COMMAND */
+	int pre_arg; /* command requires arg1, arg2 at POST COMMAND */
 	int post_arg; /* command requires arg1, arg2 at GET_RESULT */
 };
 
diff --git a/drivers/usb/wusbcore/wa-xfer.c b/drivers/usb/wusbcore/wa-xfer.c
index 489b478..3aad333 100644
--- a/drivers/usb/wusbcore/wa-xfer.c
+++ b/drivers/usb/wusbcore/wa-xfer.c
@@ -76,7 +76,7 @@
  *     xfers-per-ripe, blocks-per-rpipe, rpipes-per-host), at the end
  *     we are going to have to rebuild all this based on an scheduler,
  *     to where we have a list of transactions to do and based on the
- *     availability of the different requried components (blocks,
+ *     availability of the different required components (blocks,
  *     rpipes, segment slots, etc), we go scheduling them. Painful.
  */
 #include <linux/init.h>
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 0b9d03c..128b410 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -22,7 +22,7 @@
  *					overflow.
  *      Carlos Picoto           :       PIMv1 Support
  *	Pavlin Ivanov Radoslavov:	PIMv2 Registers must checksum only PIM header
- *					Relax this requrement to work with older peers.
+ *					Relax this requirement to work with older peers.
  *
  */
 
diff --git a/scripts/package/mkspec b/scripts/package/mkspec
index 47bdd2f..fa27f3d 100755
--- a/scripts/package/mkspec
+++ b/scripts/package/mkspec
@@ -1,6 +1,6 @@
 #!/bin/sh
 #
-#	Output a simple RPM spec file that uses no fancy features requring
+#	Output a simple RPM spec file that uses no fancy features requiring
 #	RPM v4. This is intended to work with any RPM distro.
 #
 #	The only gothic bit here is redefining install_post to avoid
-- 
1.6.4.4

