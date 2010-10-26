Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760286Ab0JZUAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 16:00:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39455 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758454Ab0JZT53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 15:57:29 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 07/22] trivial: fix typos concerning "controller"
Date: Tue, 26 Oct 2010 21:57:04 +0200
Message-Id: <1288123039-22368-7-git-send-email-u.kleine-koenig@pengutronix.de>
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
 Documentation/cgroups/memcg_test.txt          |    2 +-
 arch/arm/mach-bcmring/csp/dmac/dmacHw.c       |    2 +-
 arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c |    2 +-
 arch/arm/mach-bcmring/include/csp/dmacHw.h    |    2 +-
 arch/arm/mach-gemini/include/mach/hardware.h  |    2 +-
 arch/arm/mach-pxa/mxm8x10.c                   |    2 +-
 arch/arm/mach-s3c64xx/dma.c                   |    2 +-
 arch/powerpc/include/asm/8xx_immap.h          |    4 ++--
 drivers/edac/amd8131_edac.h                   |    2 +-
 drivers/i2c/busses/i2c-nomadik.c              |    4 ++--
 drivers/input/touchscreen/Kconfig             |    2 +-
 drivers/mmc/host/Kconfig                      |    2 +-
 drivers/mmc/host/sdricoh_cs.c                 |    4 ++--
 drivers/net/e1000/e1000_hw.h                  |    2 +-
 drivers/net/irda/donauboe.h                   |    2 +-
 drivers/net/wan/dscc4.c                       |    2 +-
 drivers/pcmcia/m32r_cfc.h                     |    2 +-
 drivers/pcmcia/m32r_pcc.h                     |    2 +-
 drivers/power/s3c_adc_battery.c               |    4 ++--
 drivers/usb/host/imx21-hcd.c                  |    2 +-
 drivers/usb/host/oxu210hp-hcd.c               |    2 +-
 21 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/Documentation/cgroups/memcg_test.txt b/Documentation/cgroups/memcg_test.txt
index b7eecec..fc8fa97 100644
--- a/Documentation/cgroups/memcg_test.txt
+++ b/Documentation/cgroups/memcg_test.txt
@@ -398,7 +398,7 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
 	written to move_charge_at_immigrate.
 
  9.10 Memory thresholds
-	Memory controler implements memory thresholds using cgroups notification
+	Memory controller implements memory thresholds using cgroups notification
 	API. You can use Documentation/cgroups/cgroup_event_listener.c to test
 	it.
 
diff --git a/arch/arm/mach-bcmring/csp/dmac/dmacHw.c b/arch/arm/mach-bcmring/csp/dmac/dmacHw.c
index 7b9bac2..6b9be2e 100644
--- a/arch/arm/mach-bcmring/csp/dmac/dmacHw.c
+++ b/arch/arm/mach-bcmring/csp/dmac/dmacHw.c
@@ -893,7 +893,7 @@ int dmacHw_setDataDescriptor(dmacHw_CONFIG_t *pConfig,	/*   [ IN ] Configuration
 */
 /****************************************************************************/
 uint32_t dmacHw_getDmaControllerAttribute(dmacHw_HANDLE_t handle,	/*  [ IN ]  DMA Channel handle */
-					  dmacHw_CONTROLLER_ATTRIB_e attr	/*  [ IN ]  DMA Controler attribute of type  dmacHw_CONTROLLER_ATTRIB_e */
+					  dmacHw_CONTROLLER_ATTRIB_e attr	/*  [ IN ]  DMA Controller attribute of type  dmacHw_CONTROLLER_ATTRIB_e */
     ) {
 	dmacHw_CBLK_t *pCblk = dmacHw_HANDLE_TO_CBLK(handle);
 
diff --git a/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c b/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c
index ff7b436..77f84b4 100644
--- a/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c
+++ b/arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c
@@ -316,7 +316,7 @@ static void DisplayDescRing(void *pDescriptor,	/*   [ IN ] Descriptor buffer */
 /**
 *  @brief   Check if DMA channel is the flow controller
 *
-*  @return  1 : If DMA is a flow controler
+*  @return  1 : If DMA is a flow controller
 *           0 : Peripheral is the flow controller
 *
 *  @note
diff --git a/arch/arm/mach-bcmring/include/csp/dmacHw.h b/arch/arm/mach-bcmring/include/csp/dmacHw.h
index 5d51013..6c8da2b 100644
--- a/arch/arm/mach-bcmring/include/csp/dmacHw.h
+++ b/arch/arm/mach-bcmring/include/csp/dmacHw.h
@@ -590,7 +590,7 @@ void dmacHw_printDebugInfo(dmacHw_HANDLE_t handle,	/*  [ IN ] DMA Channel handle
 */
 /****************************************************************************/
 uint32_t dmacHw_getDmaControllerAttribute(dmacHw_HANDLE_t handle,	/*  [ IN ]  DMA Channel handle  */
-					  dmacHw_CONTROLLER_ATTRIB_e attr	/*  [ IN ]  DMA Controler attribute of type  dmacHw_CONTROLLER_ATTRIB_e */
+					  dmacHw_CONTROLLER_ATTRIB_e attr	/*  [ IN ]  DMA Controller attribute of type  dmacHw_CONTROLLER_ATTRIB_e */
     );
 
 #endif /* _DMACHW_H */
diff --git a/arch/arm/mach-gemini/include/mach/hardware.h b/arch/arm/mach-gemini/include/mach/hardware.h
index 213a4fc..8c950e1 100644
--- a/arch/arm/mach-gemini/include/mach/hardware.h
+++ b/arch/arm/mach-gemini/include/mach/hardware.h
@@ -33,7 +33,7 @@
 #define GEMINI_LPC_HOST_BASE	0x47000000
 #define GEMINI_LPC_IO_BASE	0x47800000
 #define GEMINI_INTERRUPT_BASE	0x48000000
-/* TODO: Different interrupt controlers when SMP
+/* TODO: Different interrupt controllers when SMP
  * #define GEMINI_INTERRUPT0_BASE	0x48000000
  * #define GEMINI_INTERRUPT1_BASE	0x49000000
  */
diff --git a/arch/arm/mach-pxa/mxm8x10.c b/arch/arm/mach-pxa/mxm8x10.c
index 462167a..cdf7f41 100644
--- a/arch/arm/mach-pxa/mxm8x10.c
+++ b/arch/arm/mach-pxa/mxm8x10.c
@@ -337,7 +337,7 @@ void __init mxm_8x10_mmc_init(void)
 }
 #endif
 
-/* USB Open Host Controler Interface */
+/* USB Open Host Controller Interface */
 static struct pxaohci_platform_data mxm_8x10_ohci_platform_data = {
 	.port_mode = PMM_NPS_MODE,
 	.flags = ENABLE_PORT_ALL
diff --git a/arch/arm/mach-s3c64xx/dma.c b/arch/arm/mach-s3c64xx/dma.c
index e7d03ab..372ea68 100644
--- a/arch/arm/mach-s3c64xx/dma.c
+++ b/arch/arm/mach-s3c64xx/dma.c
@@ -740,7 +740,7 @@ static int __init s3c64xx_dma_init(void)
 	/* Set all DMA configuration to be DMA, not SDMA */
 	writel(0xffffff, S3C_SYSREG(0x110));
 
-	/* Register standard DMA controlers */
+	/* Register standard DMA controllers */
 	s3c64xx_dma_init1(0, DMACH_UART0, IRQ_DMA0, 0x75000000);
 	s3c64xx_dma_init1(8, DMACH_PCM1_TX, IRQ_DMA1, 0x75100000);
 
diff --git a/arch/powerpc/include/asm/8xx_immap.h b/arch/powerpc/include/asm/8xx_immap.h
index 4b0e152..6b6dc20 100644
--- a/arch/powerpc/include/asm/8xx_immap.h
+++ b/arch/powerpc/include/asm/8xx_immap.h
@@ -93,7 +93,7 @@ typedef struct	mem_ctlr {
 } memctl8xx_t;
 
 /*-----------------------------------------------------------------------
- * BR - Memory Controler: Base Register					16-9
+ * BR - Memory Controller: Base Register					16-9
  */
 #define BR_BA_MSK	0xffff8000	/* Base Address Mask			*/
 #define BR_AT_MSK	0x00007000	/* Address Type Mask			*/
@@ -110,7 +110,7 @@ typedef struct	mem_ctlr {
 #define BR_V		0x00000001	/* Bank Valid				*/
 
 /*-----------------------------------------------------------------------
- * OR - Memory Controler: Option Register				16-11
+ * OR - Memory Controller: Option Register				16-11
  */
 #define OR_AM_MSK	0xffff8000	/* Address Mask Mask			*/
 #define OR_ATM_MSK	0x00007000	/* Address Type Mask Mask		*/
diff --git a/drivers/edac/amd8131_edac.h b/drivers/edac/amd8131_edac.h
index 60e0d1c..6f8b071 100644
--- a/drivers/edac/amd8131_edac.h
+++ b/drivers/edac/amd8131_edac.h
@@ -99,7 +99,7 @@ struct amd8131_dev_info {
 
 /*
  * AMD8131 chipset has two pairs of PCIX Bridge and related IOAPIC
- * Controler, and ATCA-6101 has two AMD8131 chipsets, so there are
+ * Controller, and ATCA-6101 has two AMD8131 chipsets, so there are
  * four PCIX Bridges on ATCA-6101 altogether.
  *
  * These PCIX Bridges share the same PCI Device ID and are all of
diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
index c9fffd0..2bd3469 100644
--- a/drivers/i2c/busses/i2c-nomadik.c
+++ b/drivers/i2c/busses/i2c-nomadik.c
@@ -434,7 +434,7 @@ static int read_i2c(struct nmk_i2c_dev *dev)
 	}
 
 	if (timeout == 0) {
-		/* controler has timedout, re-init the h/w */
+		/* controller has timedout, re-init the h/w */
 		dev_err(&dev->pdev->dev, "controller timed out, re-init h/w\n");
 		(void) init_hw(dev);
 		status = -ETIMEDOUT;
@@ -498,7 +498,7 @@ static int write_i2c(struct nmk_i2c_dev *dev)
 	}
 
 	if (timeout == 0) {
-		/* controler has timedout, re-init the h/w */
+		/* controller has timedout, re-init the h/w */
 		dev_err(&dev->pdev->dev, "controller timed out, re-init h/w\n");
 		(void) init_hw(dev);
 		status = -ETIMEDOUT;
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 06ea8da..6675bd7 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -610,7 +610,7 @@ config TOUCHSCREEN_USB_ZYTRONIC
 
 config TOUCHSCREEN_USB_ETT_TC45USB
 	default y
-	bool "ET&T USB series TC4UM/TC5UH touchscreen controler support" if EMBEDDED
+	bool "ET&T USB series TC4UM/TC5UH touchscreen controller support" if EMBEDDED
 	depends on TOUCHSCREEN_USB_COMPOSITE
 
 config TOUCHSCREEN_USB_NEXIO
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index d618e86..c99a1fc 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -462,7 +462,7 @@ config MMC_SH_MMCIF
 	tristate "SuperH Internal MMCIF support"
 	depends on MMC_BLOCK && (SUPERH || ARCH_SHMOBILE)
 	help
-	  This selects the MMC Host Interface controler (MMCIF).
+	  This selects the MMC Host Interface controller (MMCIF).
 
 	  This driver supports MMCIF in sh7724/sh7757/sh7372.
 
diff --git a/drivers/mmc/host/sdricoh_cs.c b/drivers/mmc/host/sdricoh_cs.c
index f472c27..bbc298f 100644
--- a/drivers/mmc/host/sdricoh_cs.c
+++ b/drivers/mmc/host/sdricoh_cs.c
@@ -446,7 +446,7 @@ static int sdricoh_init_mmc(struct pci_dev *pci_dev,
 	mmc->max_seg_size = 1024 * 512;
 	mmc->max_blk_size = 512;
 
-	/* reset the controler */
+	/* reset the controller */
 	if (sdricoh_reset(host)) {
 		dev_dbg(dev, "could not reset\n");
 		result = -EIO;
@@ -478,7 +478,7 @@ static int sdricoh_pcmcia_probe(struct pcmcia_device *pcmcia_dev)
 	dev_info(&pcmcia_dev->dev, "Searching MMC controller for pcmcia device"
 		" %s %s ...\n", pcmcia_dev->prod_id[0], pcmcia_dev->prod_id[1]);
 
-	/* search pci cardbus bridge that contains the mmc controler */
+	/* search pci cardbus bridge that contains the mmc controller */
 	/* the io region is already claimed by yenta_socket... */
 	while ((pci_dev =
 		pci_get_device(PCI_VENDOR_ID_RICOH, PCI_DEVICE_ID_RICOH_RL5C476,
diff --git a/drivers/net/e1000/e1000_hw.h b/drivers/net/e1000/e1000_hw.h
index ecd9f6c..5e820f4 100644
--- a/drivers/net/e1000/e1000_hw.h
+++ b/drivers/net/e1000/e1000_hw.h
@@ -41,7 +41,7 @@ struct e1000_hw;
 struct e1000_hw_stats;
 
 /* Enumerated types specific to the e1000 hardware */
-/* Media Access Controlers */
+/* Media Access Controllers */
 typedef enum {
 	e1000_undefined = 0,
 	e1000_82542_rev2_0,
diff --git a/drivers/net/irda/donauboe.h b/drivers/net/irda/donauboe.h
index 4dc39e5..77fcf44 100644
--- a/drivers/net/irda/donauboe.h
+++ b/drivers/net/irda/donauboe.h
@@ -30,7 +30,7 @@
  *     or the type-DO IR port.
  *
  * IrDA chip set list from Toshiba Computer Engineering Corp.
- * model			method	maker	controler		Version 
+ * model			method	maker	controller		Version 
  * Portege 320CT	FIR,SIR Toshiba Oboe(Triangle) 
  * Portege 3010CT	FIR,SIR Toshiba Oboe(Sydney) 
  * Portege 3015CT	FIR,SIR Toshiba Oboe(Sydney) 
diff --git a/drivers/net/wan/dscc4.c b/drivers/net/wan/dscc4.c
index d45b08d..94ff9b0 100644
--- a/drivers/net/wan/dscc4.c
+++ b/drivers/net/wan/dscc4.c
@@ -125,7 +125,7 @@ static u32 dscc4_pci_config_store[16];
 /* Module parameters */
 
 MODULE_AUTHOR("Maintainer: Francois Romieu <romieu@cogenit.fr>");
-MODULE_DESCRIPTION("Siemens PEB20534 PCI Controler");
+MODULE_DESCRIPTION("Siemens PEB20534 PCI Controller");
 MODULE_LICENSE("GPL");
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug,"Enable/disable extra messages");
diff --git a/drivers/pcmcia/m32r_cfc.h b/drivers/pcmcia/m32r_cfc.h
index 8146e3b..f558e1a 100644
--- a/drivers/pcmcia/m32r_cfc.h
+++ b/drivers/pcmcia/m32r_cfc.h
@@ -9,7 +9,7 @@
 #endif
 
 /*
- * M32R PC Card Controler
+ * M32R PC Card Controller
  */
 #define M32R_PCC0_BASE        0x00ef7000
 #define M32R_PCC1_BASE        0x00ef7020
diff --git a/drivers/pcmcia/m32r_pcc.h b/drivers/pcmcia/m32r_pcc.h
index e4fffe4..f95c585 100644
--- a/drivers/pcmcia/m32r_pcc.h
+++ b/drivers/pcmcia/m32r_pcc.h
@@ -5,7 +5,7 @@
 #define M32R_MAX_PCC	2
 
 /*
- * M32R PC Card Controler
+ * M32R PC Card Controller
  */
 #define M32R_PCC0_BASE        0x00ef7000
 #define M32R_PCC1_BASE        0x00ef7020
diff --git a/drivers/power/s3c_adc_battery.c b/drivers/power/s3c_adc_battery.c
index fe16b48..4a8ae39 100644
--- a/drivers/power/s3c_adc_battery.c
+++ b/drivers/power/s3c_adc_battery.c
@@ -1,5 +1,5 @@
 /*
- *	iPAQ h1930/h1940/rx1950 battery controler driver
+ *	iPAQ h1930/h1940/rx1950 battery controller driver
  *	Copyright (c) Vasily Khoruzhick
  *	Based on h1940_battery.c by Arnaud Patard
  *
@@ -427,5 +427,5 @@ static void __exit s3c_adc_bat_exit(void)
 module_exit(s3c_adc_bat_exit);
 
 MODULE_AUTHOR("Vasily Khoruzhick <anarsoul@gmail.com>");
-MODULE_DESCRIPTION("iPAQ H1930/H1940/RX1950 battery controler driver");
+MODULE_DESCRIPTION("iPAQ H1930/H1940/RX1950 battery controller driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/usb/host/imx21-hcd.c b/drivers/usb/host/imx21-hcd.c
index e49b75a..f90d003 100644
--- a/drivers/usb/host/imx21-hcd.c
+++ b/drivers/usb/host/imx21-hcd.c
@@ -1658,7 +1658,7 @@ static int imx21_hc_reset(struct usb_hcd *hcd)
 
 	spin_lock_irqsave(&imx21->lock, flags);
 
-	/* Reset the Host controler modules */
+	/* Reset the Host controller modules */
 	writel(USBOTG_RST_RSTCTRL | USBOTG_RST_RSTRH |
 		USBOTG_RST_RSTHSIE | USBOTG_RST_RSTHC,
 		imx21->regs + USBOTG_RST_CTRL);
diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index 32149be..e0cb12b 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -3094,7 +3094,7 @@ static int oxu_hub_status_data(struct usb_hcd *hcd, char *buf)
 
 	/* Some boards (mostly VIA?) report bogus overcurrent indications,
 	 * causing massive log spam unless we completely ignore them.  It
-	 * may be relevant that VIA VT8235 controlers, where PORT_POWER is
+	 * may be relevant that VIA VT8235 controllers, where PORT_POWER is
 	 * always set, seem to clear PORT_OCC and PORT_CSC when writing to
 	 * PORT_POWER; that's surprising, but maybe within-spec.
 	 */
-- 
1.7.2.3

