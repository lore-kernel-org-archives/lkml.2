Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307Ab0JZT5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 15:57:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39472 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758800Ab0JZT5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:57:37 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 02/22] trivial: fix typos concerning "access"
Date: Tue, 26 Oct 2010 21:56:59 +0200
Message-Id: <1288123039-22368-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1288123039-22368-1-git-send-email-u.kleine-koenig@pengutronix.de>
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

I had to skip a French sentence in drivers/char/applicom.c for this
patch.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 Documentation/DocBook/mtdnand.tmpl            |    2 +-
 Documentation/cgroups/cgroup_event_listener.c |    2 +-
 Documentation/kvm/api.txt                     |    2 +-
 arch/arm/mach-at91/board-ecbat91.c            |    6 +++---
 arch/arm/mach-msm/io.c                        |    2 +-
 arch/cris/include/asm/etraxgpio.h             |    2 +-
 arch/ia64/kvm/mmio.c                          |    2 +-
 arch/mips/alchemy/common/power.c              |    2 +-
 arch/powerpc/platforms/83xx/suspend-asm.S     |    6 +++---
 arch/powerpc/platforms/ps3/device-init.c      |    4 ++--
 arch/x86/include/asm/processor.h              |    2 +-
 arch/x86/kernel/early_printk_mrst.c           |    2 +-
 drivers/ata/libata-core.c                     |    4 ++--
 drivers/infiniband/hw/cxgb3/cxio_wr.h         |    2 +-
 drivers/infiniband/hw/qib/qib_iba7322.c       |    2 +-
 drivers/isdn/hardware/mISDN/ipac.h            |    4 ++--
 drivers/isdn/hardware/mISDN/isar.h            |    2 +-
 drivers/media/video/cx25840/cx25840-ir.c      |    2 +-
 drivers/media/video/saa7164/saa7164-core.c    |    4 ++--
 drivers/message/i2o/i2o_block.c               |    2 +-
 drivers/net/e1000e/82571.c                    |    2 +-
 drivers/net/e1000e/ich8lan.c                  |    2 +-
 drivers/net/wireless/prism54/islpci_dev.c     |    6 +++---
 drivers/net/wireless/prism54/islpci_eth.c     |    2 +-
 drivers/s390/scsi/zfcp_cfdc.c                 |    2 +-
 drivers/spi/spidev.c                          |    2 +-
 drivers/video/sstfb.c                         |    2 +-
 fs/ocfs2/inode.c                              |    2 +-
 lib/nlattr.c                                  |    2 +-
 sound/isa/opl3sa2.c                           |    2 +-
 sound/pci/rme9652/hdspm.c                     |    4 ++--
 31 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/Documentation/DocBook/mtdnand.tmpl b/Documentation/DocBook/mtdnand.tmpl
index 020ac80..620eb3f 100644
--- a/Documentation/DocBook/mtdnand.tmpl
+++ b/Documentation/DocBook/mtdnand.tmpl
@@ -250,7 +250,7 @@ static void board_hwcontrol(struct mtd_info *mtd, int cmd)
 		<title>Device ready function</title>
 		<para>
 			If the hardware interface has the ready busy pin of the NAND chip connected to a
-			GPIO or other accesible I/O pin, this function is used to read back the state of the
+			GPIO or other accessible I/O pin, this function is used to read back the state of the
 			pin. The function has no arguments and should return 0, if the device is busy (R/B pin 
 			is low) and 1, if the device is ready (R/B pin is high).
 			If the hardware interface does not give access to the ready busy pin, then
diff --git a/Documentation/cgroups/cgroup_event_listener.c b/Documentation/cgroups/cgroup_event_listener.c
index 8c2bfc4..3e082f9 100644
--- a/Documentation/cgroups/cgroup_event_listener.c
+++ b/Documentation/cgroups/cgroup_event_listener.c
@@ -91,7 +91,7 @@ int main(int argc, char **argv)
 
 		if (ret == -1) {
 			perror("cgroup.event_control "
-					"is not accessable any more");
+					"is not accessible any more");
 			break;
 		}
 
diff --git a/Documentation/kvm/api.txt b/Documentation/kvm/api.txt
index b336266..50713e3 100644
--- a/Documentation/kvm/api.txt
+++ b/Documentation/kvm/api.txt
@@ -874,7 +874,7 @@ Possible values are:
  - KVM_MP_STATE_HALTED:          the vcpu has executed a HLT instruction and
                                  is waiting for an interrupt
  - KVM_MP_STATE_SIPI_RECEIVED:   the vcpu has just received a SIPI (vector
-                                 accesible via KVM_GET_VCPU_EVENTS)
+                                 accessible via KVM_GET_VCPU_EVENTS)
 
 This ioctl is only useful after KVM_CREATE_IRQCHIP.  Without an in-kernel
 irqchip, the multiprocessing state must be maintained by userspace.
diff --git a/arch/arm/mach-at91/board-ecbat91.c b/arch/arm/mach-at91/board-ecbat91.c
index 7b58c94..de2fd04 100644
--- a/arch/arm/mach-at91/board-ecbat91.c
+++ b/arch/arm/mach-at91/board-ecbat91.c
@@ -128,17 +128,17 @@ static struct spi_board_info __initdata ecb_at91spi_devices[] = {
 		.platform_data	= &my_flash0_platform,
 #endif
 	},
-	{	/* User accessable spi - cs1 (250KHz) */
+	{	/* User accessible spi - cs1 (250KHz) */
 		.modalias	= "spi-cs1",
 		.chip_select	= 1,
 		.max_speed_hz	= 250 * 1000,
 	},
-	{	/* User accessable spi - cs2 (1MHz) */
+	{	/* User accessible spi - cs2 (1MHz) */
 		.modalias	= "spi-cs2",
 		.chip_select	= 2,
 		.max_speed_hz	= 1 * 1000 * 1000,
 	},
-	{	/* User accessable spi - cs3 (10MHz) */
+	{	/* User accessible spi - cs3 (10MHz) */
 		.modalias	= "spi-cs3",
 		.chip_select	= 3,
 		.max_speed_hz	= 10 * 1000 * 1000,
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index d36b610..7f8d15d 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -153,7 +153,7 @@ __msm_ioremap(unsigned long phys_addr, size_t size, unsigned int mtype)
 {
 	if (mtype == MT_DEVICE) {
 		/* The peripherals in the 88000000 - D0000000 range
-		 * are only accessable by type MT_DEVICE_NONSHARED.
+		 * are only accessible by type MT_DEVICE_NONSHARED.
 		 * Adjust mtype as necessary to make this "just work."
 		 */
 		if ((phys_addr >= 0x88000000) && (phys_addr < 0xD0000000))
diff --git a/arch/cris/include/asm/etraxgpio.h b/arch/cris/include/asm/etraxgpio.h
index d474818..461c089 100644
--- a/arch/cris/include/asm/etraxgpio.h
+++ b/arch/cris/include/asm/etraxgpio.h
@@ -1,5 +1,5 @@
 /*
- * The following devices are accessable using this driver using
+ * The following devices are accessible using this driver using
  * GPIO_MAJOR (120) and a couple of minor numbers.
  *
  * For ETRAX 100LX (CONFIG_ETRAX_ARCH_V10):
diff --git a/arch/ia64/kvm/mmio.c b/arch/ia64/kvm/mmio.c
index fb8f9f5..f1e17d3 100644
--- a/arch/ia64/kvm/mmio.c
+++ b/arch/ia64/kvm/mmio.c
@@ -130,7 +130,7 @@ static void mmio_access(struct kvm_vcpu *vcpu, u64 src_pa, u64 *dest,
 
 	local_irq_save(psr);
 
-	/*Intercept the acces for PIB range*/
+	/*Intercept the access for PIB range*/
 	if (iot == GPFN_PIB) {
 		if (!dir)
 			lsapic_write(vcpu, src_pa, s, *dest);
diff --git a/arch/mips/alchemy/common/power.c b/arch/mips/alchemy/common/power.c
index e5916a5..647e518 100644
--- a/arch/mips/alchemy/common/power.c
+++ b/arch/mips/alchemy/common/power.c
@@ -130,7 +130,7 @@ static void restore_core_regs(void)
 	au_writel(sleep_usb[1], USBD_ENABLE);
 	au_sync();
 #else
-	/* enable accces to OTG memory */
+	/* enable access to OTG memory */
 	au_writel(au_readl(USB_MSR_BASE + 4) | (1 << 6), USB_MSR_BASE + 4);
 	au_sync();
 
diff --git a/arch/powerpc/platforms/83xx/suspend-asm.S b/arch/powerpc/platforms/83xx/suspend-asm.S
index 1930543..3d1ecd21 100644
--- a/arch/powerpc/platforms/83xx/suspend-asm.S
+++ b/arch/powerpc/platforms/83xx/suspend-asm.S
@@ -231,7 +231,7 @@ _GLOBAL(mpc83xx_enter_deep_sleep)
 	ori	r4, r4, 0x002a
 	mtspr	SPRN_DBAT0L, r4
 	lis	r8, TMP_VIRT_IMMR@h
-	ori	r4, r8, 0x001e	/* 1 MByte accessable from Kernel Space only */
+	ori	r4, r8, 0x001e	/* 1 MByte accessible from Kernel Space only */
 	mtspr	SPRN_DBAT0U, r4
 	isync
 
@@ -241,7 +241,7 @@ _GLOBAL(mpc83xx_enter_deep_sleep)
 	ori	r4, r4, 0x002a
 	mtspr	SPRN_DBAT1L, r4
 	lis	r9, (TMP_VIRT_IMMR + 0x01000000)@h
-	ori	r4, r9, 0x001e	/* 1 MByte accessable from Kernel Space only */
+	ori	r4, r9, 0x001e	/* 1 MByte accessible from Kernel Space only */
 	mtspr	SPRN_DBAT1U, r4
 	isync
 
@@ -253,7 +253,7 @@ _GLOBAL(mpc83xx_enter_deep_sleep)
 	li	r4, 0x0002
 	mtspr	SPRN_DBAT2L, r4
 	lis	r4, KERNELBASE@h
-	ori	r4, r4, 0x001e	/* 1 MByte accessable from Kernel Space only */
+	ori	r4, r4, 0x001e	/* 1 MByte accessible from Kernel Space only */
 	mtspr	SPRN_DBAT2U, r4
 	isync
 
diff --git a/arch/powerpc/platforms/ps3/device-init.c b/arch/powerpc/platforms/ps3/device-init.c
index b341018..6c4b583 100644
--- a/arch/powerpc/platforms/ps3/device-init.c
+++ b/arch/powerpc/platforms/ps3/device-init.c
@@ -566,10 +566,10 @@ static int ps3_setup_dynamic_device(const struct ps3_repository_device *repo)
 	case PS3_DEV_TYPE_STOR_DISK:
 		result = ps3_setup_storage_dev(repo, PS3_MATCH_ID_STOR_DISK);
 
-		/* Some devices are not accessable from the Other OS lpar. */
+		/* Some devices are not accessible from the Other OS lpar. */
 		if (result == -ENODEV) {
 			result = 0;
-			pr_debug("%s:%u: not accessable\n", __func__,
+			pr_debug("%s:%u: not accessible\n", __func__,
 				 __LINE__);
 		}
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index cae9c3c..c3e6d9a 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -902,7 +902,7 @@ extern unsigned long thread_saved_pc(struct task_struct *tsk);
 /*
  * The below -8 is to reserve 8 bytes on top of the ring0 stack.
  * This is necessary to guarantee that the entire "struct pt_regs"
- * is accessable even if the CPU haven't stored the SS/ESP registers
+ * is accessible even if the CPU haven't stored the SS/ESP registers
  * on the stack (interrupt gate does not save these registers
  * when switching to the same priv ring).
  * Therefore beware: accessing the ss/esp fields of the
diff --git a/arch/x86/kernel/early_printk_mrst.c b/arch/x86/kernel/early_printk_mrst.c
index 65df603..25bfdbb 100644
--- a/arch/x86/kernel/early_printk_mrst.c
+++ b/arch/x86/kernel/early_printk_mrst.c
@@ -103,7 +103,7 @@ struct dw_spi_reg {
 static unsigned long mrst_spi_paddr = MRST_REGBASE_SPI0;
 
 static u32 *pclk_spi0;
-/* Always contains an accessable address, start with 0 */
+/* Always contains an accessible address, start with 0 */
 static struct dw_spi_reg *pspi;
 
 static struct kmsg_dumper dw_dumper;
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 7f77c67..5b0295a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2240,7 +2240,7 @@ int ata_dev_configure(struct ata_device *dev)
 			if (id[ATA_ID_CFA_KEY_MGMT] & 1)
 				ata_dev_printk(dev, KERN_WARNING,
 					       "supports DRM functions and may "
-					       "not be fully accessable.\n");
+					       "not be fully accessible.\n");
 			snprintf(revbuf, 7, "CFA");
 		} else {
 			snprintf(revbuf, 7, "ATA-%d", ata_id_major_version(id));
@@ -2248,7 +2248,7 @@ int ata_dev_configure(struct ata_device *dev)
 			if (ata_id_has_tpm(id))
 				ata_dev_printk(dev, KERN_WARNING,
 					       "supports DRM functions and may "
-					       "not be fully accessable.\n");
+					       "not be fully accessible.\n");
 		}
 
 		dev->n_sectors = ata_id_n_sectors(id);
diff --git a/drivers/infiniband/hw/cxgb3/cxio_wr.h b/drivers/infiniband/hw/cxgb3/cxio_wr.h
index 4bb997a..83d2e19 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_wr.h
+++ b/drivers/infiniband/hw/cxgb3/cxio_wr.h
@@ -689,7 +689,7 @@ struct t3_swrq {
  * A T3 WQ implements both the SQ and RQ.
  */
 struct t3_wq {
-	union t3_wr *queue;		/* DMA accessable memory */
+	union t3_wr *queue;		/* DMA accessible memory */
 	dma_addr_t dma_addr;		/* DMA address for HW */
 	DEFINE_DMA_UNMAP_ADDR(mapping); /* unmap kruft */
 	u32 error;			/* 1 once we go to ERROR */
diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 584d443..ead2627 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -314,7 +314,7 @@ MODULE_PARM_DESC(txselect, \
 #define krp_serdesctrl KREG_IBPORT_IDX(IBSerdesCtrl)
 
 /*
- * Per-context kernel registers.  Acess only with qib_read_kreg_ctxt()
+ * Per-context kernel registers.  Access only with qib_read_kreg_ctxt()
  * or qib_write_kreg_ctxt()
  */
 #define krc_rcvhdraddr KREG_IDX(RcvHdrAddr0)
diff --git a/drivers/isdn/hardware/mISDN/ipac.h b/drivers/isdn/hardware/mISDN/ipac.h
index 74a6ccf..8121e04 100644
--- a/drivers/isdn/hardware/mISDN/ipac.h
+++ b/drivers/isdn/hardware/mISDN/ipac.h
@@ -29,7 +29,7 @@ struct isac_hw {
 	u32			type;
 	u32			off;		/* offset to isac regs */
 	char			*name;
-	spinlock_t		*hwlock;	/* lock HW acccess */
+	spinlock_t		*hwlock;	/* lock HW access */
 	read_reg_func		*read_reg;
 	write_reg_func		*write_reg;
 	fifo_func		*read_fifo;
@@ -70,7 +70,7 @@ struct ipac_hw {
 	struct hscx_hw		hscx[2];
 	char			*name;
 	void			*hw;
-	spinlock_t		*hwlock;	/* lock HW acccess */
+	spinlock_t		*hwlock;	/* lock HW access */
 	struct module		*owner;
 	u32			type;
 	read_reg_func		*read_reg;
diff --git a/drivers/isdn/hardware/mISDN/isar.h b/drivers/isdn/hardware/mISDN/isar.h
index 4a134ac..9962bdf 100644
--- a/drivers/isdn/hardware/mISDN/isar.h
+++ b/drivers/isdn/hardware/mISDN/isar.h
@@ -44,7 +44,7 @@ struct isar_ch {
 struct isar_hw {
 	struct	isar_ch	ch[2];
 	void		*hw;
-	spinlock_t	*hwlock;	/* lock HW acccess */
+	spinlock_t	*hwlock;	/* lock HW access */
 	char		*name;
 	struct module	*owner;
 	read_reg_func	*read_reg;
diff --git a/drivers/media/video/cx25840/cx25840-ir.c b/drivers/media/video/cx25840/cx25840-ir.c
index c2b4c14..610f91e 100644
--- a/drivers/media/video/cx25840/cx25840-ir.c
+++ b/drivers/media/video/cx25840/cx25840-ir.c
@@ -261,7 +261,7 @@ static u16 ns_to_pulse_width_count(u32 ns, u16 divider)
 	u32 rem;
 
 	/*
-	 * The 2 lsb's of the pulse width timer count are not accessable, hence
+	 * The 2 lsb's of the pulse width timer count are not accessible, hence
 	 * the (1 << 2)
 	 */
 	n = ((u64) ns) * CX25840_IR_REFCLK_FREQ / 1000000; /* millicycles */
diff --git a/drivers/media/video/saa7164/saa7164-core.c b/drivers/media/video/saa7164/saa7164-core.c
index e1bac50..cdd8e34 100644
--- a/drivers/media/video/saa7164/saa7164-core.c
+++ b/drivers/media/video/saa7164/saa7164-core.c
@@ -653,8 +653,8 @@ static irqreturn_t saa7164_irq(int irq, void *dev_id)
 		goto out;
 	}
 
-	/* Check that the hardware is accessable. If the status bytes are
-	 * 0xFF then the device is not accessable, the the IRQ belongs
+	/* Check that the hardware is accessible. If the status bytes are
+	 * 0xFF then the device is not accessible, the the IRQ belongs
 	 * to another driver.
 	 * 4 x u32 interrupt registers.
 	 */
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index f87a9d4..ae7cad1 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -309,7 +309,7 @@ static inline void i2o_block_request_free(struct i2o_block_request *ireq)
  *	@ireq: I2O block request
  *	@mptr: message body pointer
  *
- *	Builds the SG list and map it to be accessable by the controller.
+ *	Builds the SG list and map it to be accessible by the controller.
  *
  *	Returns 0 on failure or 1 on success.
  */
diff --git a/drivers/net/e1000e/82571.c b/drivers/net/e1000e/82571.c
index ca663f1..364f17b 100644
--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -296,7 +296,7 @@ static s32 e1000_init_mac_params_82571(struct e1000_adapter *adapter)
 
 	/*
 	 * Ensure that the inter-port SWSM.SMBI lock bit is clear before
-	 * first NVM or PHY acess. This should be done for single-port
+	 * first NVM or PHY access. This should be done for single-port
 	 * devices, and for one port only on dual-port devices so that
 	 * for those devices we can still use the SMBI lock to synchronize
 	 * inter-port accesses to the PHY & NVM.
diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
index e3374d9..38c84ba 100644
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -321,7 +321,7 @@ static s32 e1000_init_phy_params_pchlan(struct e1000_hw *hw)
 	}
 
 	/*
-	 * Reset the PHY before any acccess to it.  Doing so, ensures that
+	 * Reset the PHY before any access to it.  Doing so, ensures that
 	 * the PHY is in a known good state before we read/write PHY registers.
 	 * The generic reset is sufficient here, because we haven't determined
 	 * the PHY type yet.
diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
index 2c8cc95..ec2c75d 100644
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -630,7 +630,7 @@ islpci_alloc_memory(islpci_private *priv)
 	printk(KERN_DEBUG "islpci_alloc_memory\n");
 #endif
 
-	/* remap the PCI device base address to accessable */
+	/* remap the PCI device base address to accessible */
 	if (!(priv->device_base =
 	      ioremap(pci_resource_start(priv->pdev, 0),
 		      ISL38XX_PCI_MEM_SIZE))) {
@@ -709,7 +709,7 @@ islpci_alloc_memory(islpci_private *priv)
 				   PCI_DMA_FROMDEVICE);
 		if (!priv->pci_map_rx_address[counter]) {
 			/* error mapping the buffer to device
-			   accessable memory address */
+			   accessible memory address */
 			printk(KERN_ERR "failed to map skb DMA'able\n");
 			goto out_free;
 		}
@@ -773,7 +773,7 @@ islpci_free_memory(islpci_private *priv)
 		priv->data_low_rx[counter] = NULL;
 	}
 
-	/* Free the acces control list and the WPA list */
+	/* Free the access control list and the WPA list */
 	prism54_acl_clean(&priv->acl);
 	prism54_wpa_bss_ie_clean(priv);
 	mgt_clean(priv);
diff --git a/drivers/net/wireless/prism54/islpci_eth.c b/drivers/net/wireless/prism54/islpci_eth.c
index 2fc52bc..d44f8e2 100644
--- a/drivers/net/wireless/prism54/islpci_eth.c
+++ b/drivers/net/wireless/prism54/islpci_eth.c
@@ -450,7 +450,7 @@ islpci_eth_receive(islpci_private *priv)
 				   MAX_FRAGMENT_SIZE_RX + 2,
 				   PCI_DMA_FROMDEVICE);
 		if (unlikely(!priv->pci_map_rx_address[index])) {
-			/* error mapping the buffer to device accessable memory address */
+			/* error mapping the buffer to device accessible memory address */
 			DEBUG(SHOW_ERROR_MESSAGES,
 			      "Error mapping DMA address\n");
 
diff --git a/drivers/s390/scsi/zfcp_cfdc.c b/drivers/s390/scsi/zfcp_cfdc.c
index d692e22..4c09d03 100644
--- a/drivers/s390/scsi/zfcp_cfdc.c
+++ b/drivers/s390/scsi/zfcp_cfdc.c
@@ -317,7 +317,7 @@ static void zfcp_act_eval_err(struct zfcp_adapter *adapter, u32 table)
 
 /**
  * zfcp_cfdc_port_denied - Process "access denied" for port
- * @port: The port where the acces has been denied
+ * @port: The port where the access has been denied
  * @qual: The FSF status qualifier for the access denied FSF status
  */
 void zfcp_cfdc_port_denied(struct zfcp_port *port,
diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 4e6245e..6034282 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -38,7 +38,7 @@
 
 
 /*
- * This supports acccess to SPI devices using normal userspace I/O calls.
+ * This supports access to SPI devices using normal userspace I/O calls.
  * Note that while traditional UNIX/POSIX I/O semantics are half duplex,
  * and often mask message boundaries, full SPI support requires full duplex
  * transfers.  There are several kinds of internal message boundaries to
diff --git a/drivers/video/sstfb.c b/drivers/video/sstfb.c
index dee64c3..2ab7041 100644
--- a/drivers/video/sstfb.c
+++ b/drivers/video/sstfb.c
@@ -536,7 +536,7 @@ static int sstfb_set_par(struct fb_info *info)
 	fbiinit2 = sst_read(FBIINIT2);
 	fbiinit3 = sst_read(FBIINIT3);
 
-	/* everything is reset. we enable fbiinit2/3 remap : dac acces ok */
+	/* everything is reset. we enable fbiinit2/3 remap : dac access ok */
 	pci_write_config_dword(sst_dev, PCI_INIT_ENABLE,
 	                       PCI_EN_INIT_WR | PCI_REMAP_DAC );
 
diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index f935fd6..4068c6c 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -434,7 +434,7 @@ static int ocfs2_read_locked_inode(struct inode *inode,
 	 * #1 and #2 can be simply solved by never taking the lock
 	 * here for system files (which are the only type we read
 	 * during mount). It's a heavier approach, but our main
-	 * concern is user-accesible files anyway.
+	 * concern is user-accessible files anyway.
 	 *
 	 * #3 works itself out because we'll eventually take the
 	 * cluster lock before trusting anything anyway.
diff --git a/lib/nlattr.c b/lib/nlattr.c
index c4706eb..18d158d 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -167,7 +167,7 @@ nla_policy_len(const struct nla_policy *p, int n)
  * @policy: validation policy
  *
  * Parses a stream of attributes and stores a pointer to each attribute in
- * the tb array accessable via the attribute type. Attributes with a type
+ * the tb array accessible via the attribute type. Attributes with a type
  * exceeding maxtype will be silently ignored for backwards compatibility
  * reasons. policy may be set to NULL if no validation is required.
  *
diff --git a/sound/isa/opl3sa2.c b/sound/isa/opl3sa2.c
index 265abcc..9b915e2 100644
--- a/sound/isa/opl3sa2.c
+++ b/sound/isa/opl3sa2.c
@@ -264,7 +264,7 @@ static int __devinit snd_opl3sa2_detect(struct snd_card *card)
 		snd_printd("OPL3-SA [0x%lx] detect (1) = 0x%x (0x%x)\n", port, tmp, tmp1);
 		return -ENODEV;
 	}
-	/* try if the MIC register is accesible */
+	/* try if the MIC register is accessible */
 	tmp = snd_opl3sa2_read(chip, OPL3SA2_MIC);
 	snd_opl3sa2_write(chip, OPL3SA2_MIC, 0x8a);
 	if (((tmp1 = snd_opl3sa2_read(chip, OPL3SA2_MIC)) & 0x9f) != 0x8a) {
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index 0c98ef9..dc4402d 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -487,7 +487,7 @@ struct hdspm {
 	struct snd_kcontrol *playback_mixer_ctls[HDSPM_MAX_CHANNELS];
 	/* but input to much, so not used */
 	struct snd_kcontrol *input_mixer_ctls[HDSPM_MAX_CHANNELS];
-	/* full mixer accessable over mixer ioctl or hwdep-device */
+	/* full mixer accessible over mixer ioctl or hwdep-device */
 	struct hdspm_mixer *mixer;
 
 };
@@ -2908,7 +2908,7 @@ static int snd_hdspm_create_controls(struct snd_card *card, struct hdspm * hdspm
 
 	/* Channel playback mixer as default control 
 	   Note: the whole matrix would be 128*HDSPM_MIXER_CHANNELS Faders,
-	   thats too * big for any alsamixer they are accesible via special
+	   thats too * big for any alsamixer they are accessible via special
 	   IOCTL on hwdep and the mixer 2dimensional mixer control
 	*/
 
-- 
1.7.2.3

