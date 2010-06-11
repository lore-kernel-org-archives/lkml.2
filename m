Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191Ab0FKKSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:18:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37031 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760154Ab0FKKRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:17:23 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/10] trivial: fix typos concerning "initiali[zs]e"
Date: Fri, 11 Jun 2010 12:17:00 +0200
Message-Id: <1276251424-12806-6-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100611101624.GD10894@pengutronix.de>
References: <20100611101624.GD10894@pengutronix.de>
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
 arch/arm/mach-msm/acpuclock-arm11.c      |    4 ++--
 arch/arm/mach-u300/gpio.c                |    2 +-
 arch/arm/plat-s3c24xx/clock.c            |    2 +-
 arch/arm/plat-samsung/clock.c            |    2 +-
 arch/h8300/kernel/timer/itu.c            |    2 +-
 arch/h8300/kernel/timer/timer16.c        |    2 +-
 arch/h8300/kernel/timer/timer8.c         |    2 +-
 arch/ia64/kvm/kvm-ia64.c                 |    6 +++---
 arch/ia64/sn/kernel/setup.c              |    2 +-
 arch/sparc/boot/btfixupprep.c            |    4 ++--
 arch/x86/kernel/apic/apic.c              |    2 +-
 arch/x86/kernel/head32.c                 |    2 +-
 drivers/crypto/amcc/crypto4xx_reg_def.h  |    2 +-
 drivers/dma/at_hdmac.c                   |    2 +-
 drivers/gpu/drm/savage/savage_bci.c      |    2 +-
 drivers/ide/ide-gd.c                     |    2 +-
 drivers/infiniband/hw/ehca/hcp_if.h      |    2 +-
 drivers/input/misc/ad714x.c              |    2 +-
 drivers/media/video/ov511.c              |    2 +-
 drivers/media/video/zoran/zoran.h        |    2 +-
 drivers/media/video/zoran/zr36050.c      |    2 +-
 drivers/media/video/zoran/zr36060.c      |    2 +-
 drivers/message/fusion/mptbase.c         |    4 ++--
 drivers/mtd/nand/denali.c                |    2 +-
 drivers/net/3c527.c                      |    4 ++--
 drivers/net/appletalk/ipddp.c            |    2 +-
 drivers/net/hp100.c                      |    2 +-
 drivers/net/ibm_newemac/core.c           |    2 +-
 drivers/net/ksz884x.c                    |    2 +-
 drivers/net/ll_temac_main.c              |    2 +-
 drivers/net/tulip/dmfe.c                 |   20 ++++++++++----------
 drivers/net/wimax/i2400m/control.c       |    2 +-
 drivers/parisc/ccio-dma.c                |    4 ++--
 drivers/pcmcia/sa11xx_base.c             |    2 +-
 drivers/scsi/advansys.c                  |    2 +-
 drivers/scsi/aic94xx/aic94xx_seq.c       |    4 ++--
 drivers/scsi/bfa/vport.c                 |    2 +-
 drivers/scsi/pm8001/pm8001_hwi.c         |    2 +-
 drivers/scsi/qla4xxx/ql4_init.c          |    2 +-
 drivers/serial/sn_console.c              |    6 +++---
 drivers/staging/comedi/drivers/usbdux.c  |    2 +-
 drivers/staging/octeon/cvmx-cmd-queue.c  |    6 +++---
 drivers/staging/pohmelfs/inode.c         |    2 +-
 drivers/staging/rt2860/common/cmm_wpa.c  |    4 ++--
 drivers/staging/rtl8192e/r8190_rtl8256.c |    6 +++---
 drivers/usb/serial/kl5kusb105.c          |    2 +-
 drivers/usb/wusbcore/wusbhc.c            |    2 +-
 drivers/uwb/wlp/wss-lc.c                 |    2 +-
 drivers/video/carminefb.c                |    2 +-
 drivers/video/tgafb.c                    |    2 +-
 fs/befs/linuxvfs.c                       |    2 +-
 fs/ecryptfs/crypto.c                     |    2 +-
 fs/ext4/extents.c                        |    2 +-
 fs/ext4/super.c                          |    2 +-
 fs/freevxfs/vxfs_super.c                 |    2 +-
 fs/ocfs2/super.c                         |    2 +-
 fs/reiserfs/inode.c                      |    2 +-
 lib/random32.c                           |    2 +-
 net/netfilter/ipvs/ip_vs_lblc.c          |    2 +-
 net/netfilter/ipvs/ip_vs_lblcr.c         |    2 +-
 net/sctp/associola.c                     |    2 +-
 net/sctp/protocol.c                      |    2 +-
 security/smack/smack_lsm.c               |    2 +-
 sound/pci/trident/trident_main.c         |    2 +-
 sound/soc/fsl/mpc8610_hpcd.c             |    2 +-
 sound/soc/soc-core.c                     |    2 +-
 66 files changed, 90 insertions(+), 90 deletions(-)

diff --git a/arch/arm/mach-msm/acpuclock-arm11.c b/arch/arm/mach-msm/acpuclock-arm11.c
index af5e85b..f060a39 100644
--- a/arch/arm/mach-msm/acpuclock-arm11.c
+++ b/arch/arm/mach-msm/acpuclock-arm11.c
@@ -98,7 +98,7 @@ struct clkctl_acpu_speed {
 
 /*
  * ACPU speed table. Complete table is shown but certain speeds are commented
- * out to optimized speed switching. Initalize loops_per_jiffy to 0.
+ * out to optimized speed switching. Initialize loops_per_jiffy to 0.
  *
  * Table stepping up/down is optimized for 256mhz jumps while staying on the
  * same PLL.
@@ -494,7 +494,7 @@ uint32_t acpuclk_get_switch_time(void)
  * Clock driver initialization
  *---------------------------------------------------------------------------*/
 
-/* Initalize the lpj field in the acpu_freq_tbl. */
+/* Initialize the lpj field in the acpu_freq_tbl. */
 static void __init lpj_init(void)
 {
 	int i;
diff --git a/arch/arm/mach-u300/gpio.c b/arch/arm/mach-u300/gpio.c
index 5f61fd4..d927901 100644
--- a/arch/arm/mach-u300/gpio.c
+++ b/arch/arm/mach-u300/gpio.c
@@ -523,7 +523,7 @@ static void gpio_set_initial_values(void)
 
 	/*
 	 * Put all pins that are set to either 'GPIO_OUT' or 'GPIO_NOT_USED'
-	 * to output and 'GPIO_IN' to input for each port. And initalize
+	 * to output and 'GPIO_IN' to input for each port. And initialize
 	 * default value on outputs.
 	 */
 	for (i = 0; i < U300_GPIO_NUM_PORTS; i++) {
diff --git a/arch/arm/plat-s3c24xx/clock.c b/arch/arm/plat-s3c24xx/clock.c
index 8474d05..931d26d 100644
--- a/arch/arm/plat-s3c24xx/clock.c
+++ b/arch/arm/plat-s3c24xx/clock.c
@@ -43,7 +43,7 @@
 #include <plat/cpu.h>
 #include <plat/pll.h>
 
-/* initalise all the clocks */
+/* initialise all the clocks */
 
 void __init_or_cpufreq s3c24xx_setup_clocks(unsigned long fclk,
 					   unsigned long hclk,
diff --git a/arch/arm/plat-samsung/clock.c b/arch/arm/plat-samsung/clock.c
index 8bf79f3..90a2051 100644
--- a/arch/arm/plat-samsung/clock.c
+++ b/arch/arm/plat-samsung/clock.c
@@ -391,7 +391,7 @@ void __init s3c_disable_clocks(struct clk *clkp, int nr_clks)
 		(clkp->enable)(clkp, 0);
 }
 
-/* initalise all the clocks */
+/* initialise all the clocks */
 
 int __init s3c24xx_register_baseclocks(unsigned long xtal)
 {
diff --git a/arch/h8300/kernel/timer/itu.c b/arch/h8300/kernel/timer/itu.c
index 4883ba7..a2ae5e9 100644
--- a/arch/h8300/kernel/timer/itu.c
+++ b/arch/h8300/kernel/timer/itu.c
@@ -73,7 +73,7 @@ void __init h8300_timer_setup(void)
 
 	setup_irq(ITUIRQ, &itu_irq);
 
-	/* initalize timer */
+	/* initialize timer */
 	ctrl_outb(0, TSTR);
 	ctrl_outb(CCLR0 | div, ITUBASE + TCR);
 	ctrl_outb(0x01, ITUBASE + TIER);
diff --git a/arch/h8300/kernel/timer/timer16.c b/arch/h8300/kernel/timer/timer16.c
index 042dbb5..ae0d381 100644
--- a/arch/h8300/kernel/timer/timer16.c
+++ b/arch/h8300/kernel/timer/timer16.c
@@ -68,7 +68,7 @@ void __init h8300_timer_setup(void)
 
 	setup_irq(_16IRQ, &timer16_irq);
 
-	/* initalize timer */
+	/* initialize timer */
 	ctrl_outb(0, TSTR);
 	ctrl_outb(CCLR0 | div, _16BASE + TCR);
 	ctrl_outw(cnt, _16BASE + GRA);
diff --git a/arch/h8300/kernel/timer/timer8.c b/arch/h8300/kernel/timer/timer8.c
index 38be0ca..3946c0f 100644
--- a/arch/h8300/kernel/timer/timer8.c
+++ b/arch/h8300/kernel/timer/timer8.c
@@ -94,7 +94,7 @@ void __init h8300_timer_setup(void)
 	ctrl_bclr(0, MSTPCRL)
 #endif
 
-	/* initalize timer */
+	/* initialize timer */
 	ctrl_outw(cnt, _8BASE + TCORA);
 	ctrl_outw(0x0000, _8BASE + _8TCSR);
 	ctrl_outw((CMIEA|CCLR_CMA|CKS2) << 8 | div,
diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index 21b7013..9b109f2 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -1237,7 +1237,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	p_ctx->cr[2] = (unsigned long)kvm_vmm_info->vmm_ivt;
 	p_ctx->cr[8] = 0x3c;
 
-	/*Initilize region register*/
+	/*Initialize region register*/
 	p_ctx->rr[0] = 0x30;
 	p_ctx->rr[1] = 0x30;
 	p_ctx->rr[2] = 0x30;
@@ -1246,7 +1246,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	p_ctx->rr[5] = 0x30;
 	p_ctx->rr[7] = 0x30;
 
-	/*Initilize branch register 0*/
+	/*Initialize branch register 0*/
 	p_ctx->br[0] = *(unsigned long *)kvm_vmm_info->vmm_entry;
 
 	vcpu->arch.vmm_rr = kvm->arch.vmm_init_rr;
@@ -1707,7 +1707,7 @@ static int kvm_relocate_vmm(struct kvm_vmm_info *vmm_info,
 	BUG_ON(!module);
 
 	if (!kvm_vmm_base) {
-		printk("kvm: kvm area hasn't been initilized yet!!\n");
+		printk("kvm: kvm area hasn't been initialized yet!!\n");
 		return -EFAULT;
 	}
 
diff --git a/arch/ia64/sn/kernel/setup.c b/arch/ia64/sn/kernel/setup.c
index d00dfc1..dbc4cbe 100644
--- a/arch/ia64/sn/kernel/setup.c
+++ b/arch/ia64/sn/kernel/setup.c
@@ -507,7 +507,7 @@ static void __init sn_init_pdas(char **cmdline_p)
 	cnodeid_t cnode;
 
 	/*
-	 * Allocate & initalize the nodepda for each node.
+	 * Allocate & initialize the nodepda for each node.
 	 */
 	for_each_online_node(cnode) {
 		nodepdaindr[cnode] =
diff --git a/arch/sparc/boot/btfixupprep.c b/arch/sparc/boot/btfixupprep.c
index e7f2940..da03115 100644
--- a/arch/sparc/boot/btfixupprep.c
+++ b/arch/sparc/boot/btfixupprep.c
@@ -216,7 +216,7 @@ main1:
 		switch (buffer[nbase+3]) {
 		case 'f':
 			if (initval) {
-				fprintf(stderr, "Cannot use pre-initalized fixups for calls\n%s\n", buffer);
+				fprintf(stderr, "Cannot use pre-initialized fixups for calls\n%s\n", buffer);
 				exit(1);
 			}
 			if (!strcmp (sect, "__ksymtab")) {
@@ -273,7 +273,7 @@ main1:
 			break;
 		case 'i':
 			if (initval) {
-				fprintf(stderr, "Cannot use pre-initalized fixups for INT\n%s\n", buffer);
+				fprintf(stderr, "Cannot use pre-initialized fixups for INT\n%s\n", buffer);
 				exit(1);
 			}
 			if (strncmp (buffer + mode+9, "HI22      ", 10) && strncmp (buffer + mode+9, "LO10      ", 10)) {
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index c02cc69..0bcc5ae 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -460,7 +460,7 @@ static void lapic_timer_broadcast(const struct cpumask *mask)
 }
 
 /*
- * Setup the local APIC timer for this CPU. Copy the initilized values
+ * Setup the local APIC timer for this CPU. Copy the initialized values
  * of the boot CPU and register the clock event in the framework.
  */
 static void __cpuinit setup_APIC_timer(void)
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index b2e2460..784360c 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -20,7 +20,7 @@
 
 static void __init i386_default_early_setup(void)
 {
-	/* Initilize 32bit specific setup functions */
+	/* Initialize 32bit specific setup functions */
 	x86_init.resources.probe_roms = probe_roms;
 	x86_init.resources.reserve_resources = i386_reserve_resources;
 	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc;
diff --git a/drivers/crypto/amcc/crypto4xx_reg_def.h b/drivers/crypto/amcc/crypto4xx_reg_def.h
index 7d4edb0..5f5fbc0 100644
--- a/drivers/crypto/amcc/crypto4xx_reg_def.h
+++ b/drivers/crypto/amcc/crypto4xx_reg_def.h
@@ -113,7 +113,7 @@
 #define CRYPTO4XX_PRNG_LFSR_H			0x00070034
 
 /**
- * Initilize CRYPTO ENGINE registers, and memory bases.
+ * Initialize CRYPTO ENGINE registers, and memory bases.
  */
 #define PPC4XX_PDR_POLL				0x3ff
 #define PPC4XX_OUTPUT_THRESHOLD			2
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index bd5250e..e880760 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -69,7 +69,7 @@ static struct at_desc *atc_first_queued(struct at_dma_chan *atchan)
 }
 
 /**
- * atc_alloc_descriptor - allocate and return an initilized descriptor
+ * atc_alloc_descriptor - allocate and return an initialized descriptor
  * @chan: the channel to allocate descriptors for
  * @gfp_flags: GFP allocation flags
  *
diff --git a/drivers/gpu/drm/savage/savage_bci.c b/drivers/gpu/drm/savage/savage_bci.c
index 2d0c9ca..fa05cda 100644
--- a/drivers/gpu/drm/savage/savage_bci.c
+++ b/drivers/gpu/drm/savage/savage_bci.c
@@ -552,7 +552,7 @@ int savage_driver_load(struct drm_device *dev, unsigned long chipset)
 
 
 /*
- * Initalize mappings. On Savage4 and SavageIX the alignment
+ * Initialize mappings. On Savage4 and SavageIX the alignment
  * and size of the aperture is not suitable for automatic MTRR setup
  * in drm_addmap. Therefore we add them manually before the maps are
  * initialized, and tear them down on last close.
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index c102d23..7939953 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -92,7 +92,7 @@ static void ide_disk_release(struct device *dev)
 
 /*
  * On HPA drives the capacity needs to be
- * reinitilized on resume otherwise the disk
+ * reinitialized on resume otherwise the disk
  * can not be used and a hard reset is required
  */
 static void ide_gd_resume(ide_drive_t *drive)
diff --git a/drivers/infiniband/hw/ehca/hcp_if.h b/drivers/infiniband/hw/ehca/hcp_if.h
index 39c1c36..a46e514 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.h
+++ b/drivers/infiniband/hw/ehca/hcp_if.h
@@ -49,7 +49,7 @@
 #include "hipz_hw.h"
 
 /*
- * hipz_h_alloc_resource_eq allocates EQ resources in HW and FW, initalize
+ * hipz_h_alloc_resource_eq allocates EQ resources in HW and FW, initialize
  * resources, create the empty EQPT (ring).
  */
 u64 hipz_h_alloc_resource_eq(const struct ipz_adapter_handle adapter_handle,
diff --git a/drivers/input/misc/ad714x.c b/drivers/input/misc/ad714x.c
index 0fe27ba..c431d09 100644
--- a/drivers/input/misc/ad714x.c
+++ b/drivers/input/misc/ad714x.c
@@ -1118,7 +1118,7 @@ struct ad714x_chip *ad714x_probe(struct device *dev, u16 bus_type, int irq,
 	if (error)
 		goto err_free_mem;
 
-	/* initilize and request sw/hw resources */
+	/* initialize and request sw/hw resources */
 
 	ad714x_hw_init(ad714x);
 	mutex_init(&ad714x->mutex);
diff --git a/drivers/media/video/ov511.c b/drivers/media/video/ov511.c
index a109120..78a6eb6 100644
--- a/drivers/media/video/ov511.c
+++ b/drivers/media/video/ov511.c
@@ -4808,7 +4808,7 @@ ov7xx0_configure(struct usb_ov511 *ov)
 		return -1;
 
 	if (init_ov_sensor(ov) >= 0) {
-		PDEBUG(1, "OV7xx0 sensor initalized (method 1)");
+		PDEBUG(1, "OV7xx0 sensor initialized (method 1)");
 	} else {
 		/* Reset the 76xx */
 		if (i2c_w(ov, 0x12, 0x80) < 0)
diff --git a/drivers/media/video/zoran/zoran.h b/drivers/media/video/zoran/zoran.h
index 8997add..307e847 100644
--- a/drivers/media/video/zoran/zoran.h
+++ b/drivers/media/video/zoran/zoran.h
@@ -391,7 +391,7 @@ struct zoran {
 
 	struct mutex resource_lock;	/* prevent evil stuff */
 
-	u8 initialized;		/* flag if zoran has been correctly initalized */
+	u8 initialized;		/* flag if zoran has been correctly initialized */
 	int user;		/* number of current users */
 	struct card_info card;
 	struct tvnorm *timing;
diff --git a/drivers/media/video/zoran/zr36050.c b/drivers/media/video/zoran/zr36050.c
index 639dd87..e198560 100644
--- a/drivers/media/video/zoran/zr36050.c
+++ b/drivers/media/video/zoran/zr36050.c
@@ -236,7 +236,7 @@ zr36050_pushit (struct zr36050 *ptr,
 
    Could be variable, but until it's not needed it they are just fixed to save
    memory. Otherwise expand zr36050 structure with arrays, push the values to
-   it and initalize from there, as e.g. the linux zr36057/60 driver does it.
+   it and initialize from there, as e.g. the linux zr36057/60 driver does it.
    ========================================================================= */
 
 static const char zr36050_dqt[0x86] = {
diff --git a/drivers/media/video/zoran/zr36060.c b/drivers/media/video/zoran/zr36060.c
index 008746f..5e4f57c 100644
--- a/drivers/media/video/zoran/zr36060.c
+++ b/drivers/media/video/zoran/zr36060.c
@@ -227,7 +227,7 @@ zr36060_pushit (struct zr36060 *ptr,
 
    Could be variable, but until it's not needed it they are just fixed to save
    memory. Otherwise expand zr36060 structure with arrays, push the values to
-   it and initalize from there, as e.g. the linux zr36057/60 driver does it.
+   it and initialize from there, as e.g. the linux zr36057/60 driver does it.
    ========================================================================= */
 
 static const char zr36060_dqt[0x86] = {
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index a6a5701..14d162f 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1794,7 +1794,7 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->sh = NULL;
 	ioc->cached_fw = NULL;
 
-	/* Initilize SCSI Config Data structure
+	/* Initialize SCSI Config Data structure
 	 */
 	memset(&ioc->spi_data, 0, sizeof(SpiCfgData));
 
@@ -2471,7 +2471,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u32 reason, int sleepFlag)
 	if ((ret == 0) && (reason == MPT_HOSTEVENT_IOC_BRINGUP)) {
 
 		/*
-		 * Initalize link list for inactive raid volumes.
+		 * Initialize link list for inactive raid volumes.
 		 */
 		mutex_init(&ioc->raid_data.inactive_list_mutex);
 		INIT_LIST_HEAD(&ioc->raid_data.inactive_list);
diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
index ca03428..3dfda9c 100644
--- a/drivers/mtd/nand/denali.c
+++ b/drivers/mtd/nand/denali.c
@@ -1836,7 +1836,7 @@ static struct nand_bbt_descr bbt_mirror_descr = {
 	.pattern = mirror_pattern,
 };
 
-/* initalize driver data structures */
+/* initialize driver data structures */
 void denali_drv_init(struct denali_nand_info *denali)
 {
 	denali->idx = 0;
diff --git a/drivers/net/3c527.c b/drivers/net/3c527.c
index 38395df..70705d1 100644
--- a/drivers/net/3c527.c
+++ b/drivers/net/3c527.c
@@ -729,14 +729,14 @@ static void mc32_halt_transceiver(struct net_device *dev)
  *	mc32_load_rx_ring	-	load the ring of receive buffers
  *	@dev: 3c527 to build the ring for
  *
- *	This initalises the on-card and driver datastructures to
+ *	This initialises the on-card and driver datastructures to
  *	the point where mc32_start_transceiver() can be called.
  *
  *	The card sets up the receive ring for us. We are required to use the
  *	ring it provides, although the size of the ring is configurable.
  *
  * 	We allocate an sk_buff for each ring entry in turn and
- * 	initalise its house-keeping info. At the same time, we read
+ * 	initialise its house-keeping info. At the same time, we read
  * 	each 'next' pointer in our rx_ring array. This reduces slow
  * 	shared-memory reads and makes it easy to access predecessor
  * 	descriptors.
diff --git a/drivers/net/appletalk/ipddp.c b/drivers/net/appletalk/ipddp.c
index 79636ee..0362c8d 100644
--- a/drivers/net/appletalk/ipddp.c
+++ b/drivers/net/appletalk/ipddp.c
@@ -80,7 +80,7 @@ static struct net_device * __init ipddp_init(void)
 	if (version_printed++ == 0)
                 printk(version);
 
-	/* Initalize the device structure. */
+	/* Initialize the device structure. */
 	dev->netdev_ops = &ipddp_netdev_ops;
 
         dev->type = ARPHRD_IPDDP;       	/* IP over DDP tunnel */
diff --git a/drivers/net/hp100.c b/drivers/net/hp100.c
index 68e5ac8..dfc787f 100644
--- a/drivers/net/hp100.c
+++ b/drivers/net/hp100.c
@@ -1071,7 +1071,7 @@ static void hp100_mmuinit(struct net_device *dev)
 	if (lp->mode == 1)
 		hp100_init_pdls(dev);
 
-	/* Go to performance page and initalize isr and imr registers */
+	/* Go to performance page and initialize isr and imr registers */
 	hp100_page(PERFORMANCE);
 	hp100_outw(0xfefe, IRQ_MASK);	/* mask off all ints */
 	hp100_outw(0xffff, IRQ_STATUS);	/* ack IRQ */
diff --git a/drivers/net/ibm_newemac/core.c b/drivers/net/ibm_newemac/core.c
index b150c10..0f1d4e9 100644
--- a/drivers/net/ibm_newemac/core.c
+++ b/drivers/net/ibm_newemac/core.c
@@ -1045,7 +1045,7 @@ static int emac_change_mtu(struct net_device *ndev, int new_mtu)
 	DBG(dev, "change_mtu(%d)" NL, new_mtu);
 
 	if (netif_running(ndev)) {
-		/* Check if we really need to reinitalize RX ring */
+		/* Check if we really need to reinitialize RX ring */
 		if (emac_rx_skb_size(ndev->mtu) != emac_rx_skb_size(new_mtu))
 			ret = emac_resize_rx_ring(dev, new_mtu);
 	}
diff --git a/drivers/net/ksz884x.c b/drivers/net/ksz884x.c
index 7805bbf..aa50ee1 100644
--- a/drivers/net/ksz884x.c
+++ b/drivers/net/ksz884x.c
@@ -6812,7 +6812,7 @@ static int stp;
 static int fast_aging;
 
 /**
- * netdev_init - initalize network device.
+ * netdev_init - initialize network device.
  * @dev:	Network device.
  *
  * This function initializes the network device.
diff --git a/drivers/net/ll_temac_main.c b/drivers/net/ll_temac_main.c
index 52dcc84..315eb4c 100644
--- a/drivers/net/ll_temac_main.c
+++ b/drivers/net/ll_temac_main.c
@@ -449,7 +449,7 @@ static u32 temac_setoptions(struct net_device *ndev, u32 options)
 	return (0);
 }
 
-/* Initilize temac */
+/* Initialize temac */
 static void temac_device_reset(struct net_device *ndev)
 {
 	struct temac_local *lp = netdev_priv(ndev);
diff --git a/drivers/net/tulip/dmfe.c b/drivers/net/tulip/dmfe.c
index 29e6c63..0bc4f30 100644
--- a/drivers/net/tulip/dmfe.c
+++ b/drivers/net/tulip/dmfe.c
@@ -589,7 +589,7 @@ static int dmfe_open(struct DEVICE *dev)
 		db->dm910x_chk_mode = 1;	/* Enter the check mode */
 	}
 
-	/* Initilize DM910X board */
+	/* Initialize DM910X board */
 	dmfe_init_dm910x(dev);
 
 	/* Active System Interface */
@@ -606,9 +606,9 @@ static int dmfe_open(struct DEVICE *dev)
 }
 
 
-/*	Initilize DM910X board
+/*	Initialize DM910X board
  *	Reset DM910X board
- *	Initilize TX/Rx descriptor chain structure
+ *	Initialize TX/Rx descriptor chain structure
  *	Send the set-up frame
  *	Enable Tx/Rx machine
  */
@@ -649,7 +649,7 @@ static void dmfe_init_dm910x(struct DEVICE *dev)
 	if ( !(db->media_mode & DMFE_AUTO) )
 		db->op_mode = db->media_mode; 	/* Force Mode */
 
-	/* Initiliaze Transmit/Receive decriptor and CR3/4 */
+	/* Initialize Transmit/Receive decriptor and CR3/4 */
 	dmfe_descriptor_init(db, ioaddr);
 
 	/* Init CR6 to program DM910x operation */
@@ -1288,7 +1288,7 @@ static void dmfe_timer(unsigned long data)
  *	Stop DM910X board
  *	Free Tx/Rx allocated memory
  *	Reset DM910X board
- *	Re-initilize DM910X board
+ *	Re-initialize DM910X board
  */
 
 static void dmfe_dynamic_reset(struct DEVICE *dev)
@@ -1316,7 +1316,7 @@ static void dmfe_dynamic_reset(struct DEVICE *dev)
 	netif_carrier_off(dev);
 	db->wait_reset = 0;
 
-	/* Re-initilize DM910X board */
+	/* Re-initialize DM910X board */
 	dmfe_init_dm910x(dev);
 
 	/* Restart upper layer interface */
@@ -1447,7 +1447,7 @@ static void update_cr6(u32 cr6_data, unsigned long ioaddr)
 
 /*
  *	Send a setup frame for DM9132
- *	This setup frame initilize DM910X address filter mode
+ *	This setup frame initialize DM910X address filter mode
 */
 
 static void dm9132_id_table(struct DEVICE *dev)
@@ -1489,7 +1489,7 @@ static void dm9132_id_table(struct DEVICE *dev)
 
 /*
  *	Send a setup frame for DM9102/DM9102A
- *	This setup frame initilize DM910X address filter mode
+ *	This setup frame initialize DM910X address filter mode
  */
 
 static void send_filter_frame(struct DEVICE *dev)
@@ -2142,7 +2142,7 @@ static int dmfe_resume(struct pci_dev *pci_dev)
 	pci_set_power_state(pci_dev, PCI_D0);
 	pci_restore_state(pci_dev);
 
-	/* Re-initilize DM910X board */
+	/* Re-initialize DM910X board */
 	dmfe_init_dm910x(dev);
 
 	/* Disable WOL */
@@ -2196,7 +2196,7 @@ MODULE_PARM_DESC(SF_mode, "Davicom DM9xxx special function "
 
 /*	Description:
  *	when user used insmod to add module, system invoked init_module()
- *	to initilize and register.
+ *	to initialize and register.
  */
 
 static int __init dmfe_init_module(void)
diff --git a/drivers/net/wimax/i2400m/control.c b/drivers/net/wimax/i2400m/control.c
index d86e8f3..7f48e04 100644
--- a/drivers/net/wimax/i2400m/control.c
+++ b/drivers/net/wimax/i2400m/control.c
@@ -50,7 +50,7 @@
  *
  * ROADMAP
  *
- * i2400m_dev_initalize()       Called by i2400m_dev_start()
+ * i2400m_dev_initialize()       Called by i2400m_dev_start()
  *   i2400m_set_init_config()
  *   i2400m_cmd_get_state()
  * i2400m_dev_shutdown()        Called by i2400m_dev_stop()
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index f511e70..75a80e4 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1241,10 +1241,10 @@ static struct parisc_driver ccio_driver = {
 };
 
 /**
- * ccio_ioc_init - Initalize the I/O Controller
+ * ccio_ioc_init - Initialize the I/O Controller
  * @ioc: The I/O Controller.
  *
- * Initalize the I/O Controller which includes setting up the
+ * Initialize the I/O Controller which includes setting up the
  * I/O Page Directory, the resource map, and initalizing the
  * U2/Uturn chip into virtual mode.
  */
diff --git a/drivers/pcmcia/sa11xx_base.c b/drivers/pcmcia/sa11xx_base.c
index fa28d89..0c62fe3 100644
--- a/drivers/pcmcia/sa11xx_base.c
+++ b/drivers/pcmcia/sa11xx_base.c
@@ -231,7 +231,7 @@ int sa11xx_drv_pcmcia_probe(struct device *dev, struct pcmcia_low_level *ops,
 
 	sinfo->nskt = nr;
 
-	/* Initiliaze processor specific parameters */
+	/* Initialize processor specific parameters */
 	for (i = 0; i < nr; i++) {
 		skt = &sinfo->skt[i];
 
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 7f87979..0ec3da6 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -9717,7 +9717,7 @@ static ushort __devinit AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 	asc_dvc->bug_fix_cntl = 0;
 	asc_dvc->pci_fix_asyn_xfer = 0;
 	asc_dvc->pci_fix_asyn_xfer_always = 0;
-	/* asc_dvc->init_state initalized in AscInitGetConfig(). */
+	/* asc_dvc->init_state initialized in AscInitGetConfig(). */
 	asc_dvc->sdtr_done = 0;
 	asc_dvc->cur_total_qng = 0;
 	asc_dvc->is_in_int = 0;
diff --git a/drivers/scsi/aic94xx/aic94xx_seq.c b/drivers/scsi/aic94xx/aic94xx_seq.c
index d01dcc6..7437461 100644
--- a/drivers/scsi/aic94xx/aic94xx_seq.c
+++ b/drivers/scsi/aic94xx/aic94xx_seq.c
@@ -588,7 +588,7 @@ static void asd_init_cseq_mdp(struct asd_ha_struct *asd_ha)
  * asd_init_cseq_scratch -- setup and init CSEQ
  * @asd_ha: pointer to host adapter structure
  *
- * Setup and initialize Central sequencers. Initialiaze the mode
+ * Setup and initialize Central sequencers. Initialize the mode
  * independent and dependent scratch page to the default settings.
  */
 static void asd_init_cseq_scratch(struct asd_ha_struct *asd_ha)
@@ -782,7 +782,7 @@ static void asd_init_lseq_mdp(struct asd_ha_struct *asd_ha,  int lseq)
 	asd_write_reg_word(asd_ha, LmSEQ_OOB_INT_ENABLES(lseq), 0);
 	/*
 	 * Set the desired interval between transmissions of the NOTIFY
-	 * (ENABLE SPINUP) primitive.  Must be initilized to val - 1.
+	 * (ENABLE SPINUP) primitive.  Must be initialized to val - 1.
 	 */
 	asd_write_reg_word(asd_ha, LmSEQ_NOTIFY_TIMER_TIMEOUT(lseq),
 			   ASD_NOTIFY_TIMEOUT - 1);
diff --git a/drivers/scsi/bfa/vport.c b/drivers/scsi/bfa/vport.c
index 27cd619..e2720c8 100644
--- a/drivers/scsi/bfa/vport.c
+++ b/drivers/scsi/bfa/vport.c
@@ -789,7 +789,7 @@ bfa_cb_lps_fdisc_comp(void *bfad, void *uarg, bfa_status_t status)
 	switch (status) {
 	case BFA_STATUS_OK:
 		/*
-		 * Initialiaze the V-Port fields
+		 * Initialize the V-Port fields
 		 */
 		__vport_fcid(vport) = bfa_lps_get_pid(vport->lps);
 		vport->vport_stats.fdisc_accepts++;
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 5ff8261..3b11fd8 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1082,7 +1082,7 @@ static void pm8001_hw_chip_rst(struct pm8001_hba_info *pm8001_ha)
 }
 
 /**
- * pm8001_chip_iounmap - which maped when initilized.
+ * pm8001_chip_iounmap - which maped when initialized.
  * @pm8001_ha: our hba card information
  */
 static void pm8001_chip_iounmap(struct pm8001_hba_info *pm8001_ha)
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 5510df8..cd30432 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -183,7 +183,7 @@ static int qla4xxx_validate_mac_address(struct scsi_qla_host *ha)
  **/
 static int qla4xxx_init_local_data(struct scsi_qla_host *ha)
 {
-	/* Initilize aen queue */
+	/* Initialize aen queue */
 	ha->aen_q_count = MAX_AEN_ENTRIES;
 
 	return qla4xxx_get_firmware_status(ha);
diff --git a/drivers/serial/sn_console.c b/drivers/serial/sn_console.c
index 9794e0c..7e5e5ef 100644
--- a/drivers/serial/sn_console.c
+++ b/drivers/serial/sn_console.c
@@ -470,7 +470,7 @@ sn_receive_chars(struct sn_cons_port *port, unsigned long flags)
 	}
 
 	if (port->sc_port.state) {
-		/* The serial_core stuffs are initilized, use them */
+		/* The serial_core stuffs are initialized, use them */
 		tty = port->sc_port.state->port.tty;
 	}
 	else {
@@ -551,11 +551,11 @@ static void sn_transmit_chars(struct sn_cons_port *port, int raw)
 	BUG_ON(!port->sc_is_asynch);
 
 	if (port->sc_port.state) {
-		/* We're initilized, using serial core infrastructure */
+		/* We're initialized, using serial core infrastructure */
 		xmit = &port->sc_port.state->xmit;
 	} else {
 		/* Probably sn_sal_switch_to_asynch has been run but serial core isn't
-		 * initilized yet.  Just return.  Writes are going through
+		 * initialized yet.  Just return.  Writes are going through
 		 * sn_sal_console_write (due to register_console) at this time.
 		 */
 		return;
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 27b4cb2..7b8a2da 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -2085,7 +2085,7 @@ static int usbdux_pwm_start(struct comedi_device *dev,
 	if (ret < 0)
 		return ret;
 
-	/* initalise the buffer */
+	/* initialise the buffer */
 	for (i = 0; i < this_usbduxsub->sizePwmBuf; i++)
 		((char *)(this_usbduxsub->urbPwm->transfer_buffer))[i] = 0;
 
diff --git a/drivers/staging/octeon/cvmx-cmd-queue.c b/drivers/staging/octeon/cvmx-cmd-queue.c
index 976227b..e9809d3 100644
--- a/drivers/staging/octeon/cvmx-cmd-queue.c
+++ b/drivers/staging/octeon/cvmx-cmd-queue.c
@@ -140,21 +140,21 @@ cvmx_cmd_queue_result_t cvmx_cmd_queue_initialize(cvmx_cmd_queue_id_t queue_id,
 	if (qstate->base_ptr_div128) {
 		if (max_depth != (int)qstate->max_depth) {
 			cvmx_dprintf("ERROR: cvmx_cmd_queue_initialize: "
-				"Queue already initalized with different "
+				"Queue already initialized with different "
 				"max_depth (%d).\n",
 			     (int)qstate->max_depth);
 			return CVMX_CMD_QUEUE_INVALID_PARAM;
 		}
 		if (fpa_pool != qstate->fpa_pool) {
 			cvmx_dprintf("ERROR: cvmx_cmd_queue_initialize: "
-				"Queue already initalized with different "
+				"Queue already initialized with different "
 				"FPA pool (%u).\n",
 			     qstate->fpa_pool);
 			return CVMX_CMD_QUEUE_INVALID_PARAM;
 		}
 		if ((pool_size >> 3) - 1 != qstate->pool_size_m1) {
 			cvmx_dprintf("ERROR: cvmx_cmd_queue_initialize: "
-				"Queue already initalized with different "
+				"Queue already initialized with different "
 				"FPA pool size (%u).\n",
 			     (qstate->pool_size_m1 + 1) << 3);
 			return CVMX_CMD_QUEUE_INVALID_PARAM;
diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index 643b413..e3f95f7 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -847,7 +847,7 @@ static void pohmelfs_destroy_inode(struct inode *inode)
 }
 
 /*
- * ->alloc_inode() callback. Allocates inode and initilizes private data.
+ * ->alloc_inode() callback. Allocates inode and initializes private data.
  */
 static struct inode *pohmelfs_alloc_inode(struct super_block *sb)
 {
diff --git a/drivers/staging/rt2860/common/cmm_wpa.c b/drivers/staging/rt2860/common/cmm_wpa.c
index c16f376..9414aa3 100644
--- a/drivers/staging/rt2860/common/cmm_wpa.c
+++ b/drivers/staging/rt2860/common/cmm_wpa.c
@@ -427,7 +427,7 @@ void RTMPToWirelessSta(struct rt_rtmp_adapter *pAd,
 /*
     ==========================================================================
     Description:
-        This is a function to initilize 4-way handshake
+        This is a function to initialize 4-way handshake
 
     Return:
 
@@ -867,7 +867,7 @@ void PeerPairMsg3Action(struct rt_rtmp_adapter *pAd,
     ==========================================================================
     Description:
         When receiving the last packet of 4-way pairwisekey handshake.
-        Initilize 2-way groupkey handshake following.
+        Initialize 2-way groupkey handshake following.
     Return:
     ==========================================================================
 */
diff --git a/drivers/staging/rtl8192e/r8190_rtl8256.c b/drivers/staging/rtl8192e/r8190_rtl8256.c
index 7391f5f..8bd5b17 100644
--- a/drivers/staging/rtl8192e/r8190_rtl8256.c
+++ b/drivers/staging/rtl8192e/r8190_rtl8256.c
@@ -501,13 +501,13 @@ SetRFPowerState8190(
 				if((priv->ieee80211->eRFPowerState == eRfOff) && RT_IN_PS_LEVEL(pPSC, RT_RF_OFF_LEVL_HALT_NIC))
 				{ // The current RF state is OFF and the RF OFF level is halting the NIC, re-initialize the NIC.
 					bool rtstatus = true;
-					u32 InitilizeCount = 3;
+					u32 InitializeCount = 3;
 					do
 					{
-						InitilizeCount--;
+						InitializeCount--;
 						priv->RegRfOff = false;
 						rtstatus = NicIFEnableNIC(dev);
-					}while( (rtstatus != true) &&(InitilizeCount >0) );
+					}while( (rtstatus != true) &&(InitializeCount >0) );
 
 					if(rtstatus != true)
 					{
diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
index cdbe8bf..e8a65ce 100644
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -261,7 +261,7 @@ static int klsi_105_startup(struct usb_serial *serial)
 
 		spin_lock_init(&priv->lock);
 
-		/* priv->termios is left uninitalized until port opening */
+		/* priv->termios is left uninitialized until port opening */
 		init_waitqueue_head(&serial->port[i]->write_wait);
 	}
 
diff --git a/drivers/usb/wusbcore/wusbhc.c b/drivers/usb/wusbcore/wusbhc.c
index eab86e4..2054d4e 100644
--- a/drivers/usb/wusbcore/wusbhc.c
+++ b/drivers/usb/wusbcore/wusbhc.c
@@ -26,7 +26,7 @@
  * the one that requires (phase B, wusbhc_b_{create,destroy}).
  *
  * This is so because usb_add_hcd() will start the HC, and thus, all
- * the HC specific stuff has to be already initialiazed (like sysfs
+ * the HC specific stuff has to be already initialized (like sysfs
  * thingies).
  */
 #include <linux/device.h>
diff --git a/drivers/uwb/wlp/wss-lc.c b/drivers/uwb/wlp/wss-lc.c
index 90accdd..a005d2a 100644
--- a/drivers/uwb/wlp/wss-lc.c
+++ b/drivers/uwb/wlp/wss-lc.c
@@ -180,7 +180,7 @@ error_kobject_register:
  * If memory was allocated for the kobject's name then it will
  * be freed by the kobject system during this time.
  *
- * The EDA cache is removed and reinitilized when the WSS is removed. We
+ * The EDA cache is removed and reinitialized when the WSS is removed. We
  * thus loose knowledge of members of this WSS at that time and need not do
  * it here.
  */
diff --git a/drivers/video/carminefb.c b/drivers/video/carminefb.c
index d8345fc..6b19136 100644
--- a/drivers/video/carminefb.c
+++ b/drivers/video/carminefb.c
@@ -432,7 +432,7 @@ static int init_hardware(struct carmine_hw *hw)
 	u32 loops;
 	u32 ret;
 
-	/* Initalize Carmine */
+	/* Initialize Carmine */
 	/* Sets internal clock */
 	c_set_hw_reg(hw, CARMINE_CTL_REG + CARMINE_CTL_REG_CLOCK_ENABLE,
 			CARMINE_DFLT_IP_CLOCK_ENABLE);
diff --git a/drivers/video/tgafb.c b/drivers/video/tgafb.c
index 1b3b1c7..aba7686 100644
--- a/drivers/video/tgafb.c
+++ b/drivers/video/tgafb.c
@@ -305,7 +305,7 @@ tgafb_set_par(struct fb_info *info)
 	TGA_WRITE_REG(par, htimings, TGA_HORIZ_REG);
 	TGA_WRITE_REG(par, vtimings, TGA_VERT_REG);
 
-	/* Initalise RAMDAC. */
+	/* Initialise RAMDAC. */
 	if (tga_type == TGA_TYPE_8PLANE && tga_bus_pci) {
 
 		/* Init BT485 RAMDAC registers.  */
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 34ddda8..dc39d28 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -436,7 +436,7 @@ befs_init_inodecache(void)
 					      init_once);
 	if (befs_inode_cachep == NULL) {
 		printk(KERN_ERR "befs_init_inodecache: "
-		       "Couldn't initalize inode slabcache\n");
+		       "Couldn't initialize inode slabcache\n");
 		return -ENOMEM;
 	}
 
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 1cc0876..a2e3b56 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -762,7 +762,7 @@ ecryptfs_decrypt_page_offset(struct ecryptfs_crypt_stat *crypt_stat,
 
 /**
  * ecryptfs_init_crypt_ctx
- * @crypt_stat: Uninitilized crypt stats structure
+ * @crypt_stat: Uninitialized crypt stats structure
  *
  * Initialize the crypto context.
  *
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 377309c..bf029c7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2937,7 +2937,7 @@ fix_extent_len:
  * One of more index blocks maybe needed if the extent tree grow after
  * the unintialized extent split. To prevent ENOSPC occur at the IO
  * complete, we need to split the uninitialized extent before DIO submit
- * the IO. The uninitilized extent called at this time will be split
+ * the IO. The uninitialized extent called at this time will be split
  * into three uninitialized extent(at most). After IO complete, the part
  * being filled will be convert to initialized by the end_io callback function
  * via ext4_convert_unwritten_extents().
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4e8983a..e72d323 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3010,7 +3010,7 @@ no_journal:
 	ext4_ext_init(sb);
 	err = ext4_mb_init(sb, needs_recovery);
 	if (err) {
-		ext4_msg(sb, KERN_ERR, "failed to initalize mballoc (%d)",
+		ext4_msg(sb, KERN_ERR, "failed to initialize mballoc (%d)",
 			 err);
 		goto failed_mount4;
 	}
diff --git a/fs/freevxfs/vxfs_super.c b/fs/freevxfs/vxfs_super.c
index 1e8af93..5132c99 100644
--- a/fs/freevxfs/vxfs_super.c
+++ b/fs/freevxfs/vxfs_super.c
@@ -135,7 +135,7 @@ static int vxfs_remount(struct super_block *sb, int *flags, char *data)
 }
 
 /**
- * vxfs_read_super - read superblock into memory and initalize filesystem
+ * vxfs_read_super - read superblock into memory and initialize filesystem
  * @sbp:		VFS superblock (to fill)
  * @dp:			fs private mount data
  * @silent:		do not complain loudly when sth is wrong
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 0eaa929..03a799f 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2472,7 +2472,7 @@ static void ocfs2_delete_osb(struct ocfs2_super *osb)
 	kfree(osb->slot_recovery_generations);
 	/* FIXME
 	 * This belongs in journal shutdown, but because we have to
-	 * allocate osb->journal at the start of ocfs2_initalize_osb(),
+	 * allocate osb->journal at the start of ocfs2_initialize_osb(),
 	 * we free it here.
 	 */
 	kfree(osb->journal);
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 0f22fda..29db722 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -1221,7 +1221,7 @@ static void init_inode(struct inode *inode, struct treepath *path)
 		inode_set_bytes(inode,
 				to_real_used_space(inode, inode->i_blocks,
 						   SD_V2_SIZE));
-		/* read persistent inode attributes from sd and initalise
+		/* read persistent inode attributes from sd and initialise
 		   generic inode flags from them */
 		REISERFS_I(inode)->i_attrs = sd_v2_attrs(sd);
 		sd_attrs_to_i_attrs(sd_v2_attrs(sd), inode);
diff --git a/lib/random32.c b/lib/random32.c
index 870dc3f..fc3545a 100644
--- a/lib/random32.c
+++ b/lib/random32.c
@@ -127,7 +127,7 @@ core_initcall(random32_init);
 
 /*
  *	Generate better values after random number generator
- *	is fully initalized.
+ *	is fully initialized.
  */
 static int __init random32_reseed(void)
 {
diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index 94a4521..9323f89 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -11,7 +11,7 @@
  * Changes:
  *     Martin Hamilton         :    fixed the terrible locking bugs
  *                                   *lock(tbl->lock) ==> *lock(&tbl->lock)
- *     Wensong Zhang           :    fixed the uninitilized tbl->lock bug
+ *     Wensong Zhang           :    fixed the uninitialized tbl->lock bug
  *     Wensong Zhang           :    added doing full expiration check to
  *                                   collect stale entries of 24+ hours when
  *                                   no partial expire check in a half hour
diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
index 535dc2b..dbeed8e 100644
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -386,7 +386,7 @@ ip_vs_lblcr_new(struct ip_vs_lblcr_table *tbl, const union nf_inet_addr *daddr,
 		ip_vs_addr_copy(dest->af, &en->addr, daddr);
 		en->lastuse = jiffies;
 
-		/* initilize its dest set */
+		/* initialize its dest set */
 		atomic_set(&(en->set.size), 0);
 		INIT_LIST_HEAD(&en->set.list);
 		rwlock_init(&en->set.lock);
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index e41feff..0b85e52 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -172,7 +172,7 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
 	asoc->timeouts[SCTP_EVENT_TIMEOUT_AUTOCLOSE] =
 		(unsigned long)sp->autoclose * HZ;
 
-	/* Initilizes the timers */
+	/* Initializes the timers */
 	for (i = SCTP_EVENT_TIMEOUT_NONE; i < SCTP_NUM_TIMEOUT_TYPES; ++i)
 		setup_timer(&asoc->timers[i], sctp_timer_events[i],
 				(unsigned long)asoc);
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 1827498..0f41b05 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1162,7 +1162,7 @@ SCTP_STATIC __init int sctp_init(void)
 	/* Set the pressure threshold to be a fraction of global memory that
 	 * is up to 1/2 at 256 MB, decreasing toward zero with the amount of
 	 * memory, with a floor of 128 pages.
-	 * Note this initalizes the data in sctpv6_prot too
+	 * Note this initializes the data in sctpv6_prot too
 	 * Unabashedly stolen from tcp_init
 	 */
 	nr_pages = totalram_pages - totalhigh_pages;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 0f2fc48..276bdc7 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -3227,7 +3227,7 @@ static __init int smack_init(void)
 	cred = (struct cred *) current->cred;
 	cred->security = &smack_known_floor.smk_known;
 
-	/* initilize the smack_know_list */
+	/* initialize the smack_know_list */
 	init_smack_know_list();
 	/*
 	 * Initialize locks
diff --git a/sound/pci/trident/trident_main.c b/sound/pci/trident/trident_main.c
index 6d943f6..2870a4f 100644
--- a/sound/pci/trident/trident_main.c
+++ b/sound/pci/trident/trident_main.c
@@ -1055,7 +1055,7 @@ static int snd_trident_capture_prepare(struct snd_pcm_substream *substream)
 
 	spin_lock_irq(&trident->reg_lock);
 
-	// Initilize the channel and set channel Mode
+	// Initialize the channel and set channel Mode
 	outb(0, TRID_REG(trident, LEGACY_DMAR15));
 
 	// Set DMA channel operation mode register
diff --git a/sound/soc/fsl/mpc8610_hpcd.c b/sound/soc/fsl/mpc8610_hpcd.c
index 6a2764e..3a50106 100644
--- a/sound/soc/fsl/mpc8610_hpcd.c
+++ b/sound/soc/fsl/mpc8610_hpcd.c
@@ -46,7 +46,7 @@ struct mpc8610_hpcd_data {
 };
 
 /**
- * mpc8610_hpcd_machine_probe: initalize the board
+ * mpc8610_hpcd_machine_probe: initialize the board
  *
  * This function is called when platform_device_add() is called.  It is used
  * to initialize the board-specific hardware.
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 998569d..e048e09 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1307,7 +1307,7 @@ cpu_dai_err:
 }
 
 /*
- * Attempt to initialise any uninitalised cards.  Must be called with
+ * Attempt to initialise any uninitialised cards.  Must be called with
  * client_mutex.
  */
 static void snd_soc_instantiate_cards(void)
-- 
1.7.1

