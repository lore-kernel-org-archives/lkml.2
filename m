Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939Ab1FWSj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:39:29 -0400
Received: from mail.perches.com ([173.55.12.10]:3175 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759904Ab1FWSj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:39:26 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [Trivial next 2/2] treewide: transciever/transceiver spelling fixes
Date: Thu, 23 Jun 2011 11:39:20 -0700
Message-Id: <58b7d01a9f272e86c8844f59e74e1d5a1543275d.1308853653.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
In-Reply-To: <cover.1308853652.git.joe@perches.com>
References: <cover.1308853652.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just tyops.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/mach-pxa/include/mach/corgi.h        |    2 +-
 arch/arm/mach-pxa/include/mach/pxa27x-udc.h   |    4 ++--
 arch/arm/mach-ux500/board-mop500-regulators.c |    2 +-
 drivers/i2c/busses/i2c-highlander.c           |    2 +-
 drivers/net/eexpress.c                        |    2 +-
 drivers/net/irda/toim3232-sir.c               |    2 +-
 drivers/net/natsemi.c                         |    2 +-
 drivers/tty/serial/8250_pci.c                 |    2 +-
 drivers/usb/gadget/pxa27x_udc.h               |    4 ++--
 drivers/usb/musb/musb_core.c                  |    2 +-
 drivers/usb/otg/isp1301_omap.c                |    4 ++--
 sound/pci/ice1712/ice1712.c                   |    2 +-
 12 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-pxa/include/mach/corgi.h b/arch/arm/mach-pxa/include/mach/corgi.h
index 0011055..5dfd119 100644
--- a/arch/arm/mach-pxa/include/mach/corgi.h
+++ b/arch/arm/mach-pxa/include/mach/corgi.h
@@ -34,7 +34,7 @@
 #define CORGI_GPIO_LCDCON_CS		(19) /* LCD Control Chip Select */
 #define CORGI_GPIO_MAX1111_CS		(20) /* MAX1111 Chip Select */
 #define CORGI_GPIO_ADC_TEMP_ON		(21) /* Select battery voltage or temperature */
-#define CORGI_GPIO_IR_ON			(22) /* Enable IR Transciever */
+#define CORGI_GPIO_IR_ON			(22) /* Enable IR Transceiver */
 #define CORGI_GPIO_ADS7846_CS		(24) /* ADS7846 Chip Select */
 #define CORGI_GPIO_SD_PWR			(33) /* MMC/SD Power */
 #define CORGI_GPIO_CHRG_ON			(38) /* Enable battery Charging */
diff --git a/arch/arm/mach-pxa/include/mach/pxa27x-udc.h b/arch/arm/mach-pxa/include/mach/pxa27x-udc.h
index ab1443f..4cf28f6 100644
--- a/arch/arm/mach-pxa/include/mach/pxa27x-udc.h
+++ b/arch/arm/mach-pxa/include/mach/pxa27x-udc.h
@@ -56,9 +56,9 @@
 #define UDCFNR          __REG(0x40600014) /* UDC Frame Number Register */
 #define UDCOTGICR	__REG(0x40600018) /* UDC On-The-Go interrupt control */
 #define UDCOTGICR_IESF	(1 << 24)	/* OTG SET_FEATURE command recvd */
-#define UDCOTGICR_IEXR	(1 << 17)	/* Extra Transciever Interrupt
+#define UDCOTGICR_IEXR	(1 << 17)	/* Extra Transceiver Interrupt
 					   Rising Edge Interrupt Enable */
-#define UDCOTGICR_IEXF	(1 << 16)	/* Extra Transciever Interrupt
+#define UDCOTGICR_IEXF	(1 << 16)	/* Extra Transceiver Interrupt
 					   Falling Edge Interrupt Enable */
 #define UDCOTGICR_IEVV40R (1 << 9)	/* OTG Vbus Valid 4.0V Rising Edge
 					   Interrupt Enable */
diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index c0bc833..2735d03 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -77,7 +77,7 @@ static struct regulator_consumer_supply ab8500_vtvout_consumers[] = {
 static struct regulator_consumer_supply ab8500_vintcore_consumers[] = {
 	/* SoC core supply, no device */
 	REGULATOR_SUPPLY("v-intcore", NULL),
-	/* USB Transciever */
+	/* USB Transceiver */
 	REGULATOR_SUPPLY("vddulpivio18", "ab8500-usb.0"),
 };
 
diff --git a/drivers/i2c/busses/i2c-highlander.c b/drivers/i2c/busses/i2c-highlander.c
index 3df1bc8..3876a24 100644
--- a/drivers/i2c/busses/i2c-highlander.c
+++ b/drivers/i2c/busses/i2c-highlander.c
@@ -227,7 +227,7 @@ static int highlander_i2c_read(struct highlander_i2c_dev *dev)
 
 	/*
 	 * The R0P7780LC0011RL FPGA needs a significant delay between
-	 * data read cycles, otherwise the transciever gets confused and
+	 * data read cycles, otherwise the transceiver gets confused and
 	 * garbage is returned when the read is subsequently aborted.
 	 *
 	 * It is not sufficient to wait for BBSY.
diff --git a/drivers/net/eexpress.c b/drivers/net/eexpress.c
index 48ee51b..a192285 100644
--- a/drivers/net/eexpress.c
+++ b/drivers/net/eexpress.c
@@ -365,7 +365,7 @@ static int __init do_express_probe(struct net_device *dev)
 			dev->irq = mca_irqmap[(pos1>>4)&0x7];
 
 			/*
-			 * XXX: Transciever selection is done
+			 * XXX: Transceiver selection is done
 			 * differently on the MCA version.
 			 * How to get it to select something
 			 * other than external/AUI is currently
diff --git a/drivers/net/irda/toim3232-sir.c b/drivers/net/irda/toim3232-sir.c
index 99e1ec0..19ad460 100644
--- a/drivers/net/irda/toim3232-sir.c
+++ b/drivers/net/irda/toim3232-sir.c
@@ -78,7 +78,7 @@
  * Target hardware: IRWave IR320ST-2
  *
  * 	The IRWave IR320ST-2 is a simple dongle based on the Vishay/Temic
- * 	TOIM3232 SIR Endec and the Vishay/Temic TFDS4500 SIR IRDA transciever.
+ * 	TOIM3232 SIR Endec and the Vishay/Temic TFDS4500 SIR IRDA transceiver.
  * 	It uses a hex inverter and some discrete components to buffer and
  * 	line convert the RS232 down to 5V.
  *
diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index b78be08..ab28629 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -2919,7 +2919,7 @@ static int netdev_set_ecmd(struct net_device *dev, struct ethtool_cmd *ecmd)
 
 	/*
 	 * If we're ignoring the PHY then autoneg and the internal
-	 * transciever are really not going to work so don't let the
+	 * transceiver are really not going to work so don't let the
 	 * user select them.
 	 */
 	if (np->ignore_phy && (ecmd->autoneg == AUTONEG_ENABLE ||
diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
index 2b9a642..6b887d9 100644
--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -769,7 +769,7 @@ pci_ni8430_setup(struct serial_private *priv,
 	len =  pci_resource_len(priv->dev, bar);
 	p = ioremap_nocache(base, len);
 
-	/* enable the transciever */
+	/* enable the transceiver */
 	writeb(readb(p + offset + NI8430_PORTCON) | NI8430_PORTCON_TXVR_ENABLE,
 	       p + offset + NI8430_PORTCON);
 
diff --git a/drivers/usb/gadget/pxa27x_udc.h b/drivers/usb/gadget/pxa27x_udc.h
index cd16231..b01696e 100644
--- a/drivers/usb/gadget/pxa27x_udc.h
+++ b/drivers/usb/gadget/pxa27x_udc.h
@@ -88,9 +88,9 @@
 #define UDCISR_INT_MASK	(UDCICR_FIFOERR | UDCICR_PKTCOMPL)
 
 #define UDCOTGICR_IESF	(1 << 24)	/* OTG SET_FEATURE command recvd */
-#define UDCOTGICR_IEXR	(1 << 17)	/* Extra Transciever Interrupt
+#define UDCOTGICR_IEXR	(1 << 17)	/* Extra Transceiver Interrupt
 					   Rising Edge Interrupt Enable */
-#define UDCOTGICR_IEXF	(1 << 16)	/* Extra Transciever Interrupt
+#define UDCOTGICR_IEXF	(1 << 16)	/* Extra Transceiver Interrupt
 					   Falling Edge Interrupt Enable */
 #define UDCOTGICR_IEVV40R (1 << 9)	/* OTG Vbus Valid 4.0V Rising Edge
 					   Interrupt Enable */
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index c71b037..bcbd1ab 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1955,7 +1955,7 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 	 *   - initializes musb->xceiv, usually by otg_get_transceiver()
 	 *   - stops powering VBUS
 	 *
-	 * There are various transciever configurations.  Blackfin,
+	 * There are various transceiver configurations.  Blackfin,
 	 * DaVinci, TUSB60x0, and others integrate them.  OMAP3 uses
 	 * external/discrete ones in various flavors (twl4030 family,
 	 * isp1504, non-OTG, etc) mostly hooking up through ULPI.
diff --git a/drivers/usb/otg/isp1301_omap.c b/drivers/usb/otg/isp1301_omap.c
index 8c28225..ca9b690 100644
--- a/drivers/usb/otg/isp1301_omap.c
+++ b/drivers/usb/otg/isp1301_omap.c
@@ -660,7 +660,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 	int		ret = IRQ_NONE;
 	struct isp1301	*isp = _isp;
 
-	/* update ISP1301 transciever from OTG controller */
+	/* update ISP1301 transceiver from OTG controller */
 	if (otg_irq & OPRT_CHG) {
 		omap_writew(OPRT_CHG, OTG_IRQ_SRC);
 		isp1301_defer_work(isp, WORK_UPDATE_ISP);
@@ -755,7 +755,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 		omap_writew(A_VBUS_ERR, OTG_IRQ_SRC);
 		ret = IRQ_HANDLED;
 
-	/* switch driver; the transciever code activates it,
+	/* switch driver; the transceiver code activates it,
 	 * ungating the udc clock or resuming OHCI.
 	 */
 	} else if (otg_irq & DRIVER_SWITCH) {
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index be06fb3..0ccc0eb 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -87,7 +87,7 @@ static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static int enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;/* Enable this card */
 static char *model[SNDRV_CARDS];
 static int omni[SNDRV_CARDS];				/* Delta44 & 66 Omni I/O support */
-static int cs8427_timeout[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS-1)] = 500}; /* CS8427 S/PDIF transciever reset timeout value in msec */
+static int cs8427_timeout[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS-1)] = 500}; /* CS8427 S/PDIF transceiver reset timeout value in msec */
 static int dxr_enable[SNDRV_CARDS];			/* DXR enable for DMX6FIRE */
 
 module_param_array(index, int, NULL, 0444);
-- 
1.7.6.rc1

