Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab1FWGaB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 02:30:01 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44207 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079Ab1FWGaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 02:30:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=M/YaYS+Tt1H1hDJlnJpqT+rDOvdVG2qeMKMKhR9n02H37Ahkw8dE6wgSBeQTNGxYF0
         GuJVRTnCpbyg4CUoMLtmeGsh01cEezLVHsbGcOA854JFi7TBSY87OkkffFfhe4U6fW6e
         yQN9baR303Mlw6Q8LfC6ni0ACEgDIRDYzBgc0=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/3]Fix typo interrupt(s) to interrupt(s) 
Date: Wed, 22 Jun 2011 23:29:18 -0700
Message-Id: <1308810560-23742-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch below fixes some typos interrrupt to interrupt.
Note I sent something similar a few months ago, either this was the same or
newly created typos have been created. 

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/arm/mach-omap2/smartreflex.c                |    2 +-
 arch/powerpc/platforms/embedded6xx/storcenter.c  |    2 +-
 drivers/net/arm/ks8695net.c                      |    2 +-
 drivers/net/atlx/atl1.c                          |    2 +-
 drivers/net/sky2.c                               |    2 +-
 drivers/net/wireless/rtlwifi/pci.c               |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |    4 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c    |    2 +-
 drivers/tty/serial/mrst_max3110.c                |    2 +-
 drivers/usb/gadget/langwell_udc.c                |    2 +-
 drivers/usb/musb/musb_gadget.c                   |    2 +-
 11 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index fb7dc52..8b6da75 100644
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
diff --git a/drivers/net/arm/ks8695net.c b/drivers/net/arm/ks8695net.c
index a7b0caa..47e7be6 100644
--- a/drivers/net/arm/ks8695net.c
+++ b/drivers/net/arm/ks8695net.c
@@ -412,7 +412,7 @@ ks8695_tx_irq(int irq, void *dev_id)
  *    Interrupt Status Register (Offset 0xF208)
  *        Bit29: WAN MAC Receive Status
  *        Bit16: LAN MAC Receive Status
- *    So, this Rx interrrupt enable/status bit number is equal
+ *    So, this Rx interrupt enable/status bit number is equal
  *    as Rx IRQ number.
  */
 static inline u32 ks8695_get_rx_enable_bit(struct ks8695_priv *ksp)
diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index cd5789f..ab1d8a4 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -858,7 +858,7 @@ static s32 atl1_init_hw(struct atl1_hw *hw)
 	atl1_init_flash_opcode(hw);
 
 	if (!hw->phy_configured) {
-		/* enable GPHY LinkChange Interrrupt */
+		/* enable GPHY LinkChange Interrupt */
 		ret_val = atl1_write_phy_reg(hw, 18, 0xC00);
 		if (ret_val)
 			return ret_val;
diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 3ee41da..a04c56e 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -1973,7 +1973,7 @@ static void sky2_hw_down(struct sky2_port *sky2)
 
 	sky2_write8(hw, SK_REG(port, RX_GMF_CTRL_T), GMF_RST_SET);
 
-	/* Force any delayed status interrrupt and NAPI */
+	/* Force any delayed status interrupt and NAPI */
 	sky2_write32(hw, STAT_LEV_TIMER_CNT, 0);
 	sky2_write32(hw, STAT_TX_TIMER_CNT, 0);
 	sky2_write32(hw, STAT_ISR_TIMER_CNT, 0);
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 9f8ccae..52cd981 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1573,7 +1573,7 @@ static void rtl_pci_stop(struct ieee80211_hw *hw)
 	u8 RFInProgressTimeOut = 0;
 
 	/*
-	 *should before disable interrrupt&adapter
+	 *should before disable interrupt&adapter
 	 *and will do it immediately.
 	 */
 	set_hal_stop(rtlhal);
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 830822f..f7ce399 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -390,10 +390,10 @@ static void ft1000_reset_asic(struct net_device *dev)
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
index b0a4211..d3642a2 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -601,7 +601,7 @@ static void ft1000_reset_asic(struct net_device *dev)
 
 	mdelay(1);
 
-	/* set watermark to -1 in order to not generate an interrrupt */
+	/* set watermark to -1 in order to not generate an interrupt */
 	ft1000_write_register(ft1000dev, 0xffff, FT1000_REG_MAG_WATERMARK);
 
 	/* clear interrupts */
diff --git a/drivers/tty/serial/mrst_max3110.c b/drivers/tty/serial/mrst_max3110.c
index 1bd2845..e829ac2 100644
--- a/drivers/tty/serial/mrst_max3110.c
+++ b/drivers/tty/serial/mrst_max3110.c
@@ -23,7 +23,7 @@
  *    1 word. If SPI master controller doesn't support sclk frequency change,
  *    then the char need be sent out one by one with some delay
  *
- * 2. Currently only RX available interrrupt is used, no need for waiting TXE
+ * 2. Currently only RX available interrupt is used, no need for waiting TXE
  *    interrupt for a low speed UART device
  */
 
diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index 9cee88a..8d6ca5e 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -2968,7 +2968,7 @@ static irqreturn_t langwell_irq(int irq, void *_dev)
 		handle_port_change(dev);
 	}
 
-	/* suspend interrrupt */
+	/* suspend interrupt */
 	if (irq_sts & STS_SLI) {
 		dev_vdbg(&dev->pdev->dev, "suspend interrupt\n");
 		handle_bus_suspend(dev);
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 0a50a35..e30d56d 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -704,7 +704,7 @@ static void rxstate(struct musb *musb, struct musb_request *req)
 	 * most these gadgets, end of is signified either by a short packet,
 	 * or filling the last byte of the buffer.  (Sending extra data in
 	 * that last pckate should trigger an overflow fault.)  But in mode 1,
-	 * we don't get DMA completion interrrupt for short packets.
+	 * we don't get DMA completion interrupt for short packets.
 	 *
 	 * Theoretically, we could enable DMAReq irq (MUSB_RXCSR_DMAMODE = 1),
 	 * to get endpoint interrupt on every DMA req, but that didn't seem
-- 
1.7.5.4

