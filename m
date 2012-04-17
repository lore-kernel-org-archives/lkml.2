Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab2DQSbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:31:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44211 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab2DQSbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:31:08 -0400
From: David Mackey <tdmackey@twitter.com>
To: Doug Thompson <dougthompson@xmission.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: trivial@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Mackey <tdmackey@twitter.com>,
        Vinson Lee <vlee@twitter.com>
Subject: [PATCH] edac: Fix spelling errors.
Date: Tue, 17 Apr 2012 11:30:52 -0700
Message-Id: <1334687452-10178-1-git-send-email-tdmackey@twitter.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Mackey <tdmackey@twitter.com>
Signed-off-by: Vinson Lee <vlee@twitter.com>
---
 drivers/edac/edac_core.h   |    6 +++---
 drivers/edac/edac_device.c |   10 +++++-----
 drivers/edac/i7core_edac.c |   10 +++++-----
 drivers/edac/sb_edac.c     |    6 +++---
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index e48ab31..841bb2d 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -107,13 +107,13 @@ extern int edac_debug_level;
  *
  * CPU caches (L1 and L2)
  * DMA engines
- * Core CPU swithces
+ * Core CPU switches
  * Fabric switch units
  * PCIe interface controllers
  * other EDAC/ECC type devices that can be monitored for
  * errors, etc.
  *
- * It allows for a 2 level set of hiearchry. For example:
+ * It allows for a 2 level set of hierarchy. For example:
  *
  * cache could be composed of L1, L2 and L3 levels of cache.
  * Each CPU core would have its own L1 cache, while sharing
@@ -460,7 +460,7 @@ extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
 /*
  * The no info errors are used when error overflows are reported.
  * There are a limited number of error logging registers that can
- * be exausted.  When all registers are exhausted and an additional
+ * be exhausted.  When all registers are exhausted and an additional
  * error occurs then an error overflow register records that an
  * error occurred and the type of error, but doesn't have any
  * further information.  The ce/ue versions make for cleaner
diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index 4b15459..da4a1f1 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -56,7 +56,7 @@ static void edac_device_dump_device(struct edac_device_ctl_info *edac_dev)
  *
  *	The control structure is allocated in complete chunk
  *	from the OS. It is in turn sub allocated to the
- *	various objects that compose the struture
+ *	various objects that compose the structure
  *
  *	The structure has a 'nr_instance' array within itself.
  *	Each instance represents a major component
@@ -118,7 +118,7 @@ struct edac_device_ctl_info *edac_device_alloc_ctl_info(
 		/* Calc the 'end' offset past the attributes array */
 		pvt = edac_align_ptr(&dev_attrib[count], sz_private);
 	} else {
-		/* no attribute array specificed */
+		/* no attribute array specified */
 		pvt = edac_align_ptr(dev_attrib, sz_private);
 	}
 
@@ -367,7 +367,7 @@ static void del_edac_device_from_global_list(struct edac_device_ctl_info
  *	structure, that needs to be polled for possible error events.
  *
  *	This operation is to acquire the list mutex lock
- *	(thus preventing insertation or deletion)
+ *	(thus preventing insertion or deletion)
  *	and then call the device's poll function IFF this device is
  *	running polled and there is a poll function defined.
  */
@@ -394,7 +394,7 @@ static void edac_device_workq_function(struct work_struct *work_req)
 
 	/* Reschedule the workq for the next time period to start again
 	 * if the number of msec is for 1 sec, then adjust to the next
-	 * whole one second to save timers fireing all over the period
+	 * whole one second to save timers firing all over the period
 	 * between integral seconds
 	 */
 	if (edac_dev->poll_msec == 1000)
@@ -563,7 +563,7 @@ EXPORT_SYMBOL_GPL(edac_device_add_device);
  *	Remove sysfs entries for specified edac_device structure and
  *	then remove edac_device structure from global list
  *
- * @pdev:
+ * @dev:
  *	Pointer to 'struct device' representing edac_device
  *	structure to remove.
  *
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 85226cc..7f1dfcc 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -90,7 +90,7 @@ MODULE_PARM_DESC(use_pci_fixup, "Enable PCI fixup to seek for hidden devices");
 #define MC_MAX_DOD	0x64
 
 /*
- * OFFSETS for Device 3 Function 4, as inicated on Xeon 5500 datasheet:
+ * OFFSETS for Device 3 Function 4, as indicated on Xeon 5500 datasheet:
  * http://www.arrownac.com/manufacturers/intel/s/nehalem/5500-datasheet-v2.pdf
  */
 
@@ -101,7 +101,7 @@ MODULE_PARM_DESC(use_pci_fixup, "Enable PCI fixup to seek for hidden devices");
   #define DIMM1_COR_ERR(r)			(((r) >> 16) & 0x7fff)
   #define DIMM0_COR_ERR(r)			((r) & 0x7fff)
 
-/* OFFSETS for Device 3 Function 2, as inicated on Xeon 5500 datasheet */
+/* OFFSETS for Device 3 Function 2, as indicated on Xeon 5500 datasheet */
 #define MC_SSRCONTROL		0x48
   #define SSR_MODE_DISABLE	0x00
   #define SSR_MODE_ENABLE	0x01
@@ -398,7 +398,7 @@ static DEFINE_PCI_DEVICE_TABLE(i7core_pci_tbl) = {
 };
 
 /****************************************************************************
-			Anciliary status routines
+			Ancillary status routines
  ****************************************************************************/
 
 	/* MC_CONTROL bits */
@@ -1361,7 +1361,7 @@ static int i7core_get_onedevice(struct pci_dev **prev,
 			      dev_descr->dev_id, *prev);
 
 	/*
-	 * On Xeon 55xx, the Intel Quckpath Arch Generic Non-core regs
+	 * On Xeon 55xx, the Intel QuickPath Arch Generic Non-core regs
 	 * is at addr 8086:2c40, instead of 8086:2c41. So, we need
 	 * to probe for the alternate address in case of failure
 	 */
@@ -2132,7 +2132,7 @@ static int set_sdram_scrub_rate(struct mem_ctl_info *mci, u32 new_bw)
 
 /*
  * get_sdram_scrub_rate		This routine convert current scrub rate value
- *				into byte/sec bandwidth accourding to
+ *				into byte/sec bandwidth according to
  *				SCRUBINTERVAL formula found in datasheet.
  */
 static int get_sdram_scrub_rate(struct mem_ctl_info *mci)
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index a203536..123204f 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -58,7 +58,7 @@ static int probed;
 
 /*
  * FIXME: For now, let's order by device function, as it makes
- * easier for driver's development proccess. This table should be
+ * easier for driver's development process. This table should be
  * moved to pci_id.h when submitted upstream
  */
 #define PCI_DEVICE_ID_INTEL_SBRIDGE_SAD0	0x3cf4	/* 12.6 */
@@ -375,7 +375,7 @@ static DEFINE_PCI_DEVICE_TABLE(sbridge_pci_tbl) = {
 
 
 /****************************************************************************
-			Anciliary status routines
+			Ancillary status routines
  ****************************************************************************/
 
 static inline int numrank(u32 mtr)
@@ -1430,7 +1430,7 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 		type = "FATAL";
 
 	/*
-	 * According with Table 15-9 of the Intel Archictecture spec vol 3A,
+	 * According with Table 15-9 of the Intel Architecture spec vol 3A,
 	 * memory errors should fit in this mask:
 	 *	000f 0000 1mmm cccc (binary)
 	 * where:
-- 
1.7.7.6

