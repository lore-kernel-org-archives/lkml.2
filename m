Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211Ab0JZUAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:00:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39461 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866Ab0JZT53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:57:29 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/22] trivial: fix typos concerning "initiali[zs]e"
Date: Tue, 26 Oct 2010 21:57:09 +0200
Message-Id: <1288123039-22368-12-git-send-email-u.kleine-koenig@pengutronix.de>
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

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 Documentation/scsi/ChangeLog.lpfc         |    2 +-
 Documentation/timers/timer_stats.txt      |    2 +-
 arch/arm/mach-bcmring/csp/chipc/chipcHw.c |    2 +-
 arch/arm/mach-bcmring/csp/tmr/tmrHw.c     |    2 +-
 arch/arm/mach-bcmring/dma.c               |    2 +-
 arch/arm/mach-omap2/serial.c              |    2 +-
 arch/mips/jz4740/board-qi_lb60.c          |    4 ++--
 arch/mips/jz4740/gpio.c                   |    2 +-
 arch/powerpc/oprofile/op_model_cell.c     |    2 +-
 arch/x86/kernel/amd_iommu.c               |    4 ++--
 block/cfq-iosched.c                       |    2 +-
 drivers/acpi/acpica/acobject.h            |    2 +-
 drivers/ata/sata_vsc.c                    |    2 +-
 drivers/atm/iphase.c                      |    4 ++--
 drivers/base/power/main.c                 |    2 +-
 drivers/dma/intel_mid_dma.c               |    6 +++---
 drivers/edac/ppc4xx_edac.c                |    6 +++---
 drivers/isdn/gigaset/bas-gigaset.c        |    4 ++--
 drivers/isdn/gigaset/ser-gigaset.c        |    4 ++--
 drivers/isdn/gigaset/usb-gigaset.c        |    4 ++--
 drivers/media/video/davinci/vpss.c        |    2 +-
 drivers/misc/arm-charlcd.c                |    2 +-
 drivers/net/bnx2x/bnx2x_main.c            |    2 +-
 drivers/net/bonding/bond_3ad.c            |    2 +-
 drivers/net/cxgb3/mc5.c                   |    2 +-
 drivers/net/ixgbe/ixgbe_82599.c           |    4 ++--
 drivers/net/wimax/i2400m/i2400m.h         |    2 +-
 drivers/net/wireless/b43/phy_g.c          |    2 +-
 drivers/net/wireless/b43legacy/phy.c      |    2 +-
 drivers/pcmcia/m8xx_pcmcia.c              |    2 +-
 drivers/platform/x86/thinkpad_acpi.c      |    2 +-
 drivers/scsi/aacraid/commsup.c            |    2 +-
 drivers/scsi/aic94xx/aic94xx_seq.c        |    6 +++---
 drivers/scsi/bfa/bfa_fcs_lport.c          |    2 +-
 drivers/scsi/dc395x.c                     |    8 ++++----
 drivers/scsi/lpfc/lpfc_attr.c             |    2 +-
 drivers/scsi/pm8001/pm8001_init.c         |    2 +-
 drivers/scsi/scsi_netlink.c               |    2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c       |    2 +-
 drivers/staging/stradis/stradis.c         |    2 +-
 drivers/usb/misc/adutux.c                 |    2 +-
 drivers/usb/misc/iowarrior.c              |    2 +-
 drivers/usb/misc/ldusb.c                  |    2 +-
 drivers/usb/musb/musb_gadget.c            |    2 +-
 fs/ext4/extents.c                         |    4 ++--
 fs/ext4/inode.c                           |    4 ++--
 fs/xfs/linux-2.6/xfs_super.c              |    2 +-
 include/linux/cgroup.h                    |    2 +-
 kernel/debug/kdb/kdb_main.c               |    2 +-
 kernel/time/clocksource.c                 |    2 +-
 net/ipv4/tcp_output.c                     |    2 +-
 scripts/mod/modpost.c                     |    2 +-
 sound/soc/codecs/max98088.c               |    2 +-
 53 files changed, 71 insertions(+), 71 deletions(-)

diff --git a/Documentation/scsi/ChangeLog.lpfc b/Documentation/scsi/ChangeLog.lpfc
index 337c924..5e83769 100644
--- a/Documentation/scsi/ChangeLog.lpfc
+++ b/Documentation/scsi/ChangeLog.lpfc
@@ -573,7 +573,7 @@ Changes from 20041018 to 20041123
 	* Backround nodev_timeout processing to DPC This enables us to
 	  unblock (stop dev_loss_tmo) when appopriate.
 	* Fix array discovery with multiple luns.  The max_luns was 0 at
-	  the time the host structure was intialized.  lpfc_cfg_params
+	  the time the host structure was initialized.  lpfc_cfg_params
 	  then set the max_luns to the correct value afterwards.
 	* Remove unused define LPFC_MAX_LUN and set the default value of
 	  lpfc_max_lun parameter to 512.
diff --git a/Documentation/timers/timer_stats.txt b/Documentation/timers/timer_stats.txt
index 9bd00fc..8abd40b 100644
--- a/Documentation/timers/timer_stats.txt
+++ b/Documentation/timers/timer_stats.txt
@@ -19,7 +19,7 @@ Linux system over a sample period:
 
 - the pid of the task(process) which initialized the timer
 - the name of the process which initialized the timer
-- the function where the timer was intialized
+- the function where the timer was initialized
 - the callback function which is associated to the timer
 - the number of events (callbacks)
 
diff --git a/arch/arm/mach-bcmring/csp/chipc/chipcHw.c b/arch/arm/mach-bcmring/csp/chipc/chipcHw.c
index b3a61d8..96273ff 100644
--- a/arch/arm/mach-bcmring/csp/chipc/chipcHw.c
+++ b/arch/arm/mach-bcmring/csp/chipc/chipcHw.c
@@ -757,7 +757,7 @@ static int chipcHw_divide(int num, int denom)
 		t = t << 1;
 	}
 
-	/* Intialize the result */
+	/* Initialize the result */
 	r = 0;
 
 	do {
diff --git a/arch/arm/mach-bcmring/csp/tmr/tmrHw.c b/arch/arm/mach-bcmring/csp/tmr/tmrHw.c
index 5c1c9a0..16225e4 100644
--- a/arch/arm/mach-bcmring/csp/tmr/tmrHw.c
+++ b/arch/arm/mach-bcmring/csp/tmr/tmrHw.c
@@ -558,7 +558,7 @@ static int tmrHw_divide(int num, int denom)
 		t = t << 1;
 	}
 
-	/* Intialize the result */
+	/* Initialize the result */
 	r = 0;
 
 	do {
diff --git a/arch/arm/mach-bcmring/dma.c b/arch/arm/mach-bcmring/dma.c
index 77eb35c..8d1baf3 100644
--- a/arch/arm/mach-bcmring/dma.c
+++ b/arch/arm/mach-bcmring/dma.c
@@ -671,7 +671,7 @@ static int ConfigChannel(DMA_Handle_t handle)
 
 /****************************************************************************/
 /**
-*   Intializes all of the data structures associated with the DMA.
+*   Initializes all of the data structures associated with the DMA.
 *   @return
 *       >= 0    - Initialization was successfull.
 *
diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index becf0e3..db79ac6 100644
--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -843,7 +843,7 @@ void __init omap_serial_init_port(int port)
 }
 
 /**
- * omap_serial_init() - intialize all supported serial ports
+ * omap_serial_init() - initialize all supported serial ports
  *
  * Initializes all available UARTs as serial ports. Platforms
  * can call this function when they want to have default behaviour
diff --git a/arch/mips/jz4740/board-qi_lb60.c b/arch/mips/jz4740/board-qi_lb60.c
index 5742bb4..de4433c 100644
--- a/arch/mips/jz4740/board-qi_lb60.c
+++ b/arch/mips/jz4740/board-qi_lb60.c
@@ -65,7 +65,7 @@ static struct nand_ecclayout qi_lb60_ecclayout_1gb = {
 
 /* Early prototypes of the QI LB60 had only 1GB of NAND.
  * In order to support these devices aswell the partition and ecc layout is
- * initalized depending on the NAND size */
+ * initialized depending on the NAND size */
 static struct mtd_partition qi_lb60_partitions_1gb[] = {
 	{
 		.name = "NAND BOOT partition",
@@ -464,7 +464,7 @@ static int __init qi_lb60_board_setup(void)
 	board_gpio_setup();
 
 	if (qi_lb60_init_platform_devices())
-		panic("Failed to initalize platform devices\n");
+		panic("Failed to initialize platform devices\n");
 
 	return 0;
 }
diff --git a/arch/mips/jz4740/gpio.c b/arch/mips/jz4740/gpio.c
index 38f60f3..88e6aed 100644
--- a/arch/mips/jz4740/gpio.c
+++ b/arch/mips/jz4740/gpio.c
@@ -546,7 +546,7 @@ static int __init jz4740_gpio_init(void)
 	for (i = 0; i < ARRAY_SIZE(jz4740_gpio_chips); ++i)
 		jz4740_gpio_chip_init(&jz4740_gpio_chips[i], i);
 
-	printk(KERN_INFO "JZ4740 GPIO initalized\n");
+	printk(KERN_INFO "JZ4740 GPIO initialized\n");
 
 	return 0;
 }
diff --git a/arch/powerpc/oprofile/op_model_cell.c b/arch/powerpc/oprofile/op_model_cell.c
index 7fd90d0..c4d2b71 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -1469,7 +1469,7 @@ static int cell_global_start(struct op_counter_config *ctr)
  * The pm_interval register is setup to write the SPU PC value into the
  * trace buffer at the maximum rate possible.  The trace buffer is configured
  * to store the PCs, wrapping when it is full.  The performance counter is
- * intialized to the max hardware count minus the number of events, N, between
+ * initialized to the max hardware count minus the number of events, N, between
  * samples.  Once the N events have occured, a HW counter overflow occurs
  * causing the generation of a HW counter interrupt which also stops the
  * writing of the SPU PC values to the trace buffer.  Hence the last PC
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index d2fdb08..57ca777 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1086,7 +1086,7 @@ static int alloc_new_range(struct dma_ops_domain *dma_dom,
 
 	dma_dom->aperture_size += APERTURE_RANGE_SIZE;
 
-	/* Intialize the exclusion range if necessary */
+	/* Initialize the exclusion range if necessary */
 	for_each_iommu(iommu) {
 		if (iommu->exclusion_start &&
 		    iommu->exclusion_start >= dma_dom->aperture[index]->offset
@@ -1353,7 +1353,7 @@ static void dma_ops_domain_free(struct dma_ops_domain *dom)
 
 /*
  * Allocates a new protection domain usable for the dma_ops functions.
- * It also intializes the page table and the address allocator data
+ * It also initializes the page table and the address allocator data
  * structures required for the dma_ops interface
  */
 static struct dma_ops_domain *dma_ops_domain_alloc(void)
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4cd59b0..78ee4b1 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1030,7 +1030,7 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 
 	/*
 	 * Add group onto cgroup list. It might happen that bdi->dev is
-	 * not initiliazed yet. Initialize this new group without major
+	 * not initialized yet. Initialize this new group without major
 	 * and minor info and this info will be filled in once a new thread
 	 * comes for IO. See code above.
 	 */
diff --git a/drivers/acpi/acpica/acobject.h b/drivers/acpi/acpica/acobject.h
index bdbfaf2..962a3cc 100644
--- a/drivers/acpi/acpica/acobject.h
+++ b/drivers/acpi/acpica/acobject.h
@@ -93,7 +93,7 @@
 
 #define AOPOBJ_AML_CONSTANT         0x01	/* Integer is an AML constant */
 #define AOPOBJ_STATIC_POINTER       0x02	/* Data is part of an ACPI table, don't delete */
-#define AOPOBJ_DATA_VALID           0x04	/* Object is intialized and data is valid */
+#define AOPOBJ_DATA_VALID           0x04	/* Object is initialized and data is valid */
 #define AOPOBJ_OBJECT_INITIALIZED   0x08	/* Region is initialized, _REG was run */
 #define AOPOBJ_SETUP_COMPLETE       0x10	/* Region setup is complete */
 #define AOPOBJ_INVALID              0x20	/* Host OS won't allow a Region address */
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index b777176..e079cf2 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -370,7 +370,7 @@ static int __devinit vsc_sata_init_one(struct pci_dev *pdev,
 	if (pci_resource_len(pdev, 0) == 0)
 		return -ENODEV;
 
-	/* map IO regions and intialize host accordingly */
+	/* map IO regions and initialize host accordingly */
 	rc = pcim_iomap_regions(pdev, 1 << VSC_MMIO_BAR, DRV_NAME);
 	if (rc == -EBUSY)
 		pcim_pin_device(pdev);
diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 9309d47..ad8e207 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -2063,7 +2063,7 @@ static int tx_init(struct atm_dev *dev)
 		- UBR Table size is 4K  
 		- UBR wait queue is 4K  
 	   since the table and wait queues are contiguous, all the bytes   
-	   can be initialized by one memeset.  
+	   can be initialized by one memeset.
 	*/  
         
         vcsize_sel = 0;
@@ -2089,7 +2089,7 @@ static int tx_init(struct atm_dev *dev)
 		- ABR Table size is 2K  
 		- ABR wait queue is 2K  
 	   since the table and wait queues are contiguous, all the bytes   
-	   can be intialized by one memeset.  
+	   can be initialized by one memeset.
 	*/  
         i = ABR_SCHED_TABLE * iadev->memSize;
         writew((i >> 11) & 0xffff, iadev->seg_reg+ABR_SBPTR_BASE);
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 31b5266..c5356ef 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -8,7 +8,7 @@
  *
  *
  * The driver model core calls device_pm_add() when a device is registered.
- * This will intialize the embedded device_pm_info object in the device
+ * This will initialize the embedded device_pm_info object in the device
  * and add it to the list of power-controlled devices. sysfs entries for
  * controlling device power management will also be added.
  *
diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index 338bc4e..da8b7f1 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -1060,8 +1060,8 @@ static irqreturn_t intel_mid_dma_interrupt2(int irq, void *data)
  * mid_setup_dma -	Setup the DMA controller
  * @pdev: Controller PCI device structure
  *
- * Initilize the DMA controller, channels, registers with DMA engine,
- * ISR. Initilize DMA controller channels.
+ * Initialize the DMA controller, channels, registers with DMA engine,
+ * ISR. Initialize DMA controller channels.
  */
 static int mid_setup_dma(struct pci_dev *pdev)
 {
@@ -1219,7 +1219,7 @@ static void middma_shutdown(struct pci_dev *pdev)
  * @pdev: Controller PCI device structure
  * @id: pci device id structure
  *
- * Initilize the PCI device, map BARs, query driver data.
+ * Initialize the PCI device, map BARs, query driver data.
  * Call setup_dma to complete contoller and chan initilzation
  */
 static int __devinit intel_mid_dma_probe(struct pci_dev *pdev,
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index 070cea4..b9f0c20 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -873,7 +873,7 @@ ppc4xx_edac_get_mtype(u32 mcopt1)
 }
 
 /**
- * ppc4xx_edac_init_csrows - intialize driver instance rows
+ * ppc4xx_edac_init_csrows - initialize driver instance rows
  * @mci: A pointer to the EDAC memory controller instance
  *       associated with the ibm,sdram-4xx-ddr2 controller for which
  *       the csrows (i.e. banks/ranks) are being initialized.
@@ -881,7 +881,7 @@ ppc4xx_edac_get_mtype(u32 mcopt1)
  *          currently set for the controller, from which bank width
  *          and memory typ information is derived.
  *
- * This routine intializes the virtual "chip select rows" associated
+ * This routine initializes the virtual "chip select rows" associated
  * with the EDAC memory controller instance. An ibm,sdram-4xx-ddr2
  * controller bank/rank is mapped to a row.
  *
@@ -992,7 +992,7 @@ ppc4xx_edac_init_csrows(struct mem_ctl_info *mci, u32 mcopt1)
 }
 
 /**
- * ppc4xx_edac_mc_init - intialize driver instance
+ * ppc4xx_edac_mc_init - initialize driver instance
  * @mci: A pointer to the EDAC memory controller instance being
  *       initialized.
  * @op: A pointer to the OpenFirmware device tree node associated
diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-gigaset.c
index 178942a..8a3c5cf 100644
--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -2318,7 +2318,7 @@ static int gigaset_probe(struct usb_interface *interface,
 		 __func__, le16_to_cpu(udev->descriptor.idVendor),
 		 le16_to_cpu(udev->descriptor.idProduct));
 
-	/* allocate memory for our device state and intialize it */
+	/* allocate memory for our device state and initialize it */
 	cs = gigaset_initcs(driver, BAS_CHANNELS, 0, 0, cidmode,
 			    GIGASET_MODULENAME);
 	if (!cs)
@@ -2576,7 +2576,7 @@ static int __init bas_gigaset_init(void)
 {
 	int result;
 
-	/* allocate memory for our driver state and intialize it */
+	/* allocate memory for our driver state and initialize it */
 	driver = gigaset_initdriver(GIGASET_MINOR, GIGASET_MINORS,
 				    GIGASET_MODULENAME, GIGASET_DEVNAME,
 				    &gigops, THIS_MODULE);
diff --git a/drivers/isdn/gigaset/ser-gigaset.c b/drivers/isdn/gigaset/ser-gigaset.c
index d151dcb..0ef09d0 100644
--- a/drivers/isdn/gigaset/ser-gigaset.c
+++ b/drivers/isdn/gigaset/ser-gigaset.c
@@ -513,7 +513,7 @@ gigaset_tty_open(struct tty_struct *tty)
 		return -ENODEV;
 	}
 
-	/* allocate memory for our device state and intialize it */
+	/* allocate memory for our device state and initialize it */
 	cs = gigaset_initcs(driver, 1, 1, 0, cidmode, GIGASET_MODULENAME);
 	if (!cs)
 		goto error;
@@ -771,7 +771,7 @@ static int __init ser_gigaset_init(void)
 		return rc;
 	}
 
-	/* allocate memory for our driver state and intialize it */
+	/* allocate memory for our driver state and initialize it */
 	driver = gigaset_initdriver(GIGASET_MINOR, GIGASET_MINORS,
 					  GIGASET_MODULENAME, GIGASET_DEVNAME,
 					  &ops, THIS_MODULE);
diff --git a/drivers/isdn/gigaset/usb-gigaset.c b/drivers/isdn/gigaset/usb-gigaset.c
index 4a66338..5e3300d 100644
--- a/drivers/isdn/gigaset/usb-gigaset.c
+++ b/drivers/isdn/gigaset/usb-gigaset.c
@@ -695,7 +695,7 @@ static int gigaset_probe(struct usb_interface *interface,
 
 	dev_info(&udev->dev, "%s: Device matched ... !\n", __func__);
 
-	/* allocate memory for our device state and intialize it */
+	/* allocate memory for our device state and initialize it */
 	cs = gigaset_initcs(driver, 1, 1, 0, cidmode, GIGASET_MODULENAME);
 	if (!cs)
 		return -ENODEV;
@@ -894,7 +894,7 @@ static int __init usb_gigaset_init(void)
 {
 	int result;
 
-	/* allocate memory for our driver state and intialize it */
+	/* allocate memory for our driver state and initialize it */
 	driver = gigaset_initdriver(GIGASET_MINOR, GIGASET_MINORS,
 				    GIGASET_MODULENAME, GIGASET_DEVNAME,
 				    &ops, THIS_MODULE);
diff --git a/drivers/media/video/davinci/vpss.c b/drivers/media/video/davinci/vpss.c
index 7918680..3e5cf27 100644
--- a/drivers/media/video/davinci/vpss.c
+++ b/drivers/media/video/davinci/vpss.c
@@ -85,7 +85,7 @@ enum vpss_platform_type {
 /*
  * vpss operations. Depends on platform. Not all functions are available
  * on all platforms. The api, first check if a functio is available before
- * invoking it. In the probe, the function ptrs are intialized based on
+ * invoking it. In the probe, the function ptrs are initialized based on
  * vpss name. vpss name can be "dm355_vpss", "dm644x_vpss" etc.
  */
 struct vpss_hw_ops {
diff --git a/drivers/misc/arm-charlcd.c b/drivers/misc/arm-charlcd.c
index 9e3879e..fe8616a 100644
--- a/drivers/misc/arm-charlcd.c
+++ b/drivers/misc/arm-charlcd.c
@@ -313,7 +313,7 @@ static int __init charlcd_probe(struct platform_device *pdev)
 	INIT_DELAYED_WORK(&lcd->init_work, charlcd_init_work);
 	schedule_delayed_work(&lcd->init_work, 0);
 
-	dev_info(&pdev->dev, "initalized ARM character LCD at %08x\n",
+	dev_info(&pdev->dev, "initialized ARM character LCD at %08x\n",
 		lcd->phybase);
 
 	return 0;
diff --git a/drivers/net/bnx2x/bnx2x_main.c b/drivers/net/bnx2x/bnx2x_main.c
index e9ad16f..4a6f0ea 100644
--- a/drivers/net/bnx2x/bnx2x_main.c
+++ b/drivers/net/bnx2x/bnx2x_main.c
@@ -4947,7 +4947,7 @@ static int bnx2x_init_hw_common(struct bnx2x *bp, u32 load_code)
 		memset(&ilt_cli, 0, sizeof(struct ilt_client_info));
 		memset(&ilt, 0, sizeof(struct bnx2x_ilt));
 
-		/* initalize dummy TM client */
+		/* initialize dummy TM client */
 		ilt_cli.start = 0;
 		ilt_cli.end = ILT_NUM_PAGE_ENTRIES - 1;
 		ilt_cli.client_num = ILT_CLIENT_TM;
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 30f368d..106718c 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1916,7 +1916,7 @@ int bond_3ad_bind_slave(struct slave *slave)
 		return -1;
 	}
 
-	//check that the slave has not been intialized yet.
+	//check that the slave has not been initialized yet.
 	if (SLAVE_AD_INFO(slave).port.slave != slave) {
 
 		// port initialization
diff --git a/drivers/net/cxgb3/mc5.c b/drivers/net/cxgb3/mc5.c
index a8766fb..e13b7fe 100644
--- a/drivers/net/cxgb3/mc5.c
+++ b/drivers/net/cxgb3/mc5.c
@@ -318,7 +318,7 @@ static void mc5_dbgi_mode_disable(const struct mc5 *mc5)
 
 /*
  * Initialization that requires the OS and protocol layers to already
- * be intialized goes here.
+ * be initialized goes here.
  */
 int t3_mc5_init(struct mc5 *mc5, unsigned int nservers, unsigned int nfilters,
 		unsigned int nroutes)
diff --git a/drivers/net/ixgbe/ixgbe_82599.c b/drivers/net/ixgbe/ixgbe_82599.c
index 0bd8fbb..05e6b8c 100644
--- a/drivers/net/ixgbe/ixgbe_82599.c
+++ b/drivers/net/ixgbe/ixgbe_82599.c
@@ -1078,7 +1078,7 @@ s32 ixgbe_init_fdir_signature_82599(struct ixgbe_hw *hw, u32 pballoc)
 
 	/*
 	 * The defaults in the HW for RX PB 1-7 are not zero and so should be
-	 * intialized to zero for non DCB mode otherwise actual total RX PB
+	 * initialized to zero for non DCB mode otherwise actual total RX PB
 	 * would be bigger than programmed and filter space would run into
 	 * the PB 0 region.
 	 */
@@ -1169,7 +1169,7 @@ s32 ixgbe_init_fdir_perfect_82599(struct ixgbe_hw *hw, u32 pballoc)
 
 	/*
 	 * The defaults in the HW for RX PB 1-7 are not zero and so should be
-	 * intialized to zero for non DCB mode otherwise actual total RX PB
+	 * initialized to zero for non DCB mode otherwise actual total RX PB
 	 * would be bigger than programmed and filter space would run into
 	 * the PB 0 region.
 	 */
diff --git a/drivers/net/wimax/i2400m/i2400m.h b/drivers/net/wimax/i2400m/i2400m.h
index 59ac770..8cde3a5 100644
--- a/drivers/net/wimax/i2400m/i2400m.h
+++ b/drivers/net/wimax/i2400m/i2400m.h
@@ -698,7 +698,7 @@ enum i2400m_bm_cmd_flags {
  * @I2400M_BRI_MAC_REINIT: We need to reinitialize the boot
  *     rom after reading the MAC address. This is quite a dirty hack,
  *     if you ask me -- the device requires the bootrom to be
- *     intialized after reading the MAC address.
+ *     initialized after reading the MAC address.
  */
 enum i2400m_bri {
 	I2400M_BRI_SOFT       = 1 << 1,
diff --git a/drivers/net/wireless/b43/phy_g.c b/drivers/net/wireless/b43/phy_g.c
index 0dc33b6..be48281 100644
--- a/drivers/net/wireless/b43/phy_g.c
+++ b/drivers/net/wireless/b43/phy_g.c
@@ -1919,7 +1919,7 @@ static void b43_hardware_pctl_init_gphy(struct b43_wldev *dev)
 	b43_hf_write(dev, b43_hf_read(dev) | B43_HF_HWPCTL);
 }
 
-/* Intialize B/G PHY power control */
+/* Initialize B/G PHY power control */
 static void b43_phy_init_pctl(struct b43_wldev *dev)
 {
 	struct ssb_bus *bus = dev->dev->bus;
diff --git a/drivers/net/wireless/b43legacy/phy.c b/drivers/net/wireless/b43legacy/phy.c
index 35033dd..28e477d 100644
--- a/drivers/net/wireless/b43legacy/phy.c
+++ b/drivers/net/wireless/b43legacy/phy.c
@@ -153,7 +153,7 @@ void b43legacy_phy_calibrate(struct b43legacy_wldev *dev)
 	phy->calibrated = 1;
 }
 
-/* intialize B PHY power control
+/* initialize B PHY power control
  * as described in http://bcm-specs.sipsolutions.net/InitPowerControl
  */
 static void b43legacy_phy_init_pctl(struct b43legacy_wldev *dev)
diff --git a/drivers/pcmcia/m8xx_pcmcia.c b/drivers/pcmcia/m8xx_pcmcia.c
index 99d4f23..0db4827 100644
--- a/drivers/pcmcia/m8xx_pcmcia.c
+++ b/drivers/pcmcia/m8xx_pcmcia.c
@@ -1198,7 +1198,7 @@ static int __init m8xx_probe(struct platform_device *ofdev,
 	out_be32(M8XX_PGCRX(1),
 		 M8XX_PGCRX_CXOE | (mk_int_int_mask(hwirq) << 16));
 
-	/* intialize the fixed memory windows */
+	/* initialize the fixed memory windows */
 
 	for (i = 0; i < PCMCIA_SOCKETS_NO; i++) {
 		for (m = 0; m < PCMCIA_MEM_WIN_NO; m++) {
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 2d61186..304333f 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -7193,7 +7193,7 @@ static struct ibm_struct volume_driver_data = {
  * 		TPACPI_FAN_WR_ACPI_FANS (X31/X40/X41)
  *
  *	FIRMWARE BUG: on some models, EC 0x2f might not be initialized at
- *	boot. Apparently the EC does not intialize it, so unless ACPI DSDT
+ *	boot. Apparently the EC does not initialize it, so unless ACPI DSDT
  *	does so, its initial value is meaningless (0x07).
  *
  *	For firmware bugs, refer to:
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index afc9aeb..060ac4b 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -91,7 +91,7 @@ void aac_fib_map_free(struct aac_dev *dev)
  *	aac_fib_setup	-	setup the fibs
  *	@dev: Adapter to set up
  *
- *	Allocate the PCI space for the fibs, map it and then intialise the
+ *	Allocate the PCI space for the fibs, map it and then initialise the
  *	fib area, the unmapped fib data and also the free list
  */
 
diff --git a/drivers/scsi/aic94xx/aic94xx_seq.c b/drivers/scsi/aic94xx/aic94xx_seq.c
index 7437461..390168f 100644
--- a/drivers/scsi/aic94xx/aic94xx_seq.c
+++ b/drivers/scsi/aic94xx/aic94xx_seq.c
@@ -797,7 +797,7 @@ static void asd_init_lseq_mdp(struct asd_ha_struct *asd_ha,  int lseq)
 		int j;
 		/* Start from Page 1 of Mode 0 and 1. */
 		moffs = LSEQ_PAGE_SIZE + i*LSEQ_MODE_SCRATCH_SIZE;
-		/* All the fields of page 1 can be intialized to 0. */
+		/* All the fields of page 1 can be initialized to 0. */
 		for (j = 0; j < LSEQ_PAGE_SIZE; j += 4)
 			asd_write_reg_dword(asd_ha, LmSCRATCH(lseq)+moffs+j,0);
 	}
@@ -938,7 +938,7 @@ static void asd_init_cseq_cio(struct asd_ha_struct *asd_ha)
 	asd_write_reg_dword(asd_ha, SCBPRO, 0);
 	asd_write_reg_dword(asd_ha, CSEQCON, 0);
 
-	/* Intialize CSEQ Mode 11 Interrupt Vectors.
+	/* Initialize CSEQ Mode 11 Interrupt Vectors.
 	 * The addresses are 16 bit wide and in dword units.
 	 * The values of their macros are in byte units.
 	 * Thus we have to divide by 4. */
@@ -961,7 +961,7 @@ static void asd_init_cseq_cio(struct asd_ha_struct *asd_ha)
 	asd_write_reg_word(asd_ha, CPRGMCNT, cseq_idle_loop);
 
 	for (i = 0; i < 8; i++) {
-		/* Intialize Mode n Link m Interrupt Enable. */
+		/* Initialize Mode n Link m Interrupt Enable. */
 		asd_write_reg_dword(asd_ha, CMnINTEN(i), EN_CMnRSPMBXF);
 		/* Initialize Mode n Request Mailbox. */
 		asd_write_reg_dword(asd_ha, CMnREQMBX(i), 0);
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index b522bf3..b7aa23a 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -5742,7 +5742,7 @@ bfa_cb_lps_fdisc_comp(void *bfad, void *uarg, bfa_status_t status)
 	switch (status) {
 	case BFA_STATUS_OK:
 		/*
-		 * Initialiaze the V-Port fields
+		 * Initialize the V-Port fields
 		 */
 		__vport_fcid(vport) = bfa_lps_get_pid(vport->lps);
 		vport->vport_stats.fdisc_accepts++;
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 54f50b0..31bbfb2 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3795,7 +3795,7 @@ static struct DeviceCtlBlk *device_alloc(struct AdapterCtlBlk *acb,
  * adapter_add_device - Adds the device instance to the adaptor instance.
  *
  * @acb: The adapter device to be updated
- * @dcb: A newly created and intialised device instance to add.
+ * @dcb: A newly created and initialised device instance to add.
  **/
 static void adapter_add_device(struct AdapterCtlBlk *acb,
 		struct DeviceCtlBlk *dcb)
@@ -4497,7 +4497,7 @@ static void __devinit adapter_init_chip(struct AdapterCtlBlk *acb)
  * init_adapter - Grab the resource for the card, setup the adapter
  * information, set the card into a known state, create the various
  * tables etc etc. This basically gets all adapter information all up
- * to date, intialised and gets the chip in sync with it.
+ * to date, initialised and gets the chip in sync with it.
  *
  * @host:	This hosts adapter structure
  * @io_port:	The base I/O port
@@ -4788,7 +4788,7 @@ static void banner_display(void)
  * that it finds in the system. The pci_dev strcuture indicates which
  * instance we are being called from.
  * 
- * @dev: The PCI device to intialize.
+ * @dev: The PCI device to initialize.
  * @id: Looks like a pointer to the entry in our pci device table
  * that was actually matched by the PCI subsystem.
  *
@@ -4859,7 +4859,7 @@ fail:
  * dc395x_remove_one - Called to remove a single instance of the
  * adapter.
  *
- * @dev: The PCI device to intialize.
+ * @dev: The PCI device to initialize.
  **/
 static void __devexit dc395x_remove_one(struct pci_dev *dev)
 {
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index f681eea..0e4abb9 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1339,7 +1339,7 @@ lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
 }
 
 /**
- * lpfc_param_init - Intializes a cfg attribute
+ * lpfc_param_init - Initializes a cfg attribute
  *
  * Description:
  * Macro that given an attr e.g. hba_queue_depth expands
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index f8c86b2..b95285f 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -603,7 +603,7 @@ static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
 #endif
 
 intx:
-	/* intialize the INT-X interrupt */
+	/* initialize the INT-X interrupt */
 	rc = request_irq(pdev->irq, irq_handler, IRQF_SHARED, DRV_NAME,
 		SHOST_TO_SAS_HA(pm8001_ha->shost));
 	return rc;
diff --git a/drivers/scsi/scsi_netlink.c b/drivers/scsi/scsi_netlink.c
index d53e650..a2ed201 100644
--- a/drivers/scsi/scsi_netlink.c
+++ b/drivers/scsi/scsi_netlink.c
@@ -477,7 +477,7 @@ EXPORT_SYMBOL_GPL(scsi_nl_remove_driver);
 
 
 /**
- * scsi_netlink_init - Called by SCSI subsystem to intialize
+ * scsi_netlink_init - Called by SCSI subsystem to initialize
  * 	the SCSI transport netlink interface
  *
  **/
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 8b955b5..4afa81a 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1864,7 +1864,7 @@ static pci_ers_result_t sym2_io_slot_dump(struct pci_dev *pdev)
  *
  * This routine is similar to sym_set_workarounds(), except
  * that, at this point, we already know that the device was
- * successfully intialized at least once before, and so most
+ * successfully initialized at least once before, and so most
  * of the steps taken there are un-needed here.
  */
 static void sym2_reset_workarounds(struct pci_dev *pdev)
diff --git a/drivers/staging/stradis/stradis.c b/drivers/staging/stradis/stradis.c
index a057824..dd3874b 100644
--- a/drivers/staging/stradis/stradis.c
+++ b/drivers/staging/stradis/stradis.c
@@ -745,7 +745,7 @@ static void set_out_format(struct saa7146 *saa, int mode)
 	}
 }
 
-/* Intialize bitmangler to map from a byte value to the mangled word that
+/* Initialize bitmangler to map from a byte value to the mangled word that
  * must be output to program the Xilinx part through the DEBI port.
  * Xilinx Data Bit->DEBI Bit: 0->15 1->7 2->6 3->12 4->11 5->2 6->1 7->0
  * transfer FPGA code, init IBM chip, transfer IBM microcode
diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index 44f8b92..a6afd15 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -717,7 +717,7 @@ static int adu_probe(struct usb_interface *interface,
 		goto exit;
 	}
 
-	/* allocate memory for our device state and intialize it */
+	/* allocate memory for our device state and initialize it */
 	dev = kzalloc(sizeof(struct adu_device), GFP_KERNEL);
 	if (dev == NULL) {
 		dev_err(&interface->dev, "Out of memory\n");
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 3756641..7a10e48 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -768,7 +768,7 @@ static int iowarrior_probe(struct usb_interface *interface,
 	int i;
 	int retval = -ENOMEM;
 
-	/* allocate memory for our device state and intialize it */
+	/* allocate memory for our device state and initialize it */
 	dev = kzalloc(sizeof(struct iowarrior), GFP_KERNEL);
 	if (dev == NULL) {
 		dev_err(&interface->dev, "Out of memory\n");
diff --git a/drivers/usb/misc/ldusb.c b/drivers/usb/misc/ldusb.c
index edffef6..eefb827 100644
--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -642,7 +642,7 @@ static int ld_usb_probe(struct usb_interface *intf, const struct usb_device_id *
 	int i;
 	int retval = -ENOMEM;
 
-	/* allocate memory for our device state and intialize it */
+	/* allocate memory for our device state and initialize it */
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 5d81504..567dbe6 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1636,7 +1636,7 @@ static inline void __init musb_g_init_endpoints(struct musb *musb)
 	struct musb_hw_ep	*hw_ep;
 	unsigned		count = 0;
 
-	/* intialize endpoint list just once */
+	/* initialize endpoint list just once */
 	INIT_LIST_HEAD(&(musb->g.ep_list));
 
 	for (epnum = 0, hw_ep = musb->endpoints;
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a130f02..05a232e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2871,14 +2871,14 @@ fix_extent_len:
  * to an uninitialized extent.
  *
  * Writing to an uninitized extent may result in splitting the uninitialized
- * extent into multiple /intialized unintialized extents (up to three)
+ * extent into multiple /initialized uninitialized extents (up to three)
  * There are three possibilities:
  *   a> There is no split required: Entire extent should be uninitialized
  *   b> Splits in two extents: Write is happening at either end of the extent
  *   c> Splits in three extents: Somone is writing in middle of the extent
  *
  * One of more index blocks maybe needed if the extent tree grow after
- * the unintialized extent split. To prevent ENOSPC occur at the IO
+ * the uninitialized extent split. To prevent ENOSPC occur at the IO
  * complete, we need to split the uninitialized extent before DIO submit
  * the IO. The uninitialized extent called at this time will be split
  * into three uninitialized extent(at most). After IO complete, the part
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 670ab15..867818d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3931,9 +3931,9 @@ retry:
  * preallocated extents, and those write extend the file, no need to
  * fall back to buffered IO.
  *
- * For holes, we fallocate those blocks, mark them as unintialized
+ * For holes, we fallocate those blocks, mark them as uninitialized
  * If those blocks were preallocated, we mark sure they are splited, but
- * still keep the range to write as unintialized.
+ * still keep the range to write as uninitialized.
  *
  * The unwrritten extents will be converted to written when DIO is completed.
  * For async direct IO, since the IO may still pending when return, we
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index ab31ce5..0794efe 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -938,7 +938,7 @@ out_reclaim:
  * Slab object creation initialisation for the XFS inode.
  * This covers only the idempotent fields in the XFS inode;
  * all other fields need to be initialised on allocation
- * from the slab. This avoids the need to repeatedly intialise
+ * from the slab. This avoids the need to repeatedly initialise
  * fields in the xfs inode that left in the initialise state
  * when freeing the inode.
  */
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 709dfb9..90a5cbf 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -560,7 +560,7 @@ struct cgroup_iter {
 /*
  * To iterate across the tasks in a cgroup:
  *
- * 1) call cgroup_iter_start to intialize an iterator
+ * 1) call cgroup_iter_start to initialize an iterator
  *
  * 2) call cgroup_iter_next() to retrieve member tasks until it
  *    returns NULL or until you want to end the iteration
diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index d7bda21..5d37d95 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -2937,7 +2937,7 @@ static void __init kdb_cmd_init(void)
 	}
 }
 
-/* Intialize kdb_printf, breakpoint tables and kdb state */
+/* Initialize kdb_printf, breakpoint tables and kdb state */
 void __init kdb_init(int lvl)
 {
 	static int kdb_init_lvl = KDB_NOT_INITIALIZED;
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c18d7ef..ddbbaf2 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -678,7 +678,7 @@ EXPORT_SYMBOL_GPL(__clocksource_updatefreq_scale);
 int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
 {
 
-	/* Intialize mult/shift and max_idle_ns */
+	/* Initialize mult/shift and max_idle_ns */
 	__clocksource_updatefreq_scale(cs, scale, freq);
 
 	/* Add clocksource to the clcoksource list */
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 05b1ecf..e961522 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1336,7 +1336,7 @@ static inline unsigned int tcp_cwnd_test(struct tcp_sock *tp,
 	return 0;
 }
 
-/* Intialize TSO state of a skb.
+/* Initialize TSO state of a skb.
  * This must be invoked the first time we consider transmitting
  * SKB onto the wire.
  */
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 33122ca..6619ed8 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1614,7 +1614,7 @@ static void section_rel(const char *modname, struct elf_info *elf,
  * A module includes a number of sections that are discarded
  * either when loaded or when used as built-in.
  * For loaded modules all functions marked __init and all data
- * marked __initdata will be discarded when the module has been intialized.
+ * marked __initdata will be discarded when the module has been initialized.
  * Likewise for modules used built-in the sections marked __exit
  * are discarded because __exit marked function are supposed to be called
  * only when a module is unloaded which never happens for built-in modules.
diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
index e7a40d1..0f81b23 100644
--- a/sound/soc/codecs/max98088.c
+++ b/sound/soc/codecs/max98088.c
@@ -1953,7 +1953,7 @@ static int max98088_probe(struct snd_soc_codec *codec)
                return ret;
        }
 
-       /* initalize private data */
+       /* initialize private data */
 
        max98088->sysclk = (unsigned)-1;
        max98088->eq_textcnt = 0;
-- 
1.7.2.3

