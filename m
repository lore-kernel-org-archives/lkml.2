Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933415Ab1INVw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 17:52:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33176 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380Ab1INVwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 17:52:55 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: [PATCH v2 1/3]Fix typos in the kernel
Date: Wed, 14 Sep 2011 14:52:25 -0700
Message-Id: <1316037145-18079-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Resend with changes.
The below patch fixes some typos that I have found in the kernel.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Cc: J. Bruce Fields <bfields@fieldses.org>

---
 arch/arm/mach-omap2/smartreflex.c               |    2 +-
 arch/arm/plat-omap/include/plat/serial.h        |    2 +-
 arch/powerpc/include/asm/io.h                   |    2 +-
 arch/powerpc/include/asm/keylargo.h             |    2 +-
 arch/powerpc/mm/numa.c                          |    2 +-
 arch/powerpc/platforms/embedded6xx/storcenter.c |    2 +-
 arch/sparc/kernel/smp_64.c                      |    2 +-
 drivers/acpi/acpica/hwxface.c                   |    2 +-
 drivers/base/regmap/regmap.c                    |    2 +-
 drivers/block/xen-blkback/xenbus.c              |    2 +-
 drivers/char/ipmi/ipmi_bt_sm.c                  |    2 +-
 drivers/edac/ppc4xx_edac.c                      |    2 +-
 drivers/media/video/zoran/zoran_driver.c        |    2 +-
 13 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index 34c01a7..f49804f 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -247,7 +247,7 @@ static void sr_stop_vddautocomp(struct omap_sr *sr)
  * driver register and sr device intializtion API's. Only one call
  * will ultimately succeed.
  *
- * Currently this function registers interrrupt handler for a particular SR
+ * Currently this function registers interrupt handler for a particular SR
  * if smartreflex class driver is already registered and has
  * requested for interrupts and the SR interrupt line in present.
  */
diff --git a/arch/arm/plat-omap/include/plat/serial.h b/arch/arm/plat-omap/include/plat/serial.h
index de3b10c..564646d 100644
--- a/arch/arm/plat-omap/include/plat/serial.h
+++ b/arch/arm/plat-omap/include/plat/serial.h
@@ -2,7 +2,7 @@
  * arch/arm/plat-omap/include/mach/serial.h
  *
  * Copyright (C) 2009 Texas Instruments
- * Addded OMAP4 support- Santosh Shilimkar <santosh.shilimkar@ti.com>
+ * Added OMAP4 support- Santosh Shilimkar <santosh.shilimkar@ti.com>
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
index 45698d5..2fd3645 100644
--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -394,7 +394,7 @@ __do_out_asm(_rec_outl, "stwbrx")
 #endif /* CONFIG_PPC32 */
 
 /* The "__do_*" operations below provide the actual "base" implementation
- * for each of the defined acccessor. Some of them use the out_* functions
+ * for each of the defined accessor. Some of them use the out_* functions
  * directly, some of them still use EEH, though we might change that in the
  * future. Those macros below provide the necessary argument swapping and
  * handling of the IO base for PIO.
diff --git a/arch/powerpc/include/asm/keylargo.h b/arch/powerpc/include/asm/keylargo.h
index d8520ef..fc195d0 100644
--- a/arch/powerpc/include/asm/keylargo.h
+++ b/arch/powerpc/include/asm/keylargo.h
@@ -51,7 +51,7 @@
 
 #define KL_GPIO_SOUND_POWER		(KEYLARGO_GPIO_0+0x05)
 
-/* Hrm... this one is only to be used on Pismo. It seeem to also
+/* Hrm... this one is only to be used on Pismo. It seems to also
  * control the timebase enable on other machines. Still to be
  * experimented... --BenH.
  */
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 2164006..ef2674d 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -511,7 +511,7 @@ static int of_get_assoc_arrays(struct device_node *memory,
 	aa->n_arrays = *prop++;
 	aa->array_sz = *prop++;
 
-	/* Now that we know the number of arrrays and size of each array,
+	/* Now that we know the number of arrays and size of each array,
 	 * revalidate the size of the property read in.
 	 */
 	if (len < (aa->n_arrays * aa->array_sz + 2) * sizeof(unsigned int))
diff --git a/arch/powerpc/platforms/embedded6xx/storcenter.c b/arch/powerpc/platforms/embedded6xx/storcenter.c
index 613070e..f1eebca 100644
--- a/arch/powerpc/platforms/embedded6xx/storcenter.c
+++ b/arch/powerpc/platforms/embedded6xx/storcenter.c
@@ -77,7 +77,7 @@ static void __init storcenter_setup_arch(void)
 }
 
 /*
- * Interrupt setup and service.  Interrrupts on the turbostation come
+ * Interrupt setup and service.  Interrupts on the turbostation come
  * from the four PCI slots plus onboard 8241 devices: I2C, DUART.
  */
 static void __init storcenter_init_IRQ(void)
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 4a442c3..92aa0e7 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -840,7 +840,7 @@ static void tsb_sync(void *info)
 	struct trap_per_cpu *tp = &trap_block[raw_smp_processor_id()];
 	struct mm_struct *mm = info;
 
-	/* It is not valid to test "currrent->active_mm == mm" here.
+	/* It is not valid to test "current->active_mm == mm" here.
 	 *
 	 * The value of "current" is not changed atomically with
 	 * switch_mm().  But that's OK, we just need to check the
diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
index f75f81a..f34ba22 100644
--- a/drivers/acpi/acpica/hwxface.c
+++ b/drivers/acpi/acpica/hwxface.c
@@ -355,7 +355,7 @@ ACPI_EXPORT_SYMBOL(acpi_read_bit_register)
  *
  * PARAMETERS:  register_id     - ID of ACPI Bit Register to access
  *              Value           - Value to write to the register, in bit
- *                                position zero. The bit is automaticallly
+ *                                position zero. The bit is automatically
  *                                shifted to the correct position.
  *
  * RETURN:      Status
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 0eef4da..d6217d2 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -309,7 +309,7 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 
 	/*
 	 * Some buses flag reads by setting the high bits in the
-	 * register addresss; since it's always the high bits for all
+	 * register address; since it's always the high bits for all
 	 * current formats we can do this here rather than in
 	 * formatting.  This may break if we get interesting formats.
 	 */
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 3f129b4..c092368 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -582,7 +582,7 @@ static void frontend_changed(struct xenbus_device *dev,
 	case XenbusStateConnected:
 		/*
 		 * Ensure we connect even when two watches fire in
-		 * close successsion and we miss the intermediate value
+		 * close succession and we miss the intermediate value
 		 * of frontend_state.
 		 */
 		if (dev->state == XenbusStateConnected)
diff --git a/drivers/char/ipmi/ipmi_bt_sm.c b/drivers/char/ipmi/ipmi_bt_sm.c
index 3ed20e8..cdd4c09f 100644
--- a/drivers/char/ipmi/ipmi_bt_sm.c
+++ b/drivers/char/ipmi/ipmi_bt_sm.c
@@ -560,7 +560,7 @@ static enum si_sm_result bt_event(struct si_sm_data *bt, long time)
 		BT_CONTROL(BT_H_BUSY);		/* set */
 
 		/*
-		 * Uncached, ordered writes should just proceeed serially but
+		 * Uncached, ordered writes should just proceed serially but
 		 * some BMCs don't clear B2H_ATN with one hit.  Fast-path a
 		 * workaround without too much penalty to the general case.
 		 */
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index 0de7d87..032a9c6 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -142,7 +142,7 @@
 
 /*
  * The ibm,sdram-4xx-ddr2 Device Control Registers (DCRs) are
- * indirectly acccessed and have a base and length defined by the
+ * indirectly accessed and have a base and length defined by the
  * device tree. The base can be anything; however, we expect the
  * length to be precisely two registers, the first for the address
  * window and the second for the data window.
diff --git a/drivers/media/video/zoran/zoran_driver.c b/drivers/media/video/zoran/zoran_driver.c
index d4d05d2..c624403 100644
--- a/drivers/media/video/zoran/zoran_driver.c
+++ b/drivers/media/video/zoran/zoran_driver.c
@@ -1550,7 +1550,7 @@ static int zoran_enum_fmt(struct zoran *zr, struct v4l2_fmtdesc *fmt, int flag)
 		if (zoran_formats[i].flags & flag && num++ == fmt->index) {
 			strncpy(fmt->description, zoran_formats[i].name,
 				sizeof(fmt->description) - 1);
-			/* fmt struct pre-zeroed, so adding '\0' not neeed */
+			/* fmt struct pre-zeroed, so adding '\0' not need */
 			fmt->pixelformat = zoran_formats[i].fourcc;
 			if (zoran_formats[i].flags & ZORAN_FORMAT_COMPRESSED)
 				fmt->flags |= V4L2_FMT_FLAG_COMPRESSED;
-- 
1.7.6

