Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885Ab1CaSJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:09:17 -0400
Received: from santostefano.inria.fr ([193.51.192.151]:37581 "HELO
	santostefano.inria.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758867Ab1CaSJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:09:08 -0400
Subject: [PATCH 1/2] Fix a typo (informations => information)
From: Sylvestre Ledru <sylvestre.ledru@scilab.org>
To: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sylvestre Ledru <sylvestre.ledru@scilab.org>
Content-Type: multipart/mixed; boundary="=-S3LjurGudUxFb/IACCaR"
Date: Thu, 31 Mar 2011 20:09:02 +0200
Message-ID: <1301594942.27408.13.camel@losinj.inria.fr>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-S3LjurGudUxFb/IACCaR
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

Hello,

Here is a patch which fixes minor typo issues.

Thanks
Sylvestre 


--=-S3LjurGudUxFb/IACCaR
Content-Disposition: attachment; filename="0001-Fix-a-typo-informations-information.patch"
Content-Type: text/x-patch; name="0001-Fix-a-typo-informations-information.patch"; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

>From 657500d0dd37ef93351addd2c74a23ed9e7e132b Mon Sep 17 00:00:00 2001
From: Sylvestre Ledru <sylvestre.ledru@scilab.org>
Date: Thu, 31 Mar 2011 18:02:10 +0200
Subject: [PATCH 1/2] Fix a typo (informations => information)

Signed-off-by: Sylvestre Ledru <sylvestre.ledru@scilab.org>
---
 Documentation/scsi/ChangeLog.sym53c8xx             |    2 +-
 Documentation/video4linux/README.cx88              |    2 +-
 Documentation/video4linux/bttv/Sound-FAQ           |    2 +-
 arch/alpha/mm/init.c                               |    2 +-
 arch/microblaze/kernel/prom.c                      |    2 +-
 arch/microblaze/pci/pci-common.c                   |    2 +-
 arch/mips/kernel/prom.c                            |    2 +-
 arch/powerpc/include/asm/bootx.h                   |    2 +-
 arch/powerpc/include/asm/smu.h                     |    8 ++++----
 arch/powerpc/kernel/pci-common.c                   |    2 +-
 arch/powerpc/kernel/prom.c                         |    4 ++--
 arch/powerpc/kernel/rtas.c                         |    2 +-
 arch/powerpc/kernel/setup_64.c                     |    4 ++--
 arch/powerpc/mm/hugetlbpage-hash64.c               |    2 +-
 arch/powerpc/platforms/cell/spider-pic.c           |    2 +-
 drivers/char/generic_nvram.c                       |    2 +-
 drivers/gpu/drm/radeon/evergreen.c                 |    2 +-
 drivers/gpu/drm/radeon/evergreen_cs.c              |    4 ++--
 drivers/gpu/drm/radeon/r100.c                      |    8 ++++----
 drivers/gpu/drm/radeon/r600.c                      |    6 +++---
 drivers/gpu/drm/radeon/r600_cs.c                   |    6 +++---
 drivers/gpu/drm/radeon/radeon_device.c             |    8 ++++----
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c        |    2 +-
 drivers/gpu/drm/radeon/rs690.c                     |    2 +-
 drivers/gpu/drm/radeon/rv770.c                     |    2 +-
 drivers/hid/hid-roccat-kone.c                      |    2 +-
 drivers/isdn/capi/capiutil.c                       |    2 +-
 drivers/isdn/hardware/eicon/message.c              |    2 +-
 drivers/isdn/hardware/mISDN/avmfritz.c             |    2 +-
 drivers/isdn/hardware/mISDN/mISDNinfineon.c        |    2 +-
 drivers/isdn/hardware/mISDN/speedfax.c             |    2 +-
 drivers/isdn/hisax/sedlbauer.c                     |    2 +-
 drivers/macintosh/therm_pm72.c                     |    2 +-
 drivers/media/common/saa7146_video.c               |    6 +++---
 drivers/media/video/bt8xx/bttv-cards.c             |    2 +-
 drivers/media/video/bt8xx/bttv-driver.c            |    2 +-
 drivers/media/video/et61x251/et61x251_core.c       |    2 +-
 drivers/media/video/mxb.c                          |    4 ++--
 drivers/media/video/pwc/pwc-dec23.c                |    2 +-
 drivers/media/video/pwc/pwc.h                      |    2 +-
 drivers/media/video/sn9c102/sn9c102_core.c         |    2 +-
 drivers/media/video/tda9840.c                      |    2 +-
 drivers/media/video/tea6415c.c                     |    2 +-
 drivers/media/video/tea6420.c                      |    2 +-
 drivers/media/video/tvp514x.c                      |    2 +-
 drivers/mtd/nand/fsmc_nand.c                       |    4 ++--
 drivers/net/ps3_gelic_wireless.c                   |    2 +-
 drivers/net/tlan.c                                 |    2 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |    4 ++--
 drivers/net/wireless/rt2x00/rt61pci.c              |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |    4 ++--
 drivers/platform/x86/Kconfig                       |    4 ++--
 drivers/scsi/gdth.c                                |    4 ++--
 drivers/scsi/gdth.h                                |    2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |    2 +-
 drivers/scsi/ncr53c8xx.c                           |    2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c                |    2 +-
 drivers/scsi/sym53c8xx_2/sym_hipd.c                |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |   18 +++++++++---------
 drivers/staging/comedi/drivers/adv_pci1710.c       |    2 +-
 drivers/staging/et131x/et131x_adapter.h            |    2 +-
 drivers/staging/rt2860/common/mlme.c               |    2 +-
 drivers/staging/rtl8192e/r819xE_cmdpkt.c           |    2 +-
 drivers/staging/rtl8192e/r819xE_cmdpkt.h           |    2 +-
 drivers/staging/rtl8192u/r819xU_cmdpkt.c           |    2 +-
 drivers/staging/rtl8192u/r819xU_cmdpkt.h           |    2 +-
 drivers/staging/vt6655/bssdb.h                     |    4 ++--
 drivers/staging/vt6655/wmgr.c                      |    2 +-
 drivers/staging/vt6655/wpa.h                       |    2 +-
 drivers/staging/vt6655/wpa2.h                      |    2 +-
 drivers/staging/vt6656/bssdb.h                     |    4 ++--
 drivers/staging/vt6656/wmgr.c                      |    2 +-
 drivers/staging/vt6656/wpa.h                       |    2 +-
 drivers/staging/vt6656/wpa2.h                      |    2 +-
 drivers/video/aty/aty128fb.c                       |    2 +-
 drivers/video/aty/radeon_base.c                    |    4 ++--
 drivers/video/aty/radeon_monitor.c                 |    4 ++--
 fs/fat/dir.c                                       |    4 ++--
 fs/jffs2/xattr.c                                   |    4 ++--
 include/linux/hdlcdrv.h                            |    2 +-
 include/media/saa7146.h                            |    2 +-
 include/media/saa7146_vv.h                         |    4 ++--
 include/sound/emux_legacy.h                        |    2 +-
 sound/core/seq/oss/seq_oss_init.c                  |    2 +-
 sound/oss/aedsp16.c                                |    2 +-
 sound/pci/aw2/aw2-saa7146.c                        |    4 ++--
 sound/pci/echoaudio/echoaudio.c                    |    2 +-
 sound/pci/rme32.c                                  |    2 +-
 sound/pci/rme9652/hdsp.c                           |    2 +-
 sound/ppc/tumbler.c                                |    2 +-
 90 files changed, 130 insertions(+), 130 deletions(-)

diff --git a/Documentation/scsi/ChangeLog.sym53c8xx b/Documentation/scsi/ChangeLog.sym53c8xx
index 02ffbc1..d90ffa5 100644
--- a/Documentation/scsi/ChangeLog.sym53c8xx
+++ b/Documentation/scsi/ChangeLog.sym53c8xx
@@ -432,7 +432,7 @@ Sun Jan 31  18:00 1999 Gerard Roudier (groudier@club-internet.fr)
 Sun Jan 24  18:00 1999 Gerard Roudier (groudier@club-internet.fr)
 	* version sym53c8xx-1.1
 	- Major rewrite of the SCSI parity error handling.
-	  The informations contained in the data manuals are incomplete about 
+	  The information contained in the data manuals are incomplete about 
 	  this feature.
 	  I asked SYMBIOS about and got in reply the explanations that are 
 	  _indeed_ missing in the data manuals.
diff --git a/Documentation/video4linux/README.cx88 b/Documentation/video4linux/README.cx88
index 35fae23..b09ce36 100644
--- a/Documentation/video4linux/README.cx88
+++ b/Documentation/video4linux/README.cx88
@@ -50,7 +50,7 @@ the driver.  What to do then?
      cx88-cards.c.  If that worked, mail me your changes as unified
      diff ("diff -u").
  (3) Or you can mail me the config information.  I need at least the
-     following informations to add the card:
+     following information to add the card:
 
      * the PCI Subsystem ID ("0070:3400" from the line above,
        "lspci -v" output is fine too).
diff --git a/Documentation/video4linux/bttv/Sound-FAQ b/Documentation/video4linux/bttv/Sound-FAQ
index bc5e41d..d0daafb 100644
--- a/Documentation/video4linux/bttv/Sound-FAQ
+++ b/Documentation/video4linux/bttv/Sound-FAQ
@@ -55,7 +55,7 @@ receiver chips.  Some boards use the i2c bus instead of the gpio pins
 to connect the mux chip.
 
 As mentioned above, there is a array which holds the required
-informations for each known board.  You basically have to create a new
+information for each known board.  You basically have to create a new
 line for your board.  The important fields are these two:
 
 struct tvcard
diff --git a/arch/alpha/mm/init.c b/arch/alpha/mm/init.c
index 86425ab..e1713fc 100644
--- a/arch/alpha/mm/init.c
+++ b/arch/alpha/mm/init.c
@@ -286,7 +286,7 @@ printk_memory_info(void)
 	extern char _text, _etext, _data, _edata;
 	extern char __init_begin, __init_end;
 
-	/* printk all informations */
+	/* printk all information */
 	reservedpages = 0;
 	for (tmp = 0; tmp < max_low_pfn; tmp++)
 		/*
diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index 00ee90f..5673c03 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -126,7 +126,7 @@ void __init early_init_devtree(void *params)
 	/* Setup flat device-tree pointer */
 	initial_boot_params = params;
 
-	/* Retrieve various informations from the /chosen node of the
+	/* Retrieve various information from the /chosen node of the
 	 * device-tree, including the platform type, initrd location and
 	 * size, TCE reserve, and more ...
 	 */
diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 5359906..c5b1039 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -200,7 +200,7 @@ int pci_read_irq_line(struct pci_dev *pci_dev)
 	unsigned int virq;
 
 	/* The current device-tree that iSeries generates from the HV
-	 * PCI informations doesn't contain proper interrupt routing,
+	 * PCI information doesn't contain proper interrupt routing,
 	 * and all the fallback would do is print out crap, so we
 	 * don't attempt to resolve the interrupts here at all, some
 	 * iSeries specific fixup does it.
diff --git a/arch/mips/kernel/prom.c b/arch/mips/kernel/prom.c
index a19811e9..0b02087 100644
--- a/arch/mips/kernel/prom.c
+++ b/arch/mips/kernel/prom.c
@@ -79,7 +79,7 @@ void __init early_init_devtree(void *params)
 	/* Setup flat device-tree pointer */
 	initial_boot_params = params;
 
-	/* Retrieve various informations from the /chosen node of the
+	/* Retrieve various information from the /chosen node of the
 	 * device-tree, including the platform type, initrd location and
 	 * size, and more ...
 	 */
diff --git a/arch/powerpc/include/asm/bootx.h b/arch/powerpc/include/asm/bootx.h
index 60a3c9e..b8246a4 100644
--- a/arch/powerpc/include/asm/bootx.h
+++ b/arch/powerpc/include/asm/bootx.h
@@ -59,7 +59,7 @@ typedef struct boot_info_map_entry
 } boot_info_map_entry_t;
 
 
-/* Here are the boot informations that are passed to the bootstrap
+/* Here are the boot information that are passed to the bootstrap
  * Note that the kernel arguments and the device tree are appended
  * at the end of this structure. */
 typedef struct boot_infos
diff --git a/arch/powerpc/include/asm/smu.h b/arch/powerpc/include/asm/smu.h
index e3bdada..59c5954 100644
--- a/arch/powerpc/include/asm/smu.h
+++ b/arch/powerpc/include/asm/smu.h
@@ -527,7 +527,7 @@ extern int smu_queue_i2c(struct smu_i2c_cmd *cmd);
 
 
 /*
- * - SMU "sdb" partitions informations -
+ * - SMU "sdb" partitions information -
  */
 
 
@@ -575,7 +575,7 @@ struct smu_sdbp_fvt {
 };
 
 /* This partition contains voltage & current sensor calibration
- * informations
+ * information
  */
 #define SMU_SDB_CPUVCP_ID		0x21
 
@@ -616,9 +616,9 @@ struct smu_sdbp_sensortree {
 	__u8	unknown[3];
 };
 
-/* This partition contains CPU thermal control PID informations. So far
+/* This partition contains CPU thermal control PID information. So far
  * only single CPU machines have been seen with an SMU, so we assume this
- * carries only informations for those
+ * carries only information for those
  */
 #define SMU_SDB_CPUPIDDATA_ID		0x17
 
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 893af2a..85e1db2 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -219,7 +219,7 @@ int pci_read_irq_line(struct pci_dev *pci_dev)
 	unsigned int virq;
 
 	/* The current device-tree that iSeries generates from the HV
-	 * PCI informations doesn't contain proper interrupt routing,
+	 * PCI information doesn't contain proper interrupt routing,
 	 * and all the fallback would do is print out crap, so we
 	 * don't attempt to resolve the interrupts here at all, some
 	 * iSeries specific fixup does it.
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 05b7139..29bac47 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -687,7 +687,7 @@ void __init early_init_devtree(void *params)
 	of_scan_flat_dt(early_init_dt_scan_phyp_dump, NULL);
 #endif
 
-	/* Retrieve various informations from the /chosen node of the
+	/* Retrieve various information from the /chosen node of the
 	 * device-tree, including the platform type, initrd location and
 	 * size, TCE reserve, and more ...
 	 */
@@ -739,7 +739,7 @@ void __init early_init_devtree(void *params)
 
 	DBG("Scanning CPUs ...\n");
 
-	/* Retreive CPU related informations from the flat tree
+	/* Retreive CPU related information from the flat tree
 	 * (altivec support, boot CPU ID, ...)
 	 */
 	of_scan_flat_dt(early_init_dt_scan_cpus, NULL);
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 2097f2b..a8ac1a2 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -936,7 +936,7 @@ asmlinkage int ppc_rtas(struct rtas_args __user *uargs)
 
 /*
  * Call early during boot, before mem init or bootmem, to retrieve the RTAS
- * informations from the device-tree and allocate the RMO buffer for userland
+ * information from the device-tree and allocate the RMO buffer for userland
  * accesses.
  */
 void __init rtas_initialize(void)
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 5a0401f..fc7d722 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -255,7 +255,7 @@ void smp_release_cpus(void)
  * Initialize some remaining members of the ppc64_caches and systemcfg
  * structures
  * (at least until we get rid of them completely). This is mostly some
- * cache informations about the CPU that will be used by cache flush
+ * cache information about the CPU that will be used by cache flush
  * routines and/or provided to userland
  */
 static void __init initialize_cache_info(void)
@@ -347,7 +347,7 @@ void __init setup_system(void)
 	unflatten_device_tree();
 
 	/*
-	 * Fill the ppc64_caches & systemcfg structures with informations
+	 * Fill the ppc64_caches & systemcfg structures with information
  	 * retrieved from the device-tree.
 	 */
 	initialize_cache_info();
diff --git a/arch/powerpc/mm/hugetlbpage-hash64.c b/arch/powerpc/mm/hugetlbpage-hash64.c
index cc5c273..d0fdd99 100644
--- a/arch/powerpc/mm/hugetlbpage-hash64.c
+++ b/arch/powerpc/mm/hugetlbpage-hash64.c
@@ -90,7 +90,7 @@ repeat:
 		hpte_group = ((hash & htab_hash_mask) *
 			      HPTES_PER_GROUP) & ~0x7UL;
 
-		/* clear HPTE slot informations in new PTE */
+		/* clear HPTE slot information in new PTE */
 #ifdef CONFIG_PPC_64K_PAGES
 		new_pte = (new_pte & ~_PAGE_HPTEFLAGS) | _PAGE_HPTE_SUB0;
 #else
diff --git a/arch/powerpc/platforms/cell/spider-pic.c b/arch/powerpc/platforms/cell/spider-pic.c
index c5cf50e..4fead42 100644
--- a/arch/powerpc/platforms/cell/spider-pic.c
+++ b/arch/powerpc/platforms/cell/spider-pic.c
@@ -219,7 +219,7 @@ static void spider_irq_cascade(unsigned int irq, struct irq_desc *desc)
 /* For hooking up the cascace we have a problem. Our device-tree is
  * crap and we don't know on which BE iic interrupt we are hooked on at
  * least not the "standard" way. We can reconstitute it based on two
- * informations though: which BE node we are connected to and wether
+ * information though: which BE node we are connected to and wether
  * we are connected to IOIF0 or IOIF1. Right now, we really only care
  * about the IBM cell blade and we know that its firmware gives us an
  * interrupt-map property which is pretty strange.
diff --git a/drivers/char/generic_nvram.c b/drivers/char/generic_nvram.c
index 0e941b5..af5b009 100644
--- a/drivers/char/generic_nvram.c
+++ b/drivers/char/generic_nvram.c
@@ -5,7 +5,7 @@
  * nvram_read_byte, nvram_write_byte, nvram_sync, nvram_get_size
  *
  * Note that an additional hook is supported for PowerMac only
- * for getting the nvram "partition" informations
+ * for getting the nvram "partition" information
  *
  */
 
diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 941080a..ffdb6dd 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -2153,7 +2153,7 @@ int evergreen_mc_init(struct radeon_device *rdev)
 	u32 tmp;
 	int chansize, numchan;
 
-	/* Get VRAM informations */
+	/* Get VRAM information */
 	rdev->mc.vram_is_ddr = true;
 	tmp = RREG32(MC_ARB_RAMCFG);
 	if (tmp & CHANSIZE_OVERRIDE) {
diff --git a/drivers/gpu/drm/radeon/evergreen_cs.c b/drivers/gpu/drm/radeon/evergreen_cs.c
index edde90b..35474d8 100644
--- a/drivers/gpu/drm/radeon/evergreen_cs.c
+++ b/drivers/gpu/drm/radeon/evergreen_cs.c
@@ -145,7 +145,7 @@ static int evergreen_cs_track_check(struct radeon_cs_parser *p)
 /**
  * evergreen_cs_packet_parse() - parse cp packet and point ib index to next packet
  * @parser:	parser structure holding parsing context.
- * @pkt:	where to store packet informations
+ * @pkt:	where to store packet information
  *
  * Assume that chunk_ib_index is properly set. Will return -EINVAL
  * if packet is bigger than remaining ib size. or if packets is unknown.
@@ -195,7 +195,7 @@ int evergreen_cs_packet_parse(struct radeon_cs_parser *p,
  * @data:		pointer to relocation data
  * @offset_start:	starting offset
  * @offset_mask:	offset mask (to align start offset on)
- * @reloc:		reloc informations
+ * @reloc:		reloc information
  *
  * Check next packet is relocation packet3, do bo validation and compute
  * GPU offset using the provided start.
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index f2204cb..19563ff 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -1125,7 +1125,7 @@ void r100_cs_dump_packet(struct radeon_cs_parser *p,
 /**
  * r100_cs_packet_parse() - parse cp packet and point ib index to next packet
  * @parser:	parser structure holding parsing context.
- * @pkt:	where to store packet informations
+ * @pkt:	where to store packet information
  *
  * Assume that chunk_ib_index is properly set. Will return -EINVAL
  * if packet is bigger than remaining ib size. or if packets is unknown.
@@ -1265,7 +1265,7 @@ int r100_cs_packet_parse_vline(struct radeon_cs_parser *p)
  * @data:		pointer to relocation data
  * @offset_start:	starting offset
  * @offset_mask:	offset mask (to align start offset on)
- * @reloc:		reloc informations
+ * @reloc:		reloc information
  *
  * Check next packet is relocation packet3, do bo validation and compute
  * GPU offset using the provided start.
@@ -1996,12 +1996,12 @@ void r100_gpu_lockup_update(struct r100_gpu_lockup *lockup, struct radeon_cp *cp
 /**
  * r100_gpu_cp_is_lockup() - check if CP is lockup by recording information
  * @rdev:	radeon device structure
- * @lockup:	r100_gpu_lockup structure holding CP lockup tracking informations
+ * @lockup:	r100_gpu_lockup structure holding CP lockup tracking information
  * @cp:		radeon_cp structure holding CP information
  *
  * We don't need to initialize the lockup tracking information as we will either
  * have CP rptr to a different value of jiffies wrap around which will force
- * initialization of the lockup tracking informations.
+ * initialization of the lockup tracking information.
  *
  * A possible false positivie is if we get call after while and last_cp_rptr ==
  * the current CP rptr, even if it's unlikely it might happen. To avoid this
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index be271c4..10e9258 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -1154,8 +1154,8 @@ static void r600_mc_program(struct radeon_device *rdev)
 
 /**
  * r600_vram_gtt_location - try to find VRAM & GTT location
- * @rdev: radeon device structure holding all necessary informations
- * @mc: memory controller structure holding memory informations
+ * @rdev: radeon device structure holding all necessary information
+ * @mc: memory controller structure holding memory information
  *
  * Function will place try to place VRAM at same place as in CPU (PCI)
  * address space as some GPU seems to have issue when we reprogram at
@@ -1222,7 +1222,7 @@ int r600_mc_init(struct radeon_device *rdev)
 	u32 tmp;
 	int chansize, numchan;
 
-	/* Get VRAM informations */
+	/* Get VRAM information */
 	rdev->mc.vram_is_ddr = true;
 	tmp = RREG32(RAMCFG);
 	if (tmp & CHANSIZE_OVERRIDE) {
diff --git a/drivers/gpu/drm/radeon/r600_cs.c b/drivers/gpu/drm/radeon/r600_cs.c
index 3324620..cf4062b 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -585,7 +585,7 @@ static int r600_cs_track_check(struct radeon_cs_parser *p)
 /**
  * r600_cs_packet_parse() - parse cp packet and point ib index to next packet
  * @parser:	parser structure holding parsing context.
- * @pkt:	where to store packet informations
+ * @pkt:	where to store packet information
  *
  * Assume that chunk_ib_index is properly set. Will return -EINVAL
  * if packet is bigger than remaining ib size. or if packets is unknown.
@@ -635,7 +635,7 @@ int r600_cs_packet_parse(struct radeon_cs_parser *p,
  * @data:		pointer to relocation data
  * @offset_start:	starting offset
  * @offset_mask:	offset mask (to align start offset on)
- * @reloc:		reloc informations
+ * @reloc:		reloc information
  *
  * Check next packet is relocation packet3, do bo validation and compute
  * GPU offset using the provided start.
@@ -681,7 +681,7 @@ static int r600_cs_packet_next_reloc_mm(struct radeon_cs_parser *p,
  * @data:		pointer to relocation data
  * @offset_start:	starting offset
  * @offset_mask:	offset mask (to align start offset on)
- * @reloc:		reloc informations
+ * @reloc:		reloc information
  *
  * Check next packet is relocation packet3, do bo validation and compute
  * GPU offset using the provided start.
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index f0209be..f6845ef 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -242,8 +242,8 @@ int radeon_wb_init(struct radeon_device *rdev)
 
 /**
  * radeon_vram_location - try to find VRAM location
- * @rdev: radeon device structure holding all necessary informations
- * @mc: memory controller structure holding memory informations
+ * @rdev: radeon device structure holding all necessary information
+ * @mc: memory controller structure holding memory information
  * @base: base address at which to put VRAM
  *
  * Function will place try to place VRAM at base address provided
@@ -303,8 +303,8 @@ void radeon_vram_location(struct radeon_device *rdev, struct radeon_mc *mc, u64
 
 /**
  * radeon_gtt_location - try to find GTT location
- * @rdev: radeon device structure holding all necessary informations
- * @mc: memory controller structure holding memory informations
+ * @rdev: radeon device structure holding all necessary information
+ * @mc: memory controller structure holding memory information
  *
  * Function will place try to place GTT before or after VRAM.
  *
diff --git a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
index 41a5d48..df04a08 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -413,7 +413,7 @@ int radeon_crtc_do_set_base(struct drm_crtc *crtc,
 		return false;
 	}
 
-	/* Pin framebuffer & get tilling informations */
+	/* Pin framebuffer & get tilling information */
 	obj = radeon_fb->obj;
 	rbo = gem_to_radeon_bo(obj);
 	r = radeon_bo_reserve(rbo, false);
diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index a9049ed..8c4fb53 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -73,7 +73,7 @@ void rs690_pm_info(struct radeon_device *rdev)
 				   &frev, &crev, &data_offset)) {
 		info = (union igp_info *)(rdev->mode_info.atom_context->bios + data_offset);
 
-		/* Get various system informations from bios */
+		/* Get various system information from bios */
 		switch (crev) {
 		case 1:
 			tmp.full = dfixed_const(100);
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index b974ac7..cb7cb93 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -1089,7 +1089,7 @@ int rv770_mc_init(struct radeon_device *rdev)
 	u32 tmp;
 	int chansize, numchan;
 
-	/* Get VRAM informations */
+	/* Get VRAM information */
 	rdev->mc.vram_is_ddr = true;
 	tmp = RREG32(MC_ARB_RAMCFG);
 	if (tmp & CHANSIZE_OVERRIDE) {
diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index a57838d..937d87e 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -778,7 +778,7 @@ static void kone_report_to_chrdev(struct kone_device const *kone,
 
 /*
  * Is called for keyboard- and mousepart.
- * Only mousepart gets informations about special events in its extended event
+ * Only mousepart gets information about special events in its extended event
  * structure.
  */
 static int kone_raw_event(struct hid_device *hdev, struct hid_report *report,
diff --git a/drivers/isdn/capi/capiutil.c b/drivers/isdn/capi/capiutil.c
index 03c469e..18342b2 100644
--- a/drivers/isdn/capi/capiutil.c
+++ b/drivers/isdn/capi/capiutil.c
@@ -132,7 +132,7 @@ char *capi_info2str(u16 reason)
 	case 0x300D: 
 	   return "Reset procedure not supported by current protocol";
 
-/*-- informations about the clearing of a physical connection -----*/
+/*-- information about the clearing of a physical connection -----*/
 	case 0x3301: 
 	   return "Protocol error layer 1 (broken line or B-channel removed by signalling protocol)";
 	case 0x3302: 
diff --git a/drivers/isdn/hardware/eicon/message.c b/drivers/isdn/hardware/eicon/message.c
index 341ef17..f0b44a8 100644
--- a/drivers/isdn/hardware/eicon/message.c
+++ b/drivers/isdn/hardware/eicon/message.c
@@ -14955,7 +14955,7 @@ static void VSwitchReqInd(PLCI   *plci, dword Id, byte   **parms)
    { /* Error */
     break;
    }
-   /* remember all necessary informations */
+   /* remember all necessary information */
    if(parms[i][0]!=11 || parms[i][8]!=3) /* Length Test */
    {
     break;
diff --git a/drivers/isdn/hardware/mISDN/avmfritz.c b/drivers/isdn/hardware/mISDN/avmfritz.c
index 472a2af..6d815cc 100644
--- a/drivers/isdn/hardware/mISDN/avmfritz.c
+++ b/drivers/isdn/hardware/mISDN/avmfritz.c
@@ -1,6 +1,6 @@
 /*
  * avm_fritz.c    low level stuff for AVM FRITZ!CARD PCI ISDN cards
- *                Thanks to AVM, Berlin for informations
+ *                Thanks to AVM, Berlin for information
  *
  * Author       Karsten Keil <keil@isdn4linux.de>
  *
diff --git a/drivers/isdn/hardware/mISDN/mISDNinfineon.c b/drivers/isdn/hardware/mISDN/mISDNinfineon.c
index bc0529a..8c9afcf 100644
--- a/drivers/isdn/hardware/mISDN/mISDNinfineon.c
+++ b/drivers/isdn/hardware/mISDN/mISDNinfineon.c
@@ -1091,7 +1091,7 @@ inf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 	card->ci = get_card_info(ent->driver_data);
 	if (!card->ci) {
-		pr_info("mISDN: do not have informations about adapter at %s\n",
+		pr_info("mISDN: do not have information about adapter at %s\n",
 			pci_name(pdev));
 		kfree(card);
 		pci_disable_device(pdev);
diff --git a/drivers/isdn/hardware/mISDN/speedfax.c b/drivers/isdn/hardware/mISDN/speedfax.c
index 9e07246..6ac851c 100644
--- a/drivers/isdn/hardware/mISDN/speedfax.c
+++ b/drivers/isdn/hardware/mISDN/speedfax.c
@@ -1,7 +1,7 @@
 /*
  * speedfax.c	low level stuff for Sedlbauer Speedfax+ cards
  *		based on the ISAR DSP
- *		Thanks to Sedlbauer AG for informations and HW
+ *		Thanks to Sedlbauer AG for information and HW
  *
  * Author       Karsten Keil <keil@isdn4linux.de>
  *
diff --git a/drivers/isdn/hisax/sedlbauer.c b/drivers/isdn/hisax/sedlbauer.c
index 69dfc8d..ba38555 100644
--- a/drivers/isdn/hisax/sedlbauer.c
+++ b/drivers/isdn/hisax/sedlbauer.c
@@ -14,7 +14,7 @@
  * of the GNU General Public License, incorporated herein by reference.
  *
  * Thanks to  Karsten Keil
- *            Sedlbauer AG for informations
+ *            Sedlbauer AG for information
  *            Edgar Toernig
  *
  */
diff --git a/drivers/macintosh/therm_pm72.c b/drivers/macintosh/therm_pm72.c
index bca2af2..78db9ba 100644
--- a/drivers/macintosh/therm_pm72.c
+++ b/drivers/macintosh/therm_pm72.c
@@ -2141,7 +2141,7 @@ static void fcu_lookup_fans(struct device_node *fcu_node)
 	int i;
 
 	/* The table is filled by default with values that are suitable
-	 * for the old machines without device-tree informations. We scan
+	 * for the old machines without device-tree information. We scan
 	 * the device-tree and override those values with whatever is
 	 * there
 	 */
diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146_video.c
index 9aafa4e..1075762 100644
--- a/drivers/media/common/saa7146_video.c
+++ b/drivers/media/common/saa7146_video.c
@@ -109,7 +109,7 @@ int saa7146_start_preview(struct saa7146_fh *fh)
 
 	DEB_EE(("dev:%p, fh:%p\n",dev,fh));
 
-	/* check if we have overlay informations */
+	/* check if we have overlay information */
 	if( NULL == fh->ov.fh ) {
 		DEB_D(("no overlay data available. try S_FMT first.\n"));
 		return -EAGAIN;
@@ -548,7 +548,7 @@ static int vidioc_s_fbuf(struct file *file, void *fh, struct v4l2_framebuffer *f
 	/* check if overlay is running */
 	if (IS_OVERLAY_ACTIVE(fh) != 0) {
 		if (vv->video_fh != fh) {
-			DEB_D(("refusing to change framebuffer informations while overlay is active in another open.\n"));
+			DEB_D(("refusing to change framebuffer information while overlay is active in another open.\n"));
 			return -EBUSY;
 		}
 	}
@@ -901,7 +901,7 @@ static int vidioc_s_fmt_vid_overlay(struct file *file, void *__fh, struct v4l2_f
 		return -EFAULT;
 	}
 
-	/* fh->ov.fh is used to indicate that we have valid overlay informations, too */
+	/* fh->ov.fh is used to indicate that we have valid overlay information, too */
 	fh->ov.fh = fh;
 
 	/* check if our current overlay is active */
diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index 242f0d5..7216184 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -2,7 +2,7 @@
 
     bttv-cards.c
 
-    this file has configuration informations - card-specific stuff
+    this file has configuration information - card-specific stuff
     like the big tvcards array for the most part
 
     Copyright (C) 1996,97,98 Ralph  Metzler (rjkm@thp.uni-koeln.de)
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index 91399c9..bb556f6 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -2576,7 +2576,7 @@ static int bttv_s_fmt_vid_cap(struct file *file, void *priv,
 
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
 
-	/* update our state informations */
+	/* update our state information */
 	fh->fmt              = fmt;
 	fh->cap.field        = f->fmt.pix.field;
 	fh->cap.last         = V4L2_FIELD_NONE;
diff --git a/drivers/media/video/et61x251/et61x251_core.c b/drivers/media/video/et61x251/et61x251_core.c
index a982750..24617ac 100644
--- a/drivers/media/video/et61x251/et61x251_core.c
+++ b/drivers/media/video/et61x251/et61x251_core.c
@@ -105,7 +105,7 @@ MODULE_PARM_DESC(debug,
 		 "\n<n> Debugging information level, from 0 to 3:"
 		 "\n0 = none (use carefully)"
 		 "\n1 = critical errors"
-		 "\n2 = significant informations"
+		 "\n2 = significant information"
 		 "\n3 = more verbose messages"
 		 "\nLevel 3 is useful for testing only, when only "
 		 "one device is used."
diff --git a/drivers/media/video/mxb.c b/drivers/media/video/mxb.c
index 0b38500..3a75f68 100644
--- a/drivers/media/video/mxb.c
+++ b/drivers/media/video/mxb.c
@@ -323,7 +323,7 @@ static int mxb_init_done(struct saa7146_dev* dev)
 
 	/* check if the saa7740 (aka 'sound arena module') is present
 	   on the mxb. if so, we must initialize it. due to lack of
-	   informations about the saa7740, the values were reverse
+	   information about the saa7740, the values were reverse
 	   engineered. */
 	msg.addr = 0x1b;
 	msg.flags = 0;
@@ -482,7 +482,7 @@ static int vidioc_s_input(struct file *file, void *fh, unsigned int input)
 			input_port_selection[input].hps_sync);
 
 	/* prepare switching of tea6415c and saa7111a;
-	   have a look at the 'background'-file for further informations  */
+	   have a look at the 'background'-file for further information  */
 	switch (input) {
 	case TUNER:
 		i = SAA7115_COMPOSITE0;
diff --git a/drivers/media/video/pwc/pwc-dec23.c b/drivers/media/video/pwc/pwc-dec23.c
index 0c801b8..83fa0fb 100644
--- a/drivers/media/video/pwc/pwc-dec23.c
+++ b/drivers/media/video/pwc/pwc-dec23.c
@@ -343,7 +343,7 @@ int pwc_dec23_init(struct pwc_device *pwc, int type, unsigned char *cmd)
 		build_table_color(TimonRomTable[version][1], pdec->table_0004_pass2, pdec->table_8004_pass2);
 	}
 
-	/* Informations can be coded on a variable number of bits but never less than 8 */
+	/* Information can be coded on a variable number of bits but never less than 8 */
 	shift = 8 - pdec->nbits;
 	pdec->scalebits = SCALEBITS - shift;
 	pdec->nbitsmask = 0xFF >> shift;
diff --git a/drivers/media/video/pwc/pwc.h b/drivers/media/video/pwc/pwc.h
index e947766..6d586d4 100644
--- a/drivers/media/video/pwc/pwc.h
+++ b/drivers/media/video/pwc/pwc.h
@@ -153,7 +153,7 @@ struct pwc_frame_buf
    struct pwc_frame_buf *next;	/* list */
 };
 
-/* additionnal informations used when dealing image between kernel and userland */
+/* additionnal information used when dealing image between kernel and userland */
 struct pwc_imgbuf
 {
 	unsigned long offset;	/* offset of this buffer in the big array of image_data */
diff --git a/drivers/media/video/sn9c102/sn9c102_core.c b/drivers/media/video/sn9c102/sn9c102_core.c
index ce56a1c..f905640 100644
--- a/drivers/media/video/sn9c102/sn9c102_core.c
+++ b/drivers/media/video/sn9c102/sn9c102_core.c
@@ -109,7 +109,7 @@ MODULE_PARM_DESC(debug,
 		 "\nDebugging information level, from 0 to 3:"
 		 "\n0 = none (use carefully)"
 		 "\n1 = critical errors"
-		 "\n2 = significant informations"
+		 "\n2 = significant information"
 		 "\n3 = more verbose messages"
 		 "\nLevel 3 is useful for testing only."
 		 "\nDefault value is "__MODULE_STRING(SN9C102_DEBUG_LEVEL)"."
diff --git a/drivers/media/video/tda9840.c b/drivers/media/video/tda9840.c
index 5d4cf3b..5b39b5c 100644
--- a/drivers/media/video/tda9840.c
+++ b/drivers/media/video/tda9840.c
@@ -7,7 +7,7 @@
     The tda9840 is a stereo/dual sound processor with digital
     identification. It can be found at address 0x84 on the i2c-bus.
 
-    For detailed informations download the specifications directly
+    For detailed information download the specifications directly
     from SGS Thomson at http://www.st.com
 
     This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/video/tea6415c.c b/drivers/media/video/tea6415c.c
index 19621ed..e022a9b 100644
--- a/drivers/media/video/tea6415c.c
+++ b/drivers/media/video/tea6415c.c
@@ -9,7 +9,7 @@
     It is cascadable, i.e. it can be found at the addresses
     0x86 and 0x06 on the i2c-bus.
 
-    For detailed informations download the specifications directly
+    For detailed information download the specifications directly
     from SGS Thomson at http://www.st.com
 
     This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/video/tea6420.c b/drivers/media/video/tea6420.c
index 5ea8404..7de7bef 100644
--- a/drivers/media/video/tea6420.c
+++ b/drivers/media/video/tea6420.c
@@ -9,7 +9,7 @@
     It is cascadable, i.e. it can be found at the addresses 0x98
     and 0x9a on the i2c-bus.
 
-    For detailed informations download the specifications directly
+    For detailed information download the specifications directly
     from SGS Thomson at http://www.st.com
 
     This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index 9b3e828..aa094af 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -67,7 +67,7 @@ enum tvp514x_std {
 };
 
 /**
- * struct tvp514x_std_info - Structure to store standard informations
+ * struct tvp514x_std_info - Structure to store standard information
  * @width: Line width in pixels
  * @height:Number of active lines
  * @video_std: Value to write in REG_VIDEO_STD register
diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index 205b10b..a1b91bb 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -478,7 +478,7 @@ static int fsmc_read_page_hwecc(struct mtd_info *mtd, struct nand_chip *chip,
  * @calc_ecc:	ecc calculated from read data
  *
  * calc_ecc is a 104 bit information containing maximum of 8 error
- * offset informations of 13 bits each in 512 bytes of read data.
+ * offset information of 13 bits each in 512 bytes of read data.
  */
 static int fsmc_correct_data(struct mtd_info *mtd, uint8_t *dat,
 			     uint8_t *read_ecc, uint8_t *calc_ecc)
@@ -499,7 +499,7 @@ static int fsmc_correct_data(struct mtd_info *mtd, uint8_t *dat,
 	 * |---idx[7]--|--.....-----|---idx[2]--||---idx[1]--||---idx[0]--|
 	 *
 	 * calc_ecc is a 104 bit information containing maximum of 8 error
-	 * offset informations of 13 bits each. calc_ecc is copied into a
+	 * offset information of 13 bits each. calc_ecc is copied into a
 	 * uint64_t array and error offset indexes are populated in err_idx
 	 * array
 	 */
diff --git a/drivers/net/ps3_gelic_wireless.c b/drivers/net/ps3_gelic_wireless.c
index 4a624a2..ba992a3 100644
--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -568,7 +568,7 @@ static void gelic_wl_parse_ie(u8 *data, size_t len,
 
 
 /*
- * translate the scan informations from hypervisor to a
+ * translate the scan information from hypervisor to a
  * independent format
  */
 static char *gelic_wl_translate_scan(struct net_device *netdev,
diff --git a/drivers/net/tlan.c b/drivers/net/tlan.c
index ace6404..c552962 100644
--- a/drivers/net/tlan.c
+++ b/drivers/net/tlan.c
@@ -1295,7 +1295,7 @@ static void tlan_set_multicast_list(struct net_device *dev)
 ThunderLAN driver interrupt vectors and table
 
 please see chap. 4, "Interrupt Handling" of the "ThunderLAN
-Programmer's Guide" for more informations on handling interrupts
+Programmer's Guide" for more information on handling interrupts
 generated by TLAN based adapters.
 
 ******************************************************************************
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 2ee6ceb..526e903 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3574,7 +3574,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->freq_offset = rt2x00_get_field16(eeprom, EEPROM_FREQ_OFFSET);
 
 	/*
-	 * Read external LNA informations.
+	 * Read external LNA information.
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
 
@@ -3584,7 +3584,7 @@ int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_EXTERNAL_LNA_BG, &rt2x00dev->flags);
 
 	/*
-	 * Detect if this device has an hardware controlled radio.
+	 * Detect if this device has a hardware controlled radio.
 	 */
 	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_HW_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 77e8113..7cc7afd 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2567,7 +2567,7 @@ static int rt61pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->freq_offset = rt2x00_get_field16(eeprom, EEPROM_FREQ_OFFSET);
 
 	/*
-	 * Read external LNA informations.
+	 * Read external LNA information.
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 02f1148..fa442cf 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1902,7 +1902,7 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		__set_bit(CONFIG_FRAME_TYPE, &rt2x00dev->flags);
 
 	/*
-	 * Detect if this device has an hardware controlled radio.
+	 * Detect if this device has a hardware controlled radio.
 	 */
 	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
 		__set_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags);
@@ -1914,7 +1914,7 @@ static int rt73usb_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->freq_offset = rt2x00_get_field16(eeprom, EEPROM_FREQ_OFFSET);
 
 	/*
-	 * Read external LNA informations.
+	 * Read external LNA information.
 	 */
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
 
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 2ee442c..2a7935a 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -480,7 +480,7 @@ config ASUS_NB_WMI
 	  This is a driver for newer Asus notebooks. It adds extra features
 	  like wireless radio and bluetooth control, leds, hotkeys, backlight...
 
-	  For more informations, see
+	  For more information, see
 	  <file:Documentation/ABI/testing/sysfs-platform-asus-wmi>
 
 	  If you have an ACPI-WMI compatible Asus Notebook, say Y or M
@@ -493,7 +493,7 @@ config EEEPC_WMI
 	  This is a driver for newer Eee PC laptops. It adds extra features
 	  like wireless radio and bluetooth control, leds, hotkeys, backlight...
 
-	  For more informations, see
+	  For more information, see
 	  <file:Documentation/ABI/testing/sysfs-platform-asus-wmi>
 
 	  If you have an ACPI-WMI compatible Eee PC laptop (>= 1000), say Y or M
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 3242bca..56f173f 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -1742,7 +1742,7 @@ static int __devinit gdth_search_drives(gdth_ha_str *ha)
     }
     TRACE2(("Controller name: %s\n",ha->binfo.type_string));
 
-    /* read more informations */
+    /* read more information */
     if (ha->more_proc) {
         /* physical drives, channel addresses */
         ioc = (gdth_iochan_str *)ha->pscratch;
@@ -1963,7 +1963,7 @@ static int gdth_analyse_hdrive(gdth_ha_str *ha, u16 hdrive)
     TRACE2(("gdth_search_dr() cdr. %d size %d hds %d scs %d\n",
             hdrive,ha->hdr[hdrive].size,drv_hds,drv_secs));
 
-    /* get informations about device */
+    /* get information about device */
     if (gdth_internal_cmd(ha, CACHESERVICE, GDT_DEVTYPE, hdrive, 0, 0)) {
         TRACE2(("gdth_search_dr() cache drive %d devtype %d\n",
                 hdrive,ha->info));
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index 120a062..655cb15 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -5,7 +5,7 @@
  * Header file for the GDT Disk Array/Storage RAID controllers driver for Linux
  * 
  * gdth.h Copyright (C) 1995-06 ICP vortex, Achim Leubner
- * See gdth.c for further informations and 
+ * See gdth.c for further information and 
  * below for supported controller types
  *
  * <achim_leubner@adaptec.com>
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 154c715..4b20478 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1318,7 +1318,7 @@ lpfc_copy_fcf_record(struct lpfc_fcf_rec *fcf_rec,
  * @flag: flag bits to be set to the driver fcf record.
  *
  * This routine updates the driver FCF record from the new HBA FCF record
- * together with the address mode, vlan_id, and other informations. This
+ * together with the address mode, vlan_id, and other information. This
  * routine is called with the host lock held.
  **/
 static void
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 46cc382..6798ea5 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -7230,7 +7230,7 @@ static struct ccb *ncr_get_ccb(struct ncb *np, struct scsi_cmnd *cmd)
 	}
 
 	/*
-	**	Remember all informations needed to free this CCB.
+	**	Remember all information needed to free this CCB.
 	*/
 	cp->tag	   = tag;
 	cp->target = tn;
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index b4543f5..f732a3e 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1169,7 +1169,7 @@ printk("sym_user_command: data=%ld\n", uc->data);
 
 #ifdef SYM_LINUX_USER_INFO_SUPPORT
 /*
- *  Informations through the proc file system.
+ *  Information through the proc file system.
  */
 struct info_str {
 	char *buffer;
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 2c3e89d..db9252e 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -619,7 +619,7 @@ static inline void sym_init_burst(struct sym_hcb *np, u_char bc)
  *  Save initial settings of some IO registers.
  *  Assumed to have been set by BIOS.
  *  We cannot reset the chip prior to reading the 
- *  IO registers, since informations will be lost.
+ *  IO registers, since information will be lost.
  *  Since the SCRIPTS processor may be running, this 
  *  is not safe on paper, but it seems to work quite 
  *  well. :)
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
index a93e234..a2cda9a 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
@@ -252,7 +252,7 @@ int i_AddiHeaderRW_ReadEeprom(int i_NbOfWordsToRead,
 /*+----------------------------------------------------------------------------+*/
 
 void v_GetAPCI3200EepromCalibrationValue(unsigned int dw_PCIBoardEepromAddress,
-	struct str_BoardInfos *BoardInformations)
+	struct str_BoardInfos *BoardInformation)
 {
 	unsigned short w_AnalogInputMainHeaderAddress;
 	unsigned short w_AnalogInputComponentAddress;
@@ -367,12 +367,12 @@ void v_GetAPCI3200EepromCalibrationValue(unsigned int dw_PCIBoardEepromAddress,
 				dw_PCIBoardEepromAddress, w_AnalogInputComponentAddress + 70 + (2 * (1 + (w_NumberOfGainValue / 16))) + (0x02 * w_GainIndex),	/*  Gain value */
 				&w_GainValue);
 
-			BoardInformations->s_Module[w_ModulCounter].
+			BoardInformation->s_Module[w_ModulCounter].
 				w_GainValue[w_GainIndex] = w_GainValue;
 
 #             ifdef PRINT_INFO
 			printk("\n Gain value = %d",
-				BoardInformations->s_Module[w_ModulCounter].
+				BoardInformation->s_Module[w_ModulCounter].
 				w_GainValue[w_GainIndex]);
 #             endif
 
@@ -383,14 +383,14 @@ void v_GetAPCI3200EepromCalibrationValue(unsigned int dw_PCIBoardEepromAddress,
 				dw_PCIBoardEepromAddress, w_AnalogInputComponentAddress + 70 + ((2 * w_NumberOfGainValue) + (2 * (1 + (w_NumberOfGainValue / 16)))) + (0x04 * w_GainIndex),	/*  Gain factor */
 				w_GainFactorValue);
 
-			BoardInformations->s_Module[w_ModulCounter].
+			BoardInformation->s_Module[w_ModulCounter].
 				ul_GainFactor[w_GainIndex] =
 				(w_GainFactorValue[1] << 16) +
 				w_GainFactorValue[0];
 
 #             ifdef PRINT_INFO
 			printk("\n w_GainFactorValue [%d] = %lu", w_GainIndex,
-				BoardInformations->s_Module[w_ModulCounter].
+				BoardInformation->s_Module[w_ModulCounter].
 				ul_GainFactor[w_GainIndex]);
 #             endif
 		}
@@ -410,14 +410,14 @@ void v_GetAPCI3200EepromCalibrationValue(unsigned int dw_PCIBoardEepromAddress,
 	  /************************************/
 	  /** Save the current sources value **/
 	  /************************************/
-			BoardInformations->s_Module[w_ModulCounter].
+			BoardInformation->s_Module[w_ModulCounter].
 				ul_CurrentSource[w_Input] =
 				(w_CurrentSources[0] +
 				((w_CurrentSources[1] & 0xFFF) << 16));
 
 #             ifdef PRINT_INFO
 			printk("\n Current sources [%d] = %lu", w_Input,
-				BoardInformations->s_Module[w_ModulCounter].
+				BoardInformation->s_Module[w_ModulCounter].
 				ul_CurrentSource[w_Input]);
 #             endif
 		}
@@ -433,14 +433,14 @@ void v_GetAPCI3200EepromCalibrationValue(unsigned int dw_PCIBoardEepromAddress,
       /************************************/
       /** Save the current sources value **/
       /************************************/
-		BoardInformations->s_Module[w_ModulCounter].
+		BoardInformation->s_Module[w_ModulCounter].
 			ul_CurrentSourceCJC =
 			(w_CurrentSources[0] +
 			((w_CurrentSources[1] & 0xFFF) << 16));
 
 #          ifdef PRINT_INFO
 		printk("\n Current sources CJC = %lu",
-			BoardInformations->s_Module[w_ModulCounter].
+			BoardInformation->s_Module[w_ModulCounter].
 			ul_CurrentSourceCJC);
 #          endif
 	}
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 466e69f..8adedca 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -4,7 +4,7 @@
  * Author: Michal Dobes <dobes@tesnet.cz>
  *
  * Thanks to ZhenGang Shang <ZhenGang.Shang@Advantech.com.cn>
- * for testing and informations.
+ * for testing and information.
  *
  *  hardware driver for Advantech cards:
  *   card:   PCI-1710, PCI-1710HG, PCI-1711, PCI-1713, PCI-1720, PCI-1731
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index c852f86..7f8e029 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -118,7 +118,7 @@ typedef struct _ce_stats_t {
 	u32 norcvbuf;	/* # Rx packets discarded */
 	u32 noxmtbuf;	/* # Tx packets discarded */
 
-	/* Transciever state informations. */
+	/* Transciever state information. */
 	u8 xcvr_addr;
 	u32 xcvr_id;
 
diff --git a/drivers/staging/rt2860/common/mlme.c b/drivers/staging/rt2860/common/mlme.c
index d9c3fd5..cbe1c5d 100644
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -4781,7 +4781,7 @@ BOOLEAN MlmeEnqueueForRecv(struct rt_rtmp_adapter *pAd,
 		}
 	}
 
-	/* OK, we got all the informations, it is time to put things into queue */
+	/* OK, we got all the information, it is time to put things into queue */
 	NdisAcquireSpinLock(&(Queue->Lock));
 	Tail = Queue->Tail;
 	Queue->Tail++;
diff --git a/drivers/staging/rtl8192e/r819xE_cmdpkt.c b/drivers/staging/rtl8192e/r819xE_cmdpkt.c
index 756e066..ac5a0d0 100644
--- a/drivers/staging/rtl8192e/r819xE_cmdpkt.c
+++ b/drivers/staging/rtl8192e/r819xE_cmdpkt.c
@@ -215,7 +215,7 @@ static void cmpk_handle_interrupt_status(struct r8192_priv *priv, u8 *pmsg)
 		}
 	}
 
-	 // Other informations in interrupt status we need?
+	 // Other information in interrupt status we need?
 
 
 	DMESG("<---- cmpk_handle_interrupt_status()\n");
diff --git a/drivers/staging/rtl8192e/r819xE_cmdpkt.h b/drivers/staging/rtl8192e/r819xE_cmdpkt.h
index 312e4f8..9d65150 100644
--- a/drivers/staging/rtl8192e/r819xE_cmdpkt.h
+++ b/drivers/staging/rtl8192e/r819xE_cmdpkt.h
@@ -66,7 +66,7 @@ typedef struct tag_cmd_pkt_tx_feedback
 }cmpk_txfb_t;
 
 /* 2. RX side: Interrupt status packet. It includes Beacon State,
-	  Beacon Timer Interrupt and other useful informations in MAC ISR Reg. */
+	  Beacon Timer Interrupt and other useful information in MAC ISR Reg. */
 typedef struct tag_cmd_pkt_interrupt_status
 {
 	u8	element_id;			/* Command packet type. */
diff --git a/drivers/staging/rtl8192u/r819xU_cmdpkt.c b/drivers/staging/rtl8192u/r819xU_cmdpkt.c
index 0cb28c7..817a81b 100644
--- a/drivers/staging/rtl8192u/r819xU_cmdpkt.c
+++ b/drivers/staging/rtl8192u/r819xU_cmdpkt.c
@@ -437,7 +437,7 @@ cmpk_handle_interrupt_status(
 
 	}
 
-	 // Other informations in interrupt status we need?
+	 // Other information in interrupt status we need?
 
 
 	DMESG("<---- cmpk_handle_interrupt_status()\n");
diff --git a/drivers/staging/rtl8192u/r819xU_cmdpkt.h b/drivers/staging/rtl8192u/r819xU_cmdpkt.h
index a8855e6..c8f9641 100644
--- a/drivers/staging/rtl8192u/r819xU_cmdpkt.h
+++ b/drivers/staging/rtl8192u/r819xU_cmdpkt.h
@@ -56,7 +56,7 @@ typedef struct tag_cmd_pkt_tx_feedback
 }cmpk_txfb_t;
 
 /* 2. RX side: Interrupt status packet. It includes Beacon State,
-	  Beacon Timer Interrupt and other useful informations in MAC ISR Reg. */
+	  Beacon Timer Interrupt and other useful information in MAC ISR Reg. */
 typedef struct tag_cmd_pkt_interrupt_status
 {
 	u8	element_id;			/* Command packet type. */
diff --git a/drivers/staging/vt6655/bssdb.h b/drivers/staging/vt6655/bssdb.h
index 0af4211..998d537 100644
--- a/drivers/staging/vt6655/bssdb.h
+++ b/drivers/staging/vt6655/bssdb.h
@@ -124,7 +124,7 @@ typedef struct tagKnownBSS {
     //For any BSSID selection improvment
     bool bSelected;
 
-    //++ WPA informations
+    //++ WPA information
     bool bWPAValid;
     unsigned char byGKType;
     unsigned char abyPKType[4];
@@ -135,7 +135,7 @@ typedef struct tagKnownBSS {
     unsigned char byReplayIdx;
     //--
 
-    //++ WPA2 informations
+    //++ WPA2 information
     bool bWPA2Valid;
     unsigned char byCSSGK;
     unsigned short wCSSPKCount;
diff --git a/drivers/staging/vt6655/wmgr.c b/drivers/staging/vt6655/wmgr.c
index e540110..466c242 100644
--- a/drivers/staging/vt6655/wmgr.c
+++ b/drivers/staging/vt6655/wmgr.c
@@ -2958,7 +2958,7 @@ s_vMgrSynchBSS (
         MACvRegBitsOff(pDevice->PortOffset, MAC_REG_TCR, TCR_AUTOBCNTX);
     }
 
-    // Init the BSS informations
+    // Init the BSS information
     pDevice->bCCK = true;
     pDevice->bProtectMode = false;
     MACvDisableProtectMD(pDevice->PortOffset);
diff --git a/drivers/staging/vt6655/wpa.h b/drivers/staging/vt6655/wpa.h
index 921fd7a..eba11c1 100644
--- a/drivers/staging/vt6655/wpa.h
+++ b/drivers/staging/vt6655/wpa.h
@@ -20,7 +20,7 @@
  * File: wpa.h
  *
  * Purpose: Defines the macros, types, and functions for dealing
- *          with WPA informations.
+ *          with WPA information.
  *
  * Author: Kyle Hsu
  *
diff --git a/drivers/staging/vt6655/wpa2.h b/drivers/staging/vt6655/wpa2.h
index 718208b..b6dc54e 100644
--- a/drivers/staging/vt6655/wpa2.h
+++ b/drivers/staging/vt6655/wpa2.h
@@ -20,7 +20,7 @@
  * File: wpa2.h
  *
  * Purpose: Defines the macros, types, and functions for dealing
- *          with WPA2 informations.
+ *          with WPA2 information.
  *
  * Author: Yiching Chen
  *
diff --git a/drivers/staging/vt6656/bssdb.h b/drivers/staging/vt6656/bssdb.h
index a8f97eb..fcc7341 100644
--- a/drivers/staging/vt6656/bssdb.h
+++ b/drivers/staging/vt6656/bssdb.h
@@ -115,7 +115,7 @@ typedef struct tagKnownBSS {
     //For any BSSID selection improvment
     BOOL            bSelected;
 
-    //++ WPA informations
+    //++ WPA information
     BOOL            bWPAValid;
     BYTE            byGKType;
     BYTE            abyPKType[4];
@@ -126,7 +126,7 @@ typedef struct tagKnownBSS {
     BYTE            byReplayIdx;
     //--
 
-    //++ WPA2 informations
+    //++ WPA2 information
     BOOL            bWPA2Valid;
     BYTE            byCSSGK;
     WORD            wCSSPKCount;
diff --git a/drivers/staging/vt6656/wmgr.c b/drivers/staging/vt6656/wmgr.c
index 2ec200d..bd233cd 100644
--- a/drivers/staging/vt6656/wmgr.c
+++ b/drivers/staging/vt6656/wmgr.c
@@ -2955,7 +2955,7 @@ s_vMgrSynchBSS (
         MACvRegBitsOff(pDevice, MAC_REG_TCR, TCR_AUTOBCNTX);
     }
 
-    // Init the BSS informations
+    // Init the BSS information
     pDevice->bCCK = TRUE;
     pDevice->bProtectMode = FALSE;
     MACvDisableProtectMD(pDevice);
diff --git a/drivers/staging/vt6656/wpa.h b/drivers/staging/vt6656/wpa.h
index 889489a..48f1945 100644
--- a/drivers/staging/vt6656/wpa.h
+++ b/drivers/staging/vt6656/wpa.h
@@ -20,7 +20,7 @@
  * File: wpa.h
  *
  * Purpose: Defines the macros, types, and functions for dealing
- *          with WPA informations.
+ *          with WPA information.
  *
  * Author: Kyle Hsu
  *
diff --git a/drivers/staging/vt6656/wpa2.h b/drivers/staging/vt6656/wpa2.h
index 46c2959..2529ea2 100644
--- a/drivers/staging/vt6656/wpa2.h
+++ b/drivers/staging/vt6656/wpa2.h
@@ -20,7 +20,7 @@
  * File: wpa2.h
  *
  * Purpose: Defines the macros, types, and functions for dealing
- *          with WPA2 informations.
+ *          with WPA2 information.
  *
  * Author: Yiching Chen
  *
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index b0b2ac3..fd0eb44 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -774,7 +774,7 @@ static u32 depth_to_dst(u32 depth)
 }
 
 /*
- * PLL informations retreival
+ * PLL information retreival
  */
 
 
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 32f8cf6..729ab08 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -664,7 +664,7 @@ static void __devinit radeon_get_pllinfo(struct radeonfb_info *rinfo)
 #endif /* CONFIG_PPC_OF || CONFIG_SPARC */
 
 	/*
-	 * Check out if we have an X86 which gave us some PLL informations
+	 * Check out if we have an X86 which gave us some PLL information
 	 * and if yes, retrieve them
 	 */
 	if (!force_measure_pll && rinfo->bios_seg) {
@@ -2311,7 +2311,7 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 	if (rinfo->bios_seg == NULL && rinfo->is_mobility)
 		radeon_map_ROM(rinfo, pdev);
 
-	/* Get informations about the board's PLL */
+	/* Get information about the board's PLL */
 	radeon_get_pllinfo(rinfo);
 
 #ifdef CONFIG_FB_RADEON_I2C
diff --git a/drivers/video/aty/radeon_monitor.c b/drivers/video/aty/radeon_monitor.c
index 9261c91..c59e93e 100644
--- a/drivers/video/aty/radeon_monitor.c
+++ b/drivers/video/aty/radeon_monitor.c
@@ -57,7 +57,7 @@ static char *radeon_get_mon_name(int type)
 
 #if defined(CONFIG_PPC_OF) || defined(CONFIG_SPARC)
 /*
- * Try to find monitor informations & EDID data out of the Open Firmware
+ * Try to find monitor information & EDID data out of the Open Firmware
  * device-tree. This also contains some "hacks" to work around a few machine
  * models with broken OF probing by hard-coding known EDIDs for some Mac
  * laptops internal LVDS panel. (XXX: not done yet)
@@ -247,7 +247,7 @@ static int __devinit radeon_get_panel_info_BIOS(struct radeonfb_info *rinfo)
 	return 0;
 }
 
-/* Try to extract the connector informations from the BIOS. This
+/* Try to extract the connector information from the BIOS. This
  * doesn't quite work yet, but it's output is still useful for
  * debugging
  */
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index ee42b9e..e537076 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -852,8 +852,8 @@ static int fat_get_short_entry(struct inode *dir, loff_t *pos,
 }
 
 /*
- * The ".." entry can not provide the "struct fat_slot_info" informations
- * for inode. So, this function provide the some informations only.
+ * The ".." entry can not provide the "struct fat_slot_info" information
+ * for inode. So, this function provides the some information only.
  */
 int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
 			 struct msdos_dir_entry **de, loff_t *i_pos)
diff --git a/fs/jffs2/xattr.c b/fs/jffs2/xattr.c
index 3e93cdd..cfcae36 100644
--- a/fs/jffs2/xattr.c
+++ b/fs/jffs2/xattr.c
@@ -34,8 +34,8 @@
  *   memory usage by cache is over c->xdatum_mem_threshold. Currently, this threshold
  *   is hard coded as 32KiB.
  * do_verify_xattr_datum(c, xd)
- *   is used to load the xdatum informations without name/value pair from the medium.
- *   It's necessary once, because those informations are not collected during mounting
+ *   is used to load the xdatum information without name/value pair from the medium.
+ *   It's necessary once, because those information are not collected during mounting
  *   process when EBS is enabled.
  *   0 will be returned, if success. An negative return value means recoverable error, and
  *   positive return value means unrecoverable error. Thus, caller must remove this xdatum
diff --git a/include/linux/hdlcdrv.h b/include/linux/hdlcdrv.h
index c010b4a..0c3f1d2 100644
--- a/include/linux/hdlcdrv.h
+++ b/include/linux/hdlcdrv.h
@@ -165,7 +165,7 @@ static inline void hdlcdrv_add_bitbuffer_word(struct hdlcdrv_bitbuffer *buf,
 
 struct hdlcdrv_ops {
 	/*
-	 * first some informations needed by the hdlcdrv routines
+	 * first some information needed by the hdlcdrv routines
 	 */
 	const char *drvname;
 	const char *drvinfo;
diff --git a/include/media/saa7146.h b/include/media/saa7146.h
index 7982714..1ad733f 100644
--- a/include/media/saa7146.h
+++ b/include/media/saa7146.h
@@ -131,7 +131,7 @@ struct saa7146_dev
 	void				*ext_priv;	/* pointer for extension private use (most likely some private data) */
 	struct saa7146_ext_vv		*ext_vv_data;
 
-	/* per device video/vbi informations (if available) */
+	/* per device video/vbi information (if available) */
 	struct saa7146_vv	*vv_data;
 	void (*vv_callback)(struct saa7146_dev *dev, unsigned long status);
 
diff --git a/include/media/saa7146_vv.h b/include/media/saa7146_vv.h
index 4aeff96..923649b 100644
--- a/include/media/saa7146_vv.h
+++ b/include/media/saa7146_vv.h
@@ -151,7 +151,7 @@ struct saa7146_vv
 
 struct saa7146_ext_vv
 {
-	/* informations about the video capabilities of the device */
+	/* information about the video capabilities of the device */
 	int	inputs;
 	int	audios;
 	u32	capabilities;
@@ -238,7 +238,7 @@ void saa7146_res_free(struct saa7146_fh *fh, unsigned int bits);
 #define SAA7146_CLIPPING_MASK		0x6
 #define SAA7146_CLIPPING_MASK_INVERTED	0x7
 
-/* output formats: each entry holds four informations */
+/* output formats: each entry holds four information */
 #define RGB08_COMPOSED	0x0217 /* composed is used in the sense of "not-planar" */
 /* this means: planar?=0, yuv2rgb-conversation-mode=2, dither=yes(=1), format-mode = 7 */
 #define RGB15_COMPOSED	0x0213
diff --git a/include/sound/emux_legacy.h b/include/sound/emux_legacy.h
index 6fe3da2..b8ee6f5 100644
--- a/include/sound/emux_legacy.h
+++ b/include/sound/emux_legacy.h
@@ -4,7 +4,7 @@
 /*
  *  Copyright (c) 1999-2000 Takashi Iwai <tiwai@suse.de>
  *
- *  Definitions of OSS compatible headers for Emu8000 device informations
+ *  Definitions of OSS compatible headers for Emu8000 device information
  *
  *   This program is free software; you can redistribute it and/or modify
  *   it under the terms of the GNU General Public License as published by
diff --git a/sound/core/seq/oss/seq_oss_init.c b/sound/core/seq/oss/seq_oss_init.c
index 69cd7b3..41efc6f 100644
--- a/sound/core/seq/oss/seq_oss_init.c
+++ b/sound/core/seq/oss/seq_oss_init.c
@@ -396,7 +396,7 @@ delete_seq_queue(int queue)
 
 
 /*
- * free device informations - private_free callback of port
+ * free device information - private_free callback of port
  */
 static void
 free_devinfo(void *private)
diff --git a/sound/oss/aedsp16.c b/sound/oss/aedsp16.c
index 35b5912..69663a7 100644
--- a/sound/oss/aedsp16.c
+++ b/sound/oss/aedsp16.c
@@ -61,7 +61,7 @@
    routine is called before the OSS Lite probe routines try to detect the
    hardware.
 
-   NOTE (READ THE NOTE TOO, IT CONTAIN USEFUL INFORMATIONS)
+   NOTE (READ THE NOTE TOO, IT CONTAINS USEFUL INFORMATION)
 
    NOTE: Now it works with SC-6000 and SC-6600 based audio cards. The new cards
    have no jumper switch at all. No more WSS or MPU-401 I/O port switches. They
diff --git a/sound/pci/aw2/aw2-saa7146.c b/sound/pci/aw2/aw2-saa7146.c
index 8afd8b5..5545c68 100644
--- a/sound/pci/aw2/aw2-saa7146.c
+++ b/sound/pci/aw2/aw2-saa7146.c
@@ -161,7 +161,7 @@ void snd_aw2_saa7146_pcm_init_playback(struct snd_aw2_saa7146 *chip,
 	unsigned long dw_page, dw_limit;
 
 	/* Configure DMA for substream
-	   Configuration informations: ALSA has allocated continuous memory
+	   Configuration information: ALSA has allocated continuous memory
 	   pages. So we don't need to use MMU of saa7146.
 	 */
 
@@ -219,7 +219,7 @@ void snd_aw2_saa7146_pcm_init_capture(struct snd_aw2_saa7146 *chip,
 	unsigned long dw_page, dw_limit;
 
 	/* Configure DMA for substream
-	   Configuration informations: ALSA has allocated continuous memory
+	   Configuration information: ALSA has allocated continuous memory
 	   pages. So we don't need to use MMU of saa7146.
 	 */
 
diff --git a/sound/pci/echoaudio/echoaudio.c b/sound/pci/echoaudio/echoaudio.c
index 20763dd..7af1699 100644
--- a/sound/pci/echoaudio/echoaudio.c
+++ b/sound/pci/echoaudio/echoaudio.c
@@ -1791,7 +1791,7 @@ static struct snd_kcontrol_new snd_echo_vumeters __devinitdata = {
 
 
 
-/*** Channels info - it exports informations about the number of channels ***/
+/*** Channels info - it exports information about the number of channels ***/
 static int snd_echo_channels_info_info(struct snd_kcontrol *kcontrol,
 				       struct snd_ctl_elem_info *uinfo)
 {
diff --git a/sound/pci/rme32.c b/sound/pci/rme32.c
index 3c04524..da4b8d7 100644
--- a/sound/pci/rme32.c
+++ b/sound/pci/rme32.c
@@ -7,7 +7,7 @@
  *      Thanks to :        Anders Torger <torger@ludd.luth.se>,
  *                         Henk Hesselink <henk@anda.nl>
  *                         for writing the digi96-driver 
- *                         and RME for all informations.
+ *                         and RME for all information.
  *
  *   This program is free software; you can redistribute it and/or modify
  *   it under the terms of the GNU General Public License as published by
diff --git a/sound/pci/rme9652/hdsp.c b/sound/pci/rme9652/hdsp.c
index 2d83324..4fa1165 100644
--- a/sound/pci/rme9652/hdsp.c
+++ b/sound/pci/rme9652/hdsp.c
@@ -3953,7 +3953,7 @@ snd_hdsp_proc_read(struct snd_info_entry *entry, struct snd_info_buffer *buffer)
 
 	snd_iprintf(buffer, "\n");
 
-	/* Informations about H9632 specific controls */
+	/* Information about H9632 specific controls */
 	if (hdsp->io_type == H9632) {
 		char *tmp;
 
diff --git a/sound/ppc/tumbler.c b/sound/ppc/tumbler.c
index 961d982..61e39d2 100644
--- a/sound/ppc/tumbler.c
+++ b/sound/ppc/tumbler.c
@@ -1145,7 +1145,7 @@ static long tumbler_find_device(const char *device, const char *platform,
 		gp->active_val = 0x4;
 		gp->inactive_val = 0x5;
 		/* Here are some crude hacks to extract the GPIO polarity and
-		 * open collector informations out of the do-platform script
+		 * open collector information out of the do-platform script
 		 * as we don't yet have an interpreter for these things
 		 */
 		if (platform)
-- 
1.7.4.1


--=-S3LjurGudUxFb/IACCaR--

