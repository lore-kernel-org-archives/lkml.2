Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab0IANwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 09:52:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34097 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab0IANsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:48:47 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/15] trivial: fix typos concerning "memory"
Date: Wed,  1 Sep 2010 15:48:33 +0200
Message-Id: <1283348918-7204-10-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283348918-7204-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1283348918-7204-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/arm/mach-u300/Kconfig                  |    2 +-
 arch/arm/mach-u300/include/mach/coh901318.h |    2 +-
 arch/mips/mti-malta/malta-memory.c          |    2 +-
 arch/mips/powertv/memory.c                  |    2 +-
 drivers/edac/edac_core.h                    |    2 +-
 drivers/media/video/omap/omap_vout.c        |    2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c            |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c                |    2 +-
 drivers/usb/musb/musb_gadget.c              |    2 +-
 kernel/power/swap.c                         |    2 +-
 mm/sparse-vmemmap.c                         |    2 +-
 11 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-u300/Kconfig b/arch/arm/mach-u300/Kconfig
index 801b21e..32a7b0f 100644
--- a/arch/arm/mach-u300/Kconfig
+++ b/arch/arm/mach-u300/Kconfig
@@ -64,7 +64,7 @@ config MACH_U300_DUAL_RAM
 	bool "Dual RAM"
 	help
 		Select this if you want support for Dual RAM phones.
-		This is two RAM memorys on different EMIFs.
+		This is two RAM memories on different EMIFs.
 endchoice
 
 config U300_DEBUG
diff --git a/arch/arm/mach-u300/include/mach/coh901318.h b/arch/arm/mach-u300/include/mach/coh901318.h
index 2013d2b..6193aaa 100644
--- a/arch/arm/mach-u300/include/mach/coh901318.h
+++ b/arch/arm/mach-u300/include/mach/coh901318.h
@@ -90,7 +90,7 @@ struct powersave {
  * struct coh901318_platform - platform arch structure
  * @chans_slave: specifying dma slave channels
  * @chans_memcpy: specifying dma memcpy channels
- * @access_memory_state: requesting DMA memeory access (on / off)
+ * @access_memory_state: requesting DMA memory access (on / off)
  * @chan_conf: dma channel configurations
  * @max_channels: max number of dma chanenls
  */
diff --git a/arch/mips/mti-malta/malta-memory.c b/arch/mips/mti-malta/malta-memory.c
index b27419c..a96d281 100644
--- a/arch/mips/mti-malta/malta-memory.c
+++ b/arch/mips/mti-malta/malta-memory.c
@@ -43,7 +43,7 @@ static struct prom_pmemblock mdesc[PROM_MAX_PMEMBLOCKS];
 static char *mtypes[3] = {
 	"Dont use memory",
 	"YAMON PROM memory",
-	"Free memmory",
+	"Free memory",
 };
 #endif
 
diff --git a/arch/mips/powertv/memory.c b/arch/mips/powertv/memory.c
index 73880ad..fb3d296 100644
--- a/arch/mips/powertv/memory.c
+++ b/arch/mips/powertv/memory.c
@@ -57,7 +57,7 @@
 unsigned long ptv_memsize;
 
 /*
- * struct low_mem_reserved - Items in low memmory that are reserved
+ * struct low_mem_reserved - Items in low memory that are reserved
  * @start:	Physical address of item
  * @size:	Size, in bytes, of this item
  * @is_aliased:	True if this is RAM aliased from another location. If false,
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index ce71466..89e2cf9 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -256,7 +256,7 @@ enum scrub_type {
  *			for single channel are 64 bits, for dual channel 128
  *			bits.
  *
- * Single-Ranked stick:	A Single-ranked stick has 1 chip-select row of memmory.
+ * Single-Ranked stick:	A Single-ranked stick has 1 chip-select row of memory.
  *			Motherboards commonly drive two chip-select pins to
  *			a memory stick. A single-ranked stick, will occupy
  *			only one of those rows. The other will be unused.
diff --git a/drivers/media/video/omap/omap_vout.c b/drivers/media/video/omap/omap_vout.c
index 4ed51b1..98268d6 100644
--- a/drivers/media/video/omap/omap_vout.c
+++ b/drivers/media/video/omap/omap_vout.c
@@ -1286,7 +1286,7 @@ static int omap_vout_release(struct file *file)
 	videobuf_mmap_free(q);
 
 	/* Even if apply changes fails we should continue
-	   freeing allocated memeory */
+	   freeing allocated memory */
 	if (vout->streaming) {
 		u32 mask = 0;
 
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 1f62ea8..6907f98 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -2616,7 +2616,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, READ_LA_VAR *la)
 			if (unlikely(!fcf_record)) {
 				lpfc_printf_log(phba, KERN_ERR,
 					LOG_MBOX | LOG_SLI,
-					"2554 Could not allocate memmory for "
+					"2554 Could not allocate memory for "
 					"fcf record\n");
 				rc = -ENODEV;
 				goto out;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index fb8905f..7096fd2 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -9620,7 +9620,7 @@ lpfc_sli4_intr_handler(int irq, void *dev_id)
  * lpfc_sli4_queue_free - free a queue structure and associated memory
  * @queue: The queue structure to free.
  *
- * This function frees a queue structure and the DMAable memeory used for
+ * This function frees a queue structure and the DMAable memory used for
  * the host resident queue. This function must be called after destroying the
  * queue on the HBA.
  **/
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index cb21dc1..cb7635e 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1693,7 +1693,7 @@ void musb_gadget_cleanup(struct musb *musb)
  *
  * -EINVAL something went wrong (not driver)
  * -EBUSY another gadget is already using the controller
- * -ENOMEM no memeory to perform the operation
+ * -ENOMEM no memory to perform the operation
  *
  * @param driver the gadget driver
  * @return <0 if error, 0 if everything is fine
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 5d0059e..7a8dc5b 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -592,7 +592,7 @@ static int load_image(struct swap_map_handle *handle,
 /**
  *	swsusp_read - read the hibernation image.
  *	@flags_p: flags passed by the "frozen" kernel in the image header should
- *		  be written into this memeory location
+ *		  be written into this memory location
  */
 
 int swsusp_read(unsigned int *flags_p)
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index aa33fd6..27f2cf2 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -9,7 +9,7 @@
  *
  * However, virtual mappings need a page table and TLBs. Many Linux
  * architectures already map their physical space using 1-1 mappings
- * via TLBs. For those arches the virtual memmory map is essentially
+ * via TLBs. For those arches the virtual memory map is essentially
  * for free if we use the same page size as the 1-1 mappings. In that
  * case the overhead consists of a few additional pages that are
  * allocated to create a view of memory for vmemmap.
-- 
1.7.1

