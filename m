Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1K2EbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 23:31:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65266 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573Ab1K2EbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 23:31:19 -0500
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
        linux-kernel@vger.kernel.org, pebolle@tiscali.nl, mad_soft@inbox.ru,
        rdunlap@xenotime.net
Subject: [RFC v6]Trivial: Fix typos in various parts of the kernel, and fix some comments.
Date: Mon, 28 Nov 2011 20:31:00 -0800
Message-Id: <1322541060-26444-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch fixes some typos in various parts of the kernel, as well as fixes some comments.
Please let me know if I missed anything, and I will try to get it changed and resent.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: pebolle@tiscali.nl
Cc: mad_soft@inbox.ru
Cc: rdunlap@xenotime.net
---
 arch/arm/plat-omap/include/plat/serial.h           |    2 +-
 arch/powerpc/include/asm/io.h                      |    2 +-
 arch/powerpc/include/asm/keylargo.h                |    2 +-
 arch/powerpc/mm/numa.c                             |    2 +-
 arch/sparc/kernel/smp_64.c                         |    2 +-
 drivers/acpi/acpica/hwxface.c                      |    2 +-
 drivers/block/xen-blkback/xenbus.c                 |    2 +-
 drivers/char/ipmi/ipmi_bt_sm.c                     |    2 +-
 drivers/edac/ppc4xx_edac.c                         |    2 +-
 drivers/media/video/zoran/zoran_driver.c           |    2 +-
 drivers/message/fusion/lsi/mpi_ioc.h               |    2 +-
 drivers/net/irda/nsc-ircc.c                        |    2 +-
 drivers/net/irda/via-ircc.c                        |    4 ++--
 drivers/net/irda/w83977af_ir.c                     |    2 +-
 drivers/net/wimax/i2400m/i2400m.h                  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c        |    4 ++--
 drivers/parport/parport_mfc3.c                     |    2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm.c               |    2 +-
 drivers/scsi/ips.c                                 |    2 +-
 drivers/scsi/qla4xxx/ql4_fw.h                      |    2 +-
 drivers/scsi/vmw_pvscsi.c                          |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3200.c      |    2 +-
 drivers/staging/cxt1e1/libsbew.h                   |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |    4 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |    2 +-
 drivers/staging/iio/industrialio-trigger.c         |    2 +-
 drivers/staging/sep/sep_driver.c                   |    2 +-
 drivers/staging/tidspbridge/Kconfig                |    2 +-
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |    2 +-
 drivers/usb/host/hwa-hc.c                          |    2 +-
 drivers/usb/host/imx21-hcd.c                       |    2 +-
 drivers/usb/otg/fsl_otg.c                          |    2 +-
 drivers/uwb/i1480/dfu/usb.c                        |    2 +-
 fs/btrfs/inode.c                                   |    2 +-
 fs/ext3/inode.c                                    |    2 +-
 fs/ext4/inode.c                                    |    2 +-
 fs/nfsd/nfs4state.c                                |    2 +-
 fs/ocfs2/file.c                                    |    2 +-
 fs/xfs/xfs_file.c                                  |    6 +++---
 fs/xfs/xfs_log_cil.c                               |    2 +-
 include/drm/drmP.h                                 |    2 +-
 include/linux/wanrouter.h                          |    2 +-
 include/net/mac80211.h                             |    2 +-
 net/ipv4/ip_fragment.c                             |    2 +-
 net/mac80211/work.c                                |    2 +-
 net/sctp/endpointola.c                             |    2 +-
 46 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/arch/arm/plat-omap/include/plat/serial.h b/arch/arm/plat-omap/include/plat/serial.h
index 1ab9fd6..ac44bde 100644
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
index 45698d5..a3855b8 100644
--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -394,7 +394,7 @@ __do_out_asm(_rec_outl, "stwbrx")
 #endif /* CONFIG_PPC32 */
 
 /* The "__do_*" operations below provide the actual "base" implementation
- * for each of the defined acccessor. Some of them use the out_* functions
+ * for each of the defined accessors. Some of them use the out_* functions
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
index b22a83a..ae0a611 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -521,7 +521,7 @@ static int of_get_assoc_arrays(struct device_node *memory,
 	aa->n_arrays = *prop++;
 	aa->array_sz = *prop++;
 
-	/* Now that we know the number of arrrays and size of each array,
+	/* Now that we know the number of arrays and size of each array,
 	 * revalidate the size of the property read in.
 	 */
 	if (len < (aa->n_arrays * aa->array_sz + 2) * sizeof(unsigned int))
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 7560772..3b1bd7c 100644
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
index c2793a8..d707756 100644
--- a/drivers/acpi/acpica/hwxface.c
+++ b/drivers/acpi/acpica/hwxface.c
@@ -356,7 +356,7 @@ ACPI_EXPORT_SYMBOL(acpi_read_bit_register)
  *
  * PARAMETERS:  register_id     - ID of ACPI Bit Register to access
  *              Value           - Value to write to the register, in bit
- *                                position zero. The bit is automaticallly
+ *                                position zero. The bit is automatically
  *                                shifted to the correct position.
  *
  * RETURN:      Status
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index f759ad4..8069322 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -613,7 +613,7 @@ static void frontend_changed(struct xenbus_device *dev,
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
index 3840096..fc75706 100644
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
index d4d05d2..f6d2641 100644
--- a/drivers/media/video/zoran/zoran_driver.c
+++ b/drivers/media/video/zoran/zoran_driver.c
@@ -1550,7 +1550,7 @@ static int zoran_enum_fmt(struct zoran *zr, struct v4l2_fmtdesc *fmt, int flag)
 		if (zoran_formats[i].flags & flag && num++ == fmt->index) {
 			strncpy(fmt->description, zoran_formats[i].name,
 				sizeof(fmt->description) - 1);
-			/* fmt struct pre-zeroed, so adding '\0' not neeed */
+			/* fmt struct pre-zeroed, so adding '\0' not needed */
 			fmt->pixelformat = zoran_formats[i].fourcc;
 			if (zoran_formats[i].flags & ZORAN_FORMAT_COMPRESSED)
 				fmt->flags |= V4L2_FMT_FLAG_COMPRESSED;
diff --git a/drivers/message/fusion/lsi/mpi_ioc.h b/drivers/message/fusion/lsi/mpi_ioc.h
index fd62228..19fb21b 100644
--- a/drivers/message/fusion/lsi/mpi_ioc.h
+++ b/drivers/message/fusion/lsi/mpi_ioc.h
@@ -857,7 +857,7 @@ typedef struct _EVENT_DATA_SAS_DISCOVERY
 #define MPI_EVENT_SAS_DSCVRY_PHY_BITS_MASK                  (0xFFFF0000)
 #define MPI_EVENT_SAS_DSCVRY_PHY_BITS_SHIFT                 (16)
 
-/* SAS Discovery Errror Event data */
+/* SAS Discovery Error Event data */
 
 typedef struct _EVENT_DATA_DISCOVERY_ERROR
 {
diff --git a/drivers/net/irda/nsc-ircc.c b/drivers/net/irda/nsc-ircc.c
index b56636d..2a4f2f1 100644
--- a/drivers/net/irda/nsc-ircc.c
+++ b/drivers/net/irda/nsc-ircc.c
@@ -1664,7 +1664,7 @@ static int nsc_ircc_dma_xmit_complete(struct nsc_ircc_cb *self)
 	switch_bank(iobase, BANK0);
         outb(inb(iobase+MCR) & ~MCR_DMA_EN, iobase+MCR);
 	
-	/* Check for underrrun! */
+	/* Check for underrun! */
 	if (inb(iobase+ASCR) & ASCR_TXUR) {
 		self->netdev->stats.tx_errors++;
 		self->netdev->stats.tx_fifo_errors++;
diff --git a/drivers/net/irda/via-ircc.c b/drivers/net/irda/via-ircc.c
index 6d64790..2d456dd 100644
--- a/drivers/net/irda/via-ircc.c
+++ b/drivers/net/irda/via-ircc.c
@@ -942,14 +942,14 @@ static int via_ircc_dma_xmit_complete(struct via_ircc_cb *self)
 	iobase = self->io.fir_base;
 	/* Disable DMA */
 //      DisableDmaChannel(self->io.dma);
-	/* Check for underrrun! */
+	/* Check for underrun! */
 	/* Clear bit, by writing 1 into it */
 	Tx_status = GetTXStatus(iobase);
 	if (Tx_status & 0x08) {
 		self->netdev->stats.tx_errors++;
 		self->netdev->stats.tx_fifo_errors++;
 		hwreset(self);
-// how to clear underrrun ?
+	/* how to clear underrun? */
 	} else {
 		self->netdev->stats.tx_packets++;
 		ResetChip(iobase, 3);
diff --git a/drivers/net/irda/w83977af_ir.c b/drivers/net/irda/w83977af_ir.c
index c436660..7d43506 100644
--- a/drivers/net/irda/w83977af_ir.c
+++ b/drivers/net/irda/w83977af_ir.c
@@ -677,7 +677,7 @@ static void w83977af_dma_xmit_complete(struct w83977af_ir *self)
 	switch_bank(iobase, SET0);
 	outb(inb(iobase+HCR) & ~HCR_EN_DMA, iobase+HCR);
 	
-	/* Check for underrrun! */
+	/* Check for underrun! */
 	if (inb(iobase+AUDR) & AUDR_UNDR) {
 		IRDA_DEBUG(0, "%s(), Transmit underrun!\n", __func__ );
 		
diff --git a/drivers/net/wimax/i2400m/i2400m.h b/drivers/net/wimax/i2400m/i2400m.h
index c421a61..c806d45 100644
--- a/drivers/net/wimax/i2400m/i2400m.h
+++ b/drivers/net/wimax/i2400m/i2400m.h
@@ -75,7 +75,7 @@
  *        device is up and running or shutdown (through ifconfig up /
  *        down). Bus-generic only.
  *
- *  - control ops: control.c - implements various commmands for
+ *  - control ops: control.c - implements various commands for
  *        controlling the device. bus-generic only.
  *
  *  - device model glue: driver.c - implements helpers for the
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
index f5bd3a3..9d89d7c 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
@@ -466,8 +466,8 @@ void rtl92de_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		bool int_migration = *(bool *) (val);
 
 		if (int_migration) {
-			/* Set interrrupt migration timer and
-			 * corresponging Tx/Rx counter.
+			/* Set interrupt migration timer and
+			 * corresponding Tx/Rx counter.
 			 * timer 25ns*0xfa0=100us for 0xf packets.
 			 * 0x306:Rx, 0x307:Tx */
 			rtl_write_dword(rtlpriv, REG_INT_MIG, 0xfe000fa0);
diff --git a/drivers/parport/parport_mfc3.c b/drivers/parport/parport_mfc3.c
index 362db31..1c0c642 100644
--- a/drivers/parport/parport_mfc3.c
+++ b/drivers/parport/parport_mfc3.c
@@ -397,7 +397,7 @@ static void __exit parport_mfc3_exit(void)
 
 
 MODULE_AUTHOR("Joerg Dorchain <joerg@dorchain.net>");
-MODULE_DESCRIPTION("Parport Driver for Multiface 3 expansion cards Paralllel Port");
+MODULE_DESCRIPTION("Parport Driver for Multiface 3 expansion cards Parallel Port");
 MODULE_SUPPORTED_DEVICE("Multiface 3 Parallel Port");
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm.c b/drivers/scsi/aic7xxx/aicasm/aicasm.c
index e4a7787..2e3117a 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm.c
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm.c
@@ -1,5 +1,5 @@
 /*
- * Aic7xxx SCSI host adapter firmware asssembler
+ * Aic7xxx SCSI host adapter firmware assembler
  *
  * Copyright (c) 1997, 1998, 2000, 2001 Justin T. Gibbs.
  * Copyright (c) 2001, 2002 Adaptec Inc.
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 218f71a..d77891e 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -4494,7 +4494,7 @@ ips_init_scb(ips_ha_t * ha, ips_scb_t * scb)
 /*                                                                          */
 /*   Initialize a CCB to default values                                     */
 /*                                                                          */
-/* ASSUMED to be callled from within a lock                                 */
+/* ASSUMED to be called from within a lock                                 */
 /*                                                                          */
 /****************************************************************************/
 static ips_scb_t *
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index cbd5a20..866af45 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -744,7 +744,7 @@ struct dev_db_entry {
 	uint8_t res4[0x36];	/* 8A-BF */
 	uint8_t iscsi_name[0xE0];	/* C0-19F : xxzzy Make this a
 					 * pointer to a string so we
-					 * don't have to reserve soooo
+					 * don't have to reserve so
 					 * much RAM */
 	uint8_t link_local_ipv6_addr[0x10]; /* 1A0-1AF */
 	uint8_t res5[0x10];	/* 1B0-1BF */
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index a18996d..7264116 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1144,7 +1144,7 @@ static void pvscsi_release_resources(struct pvscsi_adapter *adapter)
  *
  * These are statically allocated.  Trying to be clever was not worth it.
  *
- * Dynamic allocation can fail, and we can't go deeep into the memory
+ * Dynamic allocation can fail, and we can't go deep into the memory
  * allocator, since we're a SCSI driver, and trying too hard to allocate
  * memory might generate disk I/O.  We also don't want to fail disk I/O
  * in that case because we can't get an allocation - the I/O could be
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
index c75a1a1..f9545b0 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3200.c
@@ -3598,7 +3598,7 @@ int i_APCI3200_InterruptHandleEos(struct comedi_device *dev)
 			n = comedi_buf_write_alloc(s->async,
 				(7 + 12) * sizeof(unsigned int));
 
-			/*  If not enougth memory available, event is set to Comedi Buffer Errror */
+			/*  If not enough memory available, event is set to Comedi Buffer Error */
 			if (n > ((7 + 12) * sizeof(unsigned int))) {
 				printk("\ncomedi_buf_write_alloc n = %i", n);
 				s->async->events |= COMEDI_CB_ERROR;
diff --git a/drivers/staging/cxt1e1/libsbew.h b/drivers/staging/cxt1e1/libsbew.h
index 5c99646..ae8f06d 100644
--- a/drivers/staging/cxt1e1/libsbew.h
+++ b/drivers/staging/cxt1e1/libsbew.h
@@ -323,7 +323,7 @@ struct sbecom_port_param
 #define CFG_CH_DINV_TX      0x02
 
 
-/* Posssible resettable chipsets/functions */
+/* Possible resettable chipsets/functions */
 #define RESET_DEV_TEMUX     1
 #define RESET_DEV_TECT3     RESET_DEV_TEMUX
 #define RESET_DEV_PLL       2
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index b3d743a..917bbb0 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -344,10 +344,10 @@ static void ft1000_reset_asic(struct net_device *dev)
 	}
 	mdelay(1);
 	if (info->AsicID == ELECTRABUZZ_ID) {
-		// set watermark to -1 in order to not generate an interrrupt
+		// set watermark to -1 in order to not generate an interrupt
 		ft1000_write_reg(dev, FT1000_REG_WATERMARK, 0xffff);
 	} else {
-		// set watermark to -1 in order to not generate an interrrupt
+		// set watermark to -1 in order to not generate an interrupt
 		ft1000_write_reg(dev, FT1000_REG_MAG_WATERMARK, 0xffff);
 	}
 	// clear interrupts
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index aaf44c3..43b1d36 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -601,7 +601,7 @@ static void ft1000_reset_asic(struct net_device *dev)
 
 	mdelay(1);
 
-	/* set watermark to -1 in order to not generate an interrrupt */
+	/* set watermark to -1 in order to not generate an interrupt */
 	ft1000_write_register(ft1000dev, 0xffff, FT1000_REG_MAG_WATERMARK);
 
 	/* clear interrupts */
diff --git a/drivers/staging/iio/industrialio-trigger.c b/drivers/staging/iio/industrialio-trigger.c
index 2c626e0..68a4d4e 100644
--- a/drivers/staging/iio/industrialio-trigger.c
+++ b/drivers/staging/iio/industrialio-trigger.c
@@ -295,7 +295,7 @@ void iio_dealloc_pollfunc(struct iio_poll_func *pf)
 EXPORT_SYMBOL_GPL(iio_dealloc_pollfunc);
 
 /**
- * iio_trigger_read_currrent() - trigger consumer sysfs query which trigger
+ * iio_trigger_read_current() - trigger consumer sysfs query which trigger
  *
  * For trigger consumers the current_trigger interface allows the trigger
  * used by the device to be queried.
diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 8ac3fae..f47571e 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -1235,7 +1235,7 @@ static void sep_build_lli_table(struct sep_device *sep,
 	/* Counter of lli array entry */
 	u32 array_counter;
 
-	/* Init currrent table data size and lli array entry counter */
+	/* Init current table data size and lli array entry counter */
 	curr_table_data_size = 0;
 	array_counter = 0;
 	*num_table_entries_ptr = 1;
diff --git a/drivers/staging/tidspbridge/Kconfig b/drivers/staging/tidspbridge/Kconfig
index 93de4f2..21a559e 100644
--- a/drivers/staging/tidspbridge/Kconfig
+++ b/drivers/staging/tidspbridge/Kconfig
@@ -78,7 +78,7 @@ config TIDSPBRIDGE_NTFY_PWRERR
 	bool "Notify power errors"
 	depends on TIDSPBRIDGE
 	help
-	  Enable notifications to registered clients on the event of power errror
+	  Enable notifications to registered clients on the event of power error
 	  trying to suspend bridge driver. Say Y, to signal this event as a fatal
 	  error, this will require a bridge restart to recover.
 
diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
index a7e407e..fda2402 100644
--- a/drivers/staging/tidspbridge/rmgr/dbdcd.c
+++ b/drivers/staging/tidspbridge/rmgr/dbdcd.c
@@ -285,7 +285,7 @@ int dcd_enumerate_object(s32 index, enum dsp_dcdobjtype obj_type,
 			enum_refs = 0;
 
 			/*
-			 * TODO: Revisit, this is not an errror case but code
+			 * TODO: Revisit, this is not an error case but code
 			 * expects non-zero value.
 			 */
 			status = ENODATA;
diff --git a/drivers/usb/host/hwa-hc.c b/drivers/usb/host/hwa-hc.c
index 9bfac65..b5c56a9 100644
--- a/drivers/usb/host/hwa-hc.c
+++ b/drivers/usb/host/hwa-hc.c
@@ -481,7 +481,7 @@ static int __hwahc_op_set_ptk(struct wusbhc *wusbhc, u8 port_idx, u32 tkid,
 		encryption_value = 0;
 	}
 
-	/* Set the encryption type for commmunicating with the device */
+	/* Set the encryption type for communicating with the device */
 	result = usb_control_msg(wa->usb_dev, usb_sndctrlpipe(wa->usb_dev, 0),
 			USB_REQ_SET_ENCRYPTION,
 			USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
diff --git a/drivers/usb/host/imx21-hcd.c b/drivers/usb/host/imx21-hcd.c
index 2ee18cf..dbf0f15 100644
--- a/drivers/usb/host/imx21-hcd.c
+++ b/drivers/usb/host/imx21-hcd.c
@@ -473,7 +473,7 @@ static void free_epdmem(struct imx21 *imx21, struct usb_host_endpoint *ep)
 /* End handling 				*/
 /* ===========================================	*/
 
-/* Endpoint now idle - release it's ETD(s) or asssign to queued request */
+/* Endpoint now idle - release its ETD(s) or assign to queued request */
 static void ep_idle(struct imx21 *imx21, struct ep_priv *ep_priv)
 {
 	int i;
diff --git a/drivers/usb/otg/fsl_otg.c b/drivers/usb/otg/fsl_otg.c
index 0f420b2..2d9cc44 100644
--- a/drivers/usb/otg/fsl_otg.c
+++ b/drivers/usb/otg/fsl_otg.c
@@ -639,7 +639,7 @@ static int fsl_otg_set_power(struct otg_transceiver *otg_p, unsigned mA)
  * Delayed pin detect interrupt processing.
  *
  * When the Mini-A cable is disconnected from the board,
- * the pin-detect interrupt happens before the disconnnect
+ * the pin-detect interrupt happens before the disconnect
  * interrupts for the connected device(s).  In order to
  * process the disconnect interrupt(s) prior to switching
  * roles, the pin-detect interrupts are delayed, and handled
diff --git a/drivers/uwb/i1480/dfu/usb.c b/drivers/uwb/i1480/dfu/usb.c
index ba86643..a315d4d 100644
--- a/drivers/uwb/i1480/dfu/usb.c
+++ b/drivers/uwb/i1480/dfu/usb.c
@@ -104,7 +104,7 @@ void i1480_usb_destroy(struct i1480_usb *i1480_usb)
  *
  * Data buffers to USB cannot be on the stack or in vmalloc'ed areas,
  * so we copy it to the local i1480 buffer before proceeding. In any
- * case, we have a max size we can send, soooo.
+ * case, we have a max size we can send.
  */
 static
 int i1480_usb_write(struct i1480 *i1480, u32 memory_address,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 526dd51..985a584 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1943,7 +1943,7 @@ enum btrfs_orphan_cleanup_state {
 };
 
 /*
- * This is called in transaction commmit time. If there are no orphan
+ * This is called in transaction commit time. If there are no orphan
  * files in the subvolume, it removes orphan item and frees block_rsv
  * structure.
  */
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 85fe655..15cb470 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -2490,7 +2490,7 @@ int ext3_can_truncate(struct inode *inode)
  * transaction, and VFS/VM ensures that ext3_truncate() cannot run
  * simultaneously on behalf of the same inode.
  *
- * As we work through the truncate and commmit bits of it to the journal there
+ * As we work through the truncate and commit bits of it to the journal there
  * is one core, guiding principle: the file's tree must always be consistent on
  * disk.  We must be able to restart the truncate after a crash.
  *
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index fffec40..e20352f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3503,7 +3503,7 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
  * transaction, and VFS/VM ensures that ext4_truncate() cannot run
  * simultaneously on behalf of the same inode.
  *
- * As we work through the truncate and commmit bits of it to the journal there
+ * As we work through the truncate and commit bits of it to the journal there
  * is one core, guiding principle: the file's tree must always be consistent on
  * disk.  We must be able to restart the truncate after a crash.
  *
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 47e94e3..9ca16dc 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -658,7 +658,7 @@ static int nfsd4_sanitize_slot_size(u32 size)
 /*
  * XXX: If we run out of reserved DRC memory we could (up to a point)
  * re-negotiate active sessions and reduce their slot usage to make
- * rooom for new connections. For now we just fail the create session.
+ * room for new connections. For now we just fail the create session.
  */
 static int nfsd4_get_drc_mem(int slotsize, u32 num)
 {
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index de4ea1a..199c606 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2108,7 +2108,7 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 		 * remove_suid() calls ->setattr without any hint that
 		 * we may have already done our cluster locking. Since
 		 * ocfs2_setattr() *must* take cluster locks to
-		 * proceeed, this will lead us to recursively lock the
+		 * proceed, this will lead us to recursively lock the
 		 * inode. There's also the dinode i_size state which
 		 * can be lost via setattr during extending writes (we
 		 * set inode->i_size at the end of a write. */
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 753ed9b..f675f3d 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -209,10 +209,10 @@ xfs_file_fsync(
 
 	/*
 	 * First check if the VFS inode is marked dirty.  All the dirtying
-	 * of non-transactional updates no goes through mark_inode_dirty*,
-	 * which allows us to distinguish beteeen pure timestamp updates
+	 * of non-transactional updates do not go through mark_inode_dirty*,
+	 * which allows us to distinguish between pure timestamp updates
 	 * and i_size updates which need to be caught for fdatasync.
-	 * After that also theck for the dirty state in the XFS inode, which
+	 * After that also check for the dirty state in the XFS inode, which
 	 * might gets cleared when the inode gets written out via the AIL
 	 * or xfs_iflush_cluster.
 	 */
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index c7755d5..3ba29b1 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -256,7 +256,7 @@ xfs_cil_prepare_item(
  * Insert the log items into the CIL and calculate the difference in space
  * consumed by the item. Add the space to the checkpoint ticket and calculate
  * if the change requires additional log metadata. If it does, take that space
- * as well. Remove the amount of space we addded to the checkpoint ticket from
+ * as well. Remove the amount of space we added to the checkpoint ticket from
  * the current transaction ticket so that the accounting works out correctly.
  */
 static void
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 1f9e951..e8acca8 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -820,7 +820,7 @@ struct drm_driver {
 	 * Specifically, the timestamp in @vblank_time should correspond as
 	 * closely as possible to the time when the first video scanline of
 	 * the video frame after the end of VBLANK will start scanning out,
-	 * the time immmediately after end of the VBLANK interval. If the
+	 * the time immediately after end of the VBLANK interval. If the
 	 * @crtc is currently inside VBLANK, this will be a time in the future.
 	 * If the @crtc is currently scanning out a frame, this will be the
 	 * past start time of the current scanout. This is meant to adhere
diff --git a/include/linux/wanrouter.h b/include/linux/wanrouter.h
index e0aa396..3157cc1 100644
--- a/include/linux/wanrouter.h
+++ b/include/linux/wanrouter.h
@@ -309,7 +309,7 @@ typedef struct wandev_conf
 #define WANOPT_EVEN	2
 
 /* CHDLC Protocol Options */
-/* DF Commmented out for now.
+/* DF Commented out for now.
 
 #define WANOPT_CHDLC_NO_DCD		IGNORE_DCD_FOR_LINK_STAT
 #define WANOPT_CHDLC_NO_CTS		IGNORE_CTS_FOR_LINK_STAT
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 72eddd1..bd3487d 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1423,7 +1423,7 @@ ieee80211_get_alt_retry_rate(const struct ieee80211_hw *hw,
  * DOC: Beacon filter support
  *
  * Some hardware have beacon filter support to reduce host cpu wakeups
- * which will reduce system power consumption. It usuallly works so that
+ * which will reduce system power consumption. It usually works so that
  * the firmware creates a checksum of the beacon but omits all constantly
  * changing elements (TSF, TIM etc). Whenever the checksum changes the
  * beacon is forwarded to the host, otherwise it will be just dropped. That
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index fdaabf2..1f23a57 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -392,7 +392,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 	/* Is this the final fragment? */
 	if ((flags & IP_MF) == 0) {
 		/* If we already have some bits beyond end
-		 * or have different end, the segment is corrrupted.
+		 * or have different end, the segment is corrupted.
 		 */
 		if (end < qp->q.len ||
 		    ((qp->q.last_in & INET_FRAG_LAST_IN) && end != qp->q.len))
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 6c53b6d..2accea3 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -1094,7 +1094,7 @@ static void ieee80211_work_work(struct work_struct *work)
 		local->tmp_channel = NULL;
 		/* If tmp_channel wasn't operating channel, then
 		 * we need to go back on-channel.
-		 * NOTE:  If we can ever be here while scannning,
+		 * NOTE:  If we can ever be here while scanning,
 		 * or if the hw_config() channel config logic changes,
 		 * then we may need to do a more thorough check to see if
 		 * we still need to do a hardware config.  Currently,
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index c8cc24e..68a385d 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -415,7 +415,7 @@ static void sctp_endpoint_bh_rcv(struct work_struct *work)
 	sctp_subtype_t subtype;
 	sctp_state_t state;
 	int error = 0;
-	int first_time = 1;	/* is this the first time through the looop */
+	int first_time = 1;	/* is this the first time through the loop */
 
 	if (ep->base.dead)
 		return;
-- 
1.7.5.4

