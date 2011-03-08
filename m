Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab1CHXEc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 18:04:32 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45612 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab1CHXEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 18:04:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=e01NcJFC0q7TGXxPT1UV9dYFlJ4FUkew0OZZppXGmxJLz3qujTCrsHbMJ55zHUMCrC
         bR7ET0rdTP6aPx70Yxu0O+1A6Nu+3NsZX6d1eqSHSfBmU8vhkt/iO9KMiACoQw11X0WI
         IJUsP80V9sShRmGYzQRN4uXCAw/RrsNLiMSps=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Joe Perches <joe@perches.com>
Subject: [PATCH v2]trivial: Remove one to many r's in some comments.
Date: Tue,  8 Mar 2011 15:04:20 -0800
Message-Id: <1299625460-3061-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes one to many rr"s in some words to make them
correct, as well as some other typos in some comments.

CC: Joe Perches <joe@perches.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/arm/mach-omap2/smartreflex.c                  |    4 ++--
 arch/powerpc/platforms/embedded6xx/storcenter.c    |    2 +-
 arch/sparc/kernel/smp_64.c                         |    2 +-
 drivers/ata/sata_dwc_460ex.c                       |    2 +-
 drivers/message/fusion/lsi/mpi_ioc.h               |    2 +-
 drivers/net/arm/ks8695net.c                        |    2 +-
 drivers/net/atlx/atl1.c                            |    2 +-
 drivers/net/cs89x0.c                               |    2 +-
 drivers/net/qlge/qlge_main.c                       |    2 +-
 drivers/net/sky2.c                                 |    2 +-
 drivers/net/wireless/rtlwifi/pci.c                 |    2 +-
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |    4 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |    2 +-
 drivers/staging/sep/sep_driver.c                   |    2 +-
 drivers/staging/tidspbridge/Kconfig                |    2 +-
 drivers/staging/tidspbridge/rmgr/dbdcd.c           |    2 +-
 .../astoria/include/linux/westbridge/cyasstorage.h |    2 +-
 drivers/tty/serial/mrst_max3110.c                  |    2 +-
 drivers/usb/gadget/langwell_udc.c                  |    2 +-
 drivers/usb/musb/musb_gadget.c                     |    4 ++--
 include/linux/pxa2xx_ssp.h                         |    2 +-
 net/ipv4/ip_fragment.c                             |    2 +-
 22 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
index 95ac336..35d098e 100644
--- a/arch/arm/mach-omap2/smartreflex.c
+++ b/arch/arm/mach-omap2/smartreflex.c
@@ -243,10 +243,10 @@ static void sr_stop_vddautocomp(struct omap_sr *sr)
  * This function handles the intializations which have to be done
  * only when both sr device and class driver regiter has
  * completed. This will be attempted to be called from both sr class
- * driver register and sr device intializtion API's. Only one call
+ * driver register and sr device initialization API's. Only one call
  * will ultimately succeed.
  *
- * Currenly this function registers interrrupt handler for a particular SR
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
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 555a76d..63a6142 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -842,7 +842,7 @@ static void tsb_sync(void *info)
 	struct trap_per_cpu *tp = &trap_block[raw_smp_processor_id()];
 	struct mm_struct *mm = info;
 
-	/* It is not valid to test "currrent->active_mm == mm" here.
+	/* It is not valid to test "current->active_mm == mm" here.
 	 *
 	 * The value of "current" is not changed atomically with
 	 * switch_mm().  But that's OK, we just need to check the
diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 6cf57c5..bc09a35 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -350,7 +350,7 @@ static void sata_dwc_tf_dump(struct ata_taskfile *tf)
 /*
  * Function: get_burst_length_encode
  * arguments: datalength: length in bytes of data
- * returns value to be programmed in register corrresponding to data length
+ * returns value to be programmed in register corresponding to data length
  * This value is effectively the log(base 2) of the length
  */
 static  int get_burst_length_encode(int datalength)
diff --git a/drivers/message/fusion/lsi/mpi_ioc.h b/drivers/message/fusion/lsi/mpi_ioc.h
index 8faa4fa..d28c15d 100644
--- a/drivers/message/fusion/lsi/mpi_ioc.h
+++ b/drivers/message/fusion/lsi/mpi_ioc.h
@@ -856,7 +856,7 @@ typedef struct _EVENT_DATA_SAS_DISCOVERY
 #define MPI_EVENT_SAS_DSCVRY_PHY_BITS_MASK                  (0xFFFF0000)
 #define MPI_EVENT_SAS_DSCVRY_PHY_BITS_SHIFT                 (16)
 
-/* SAS Discovery Errror Event data */
+/* SAS Discovery Error Event data */
 
 typedef struct _EVENT_DATA_DISCOVERY_ERROR
 {
diff --git a/drivers/net/arm/ks8695net.c b/drivers/net/arm/ks8695net.c
index aa07657..f251fe0 100644
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
index 3b52768..bd0d409 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -857,7 +857,7 @@ static s32 atl1_init_hw(struct atl1_hw *hw)
 	atl1_init_flash_opcode(hw);
 
 	if (!hw->phy_configured) {
-		/* enable GPHY LinkChange Interrrupt */
+		/* enable GPHY LinkChange Interrupt */
 		ret_val = atl1_write_phy_reg(hw, 18, 0xC00);
 		if (ret_val)
 			return ret_val;
diff --git a/drivers/net/cs89x0.c b/drivers/net/cs89x0.c
index d325e01..b04a21e 100644
--- a/drivers/net/cs89x0.c
+++ b/drivers/net/cs89x0.c
@@ -1330,7 +1330,7 @@ release_irq:
                 if (result==DETECTED_NONE) {
                         printk(KERN_WARNING "%s: 10Base-5 (AUI) has no cable\n", dev->name);
                         if (lp->auto_neg_cnf & IMM_BIT) /* check "ignore missing media" bit */
-                                result = DETECTED_AUI; /* Yes! I don't care if I see a carrrier */
+                                result = DETECTED_AUI; /* Yes! I don't care if I see a carrier */
                 }
 		break;
 	case A_CNF_MEDIA_10B_2:
diff --git a/drivers/net/qlge/qlge_main.c b/drivers/net/qlge/qlge_main.c
index 49bfa58..e9cb3c7 100644
--- a/drivers/net/qlge/qlge_main.c
+++ b/drivers/net/qlge/qlge_main.c
@@ -2086,7 +2086,7 @@ static unsigned long ql_process_mac_rx_intr(struct ql_adapter *qdev,
 						length, vlan_id);
 	} else {
 		/* Non-TCP/UDP large frames that span multiple buffers
-		 * can be processed corrrectly by the split frame logic.
+		 * can be processed correctly by the split frame logic.
 		 */
 		ql_process_mac_split_rx_intr(qdev, rx_ring, ib_mac_rsp,
 						vlan_id);
diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 7d85a38..ec77231 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -1972,7 +1972,7 @@ static void sky2_hw_down(struct sky2_port *sky2)
 
 	sky2_write8(hw, SK_REG(port, RX_GMF_CTRL_T), GMF_RST_SET);
 
-	/* Force any delayed status interrrupt and NAPI */
+	/* Force any delayed status interrupt and NAPI */
 	sky2_write32(hw, STAT_LEV_TIMER_CNT, 0);
 	sky2_write32(hw, STAT_TX_TIMER_CNT, 0);
 	sky2_write32(hw, STAT_ISR_TIMER_CNT, 0);
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 1758d44..8ca71da 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1506,7 +1506,7 @@ void rtl_pci_stop(struct ieee80211_hw *hw)
 	u8 RFInProgressTimeOut = 0;
 
 	/*
-	 *should before disable interrrupt&adapter
+	 *Stop HAL before disabling interrupt and adapter 
 	 *and will do it immediately.
 	 */
 	set_hal_stop(rtlhal);
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 588afd5..318b41f 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -386,10 +386,10 @@ static void ft1000_reset_asic(struct net_device *dev)
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
index 643a637..835f738 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -663,7 +663,7 @@ static void ft1000_reset_asic (struct net_device *dev)
 
     mdelay(1);
 
-    // set watermark to -1 in order to not generate an interrrupt
+    // set watermark to -1 in order to not generate an interrupt
     ft1000_write_register(ft1000dev, 0xffff, FT1000_REG_MAG_WATERMARK);
 
     // clear interrupts
diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index ac5d569..57500cd 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -1427,7 +1427,7 @@ static void sep_build_lli_table(struct sep_device *sep,
 
 	dev_dbg(&sep->pdev->dev, "sep_build_lli_table start\n");
 
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
index 3581a55..e231f44 100644
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
diff --git a/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h b/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h
index 64f078c..a8a8eb7 100644
--- a/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h
+++ b/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h
@@ -297,7 +297,7 @@ typedef enum cy_as_storage_event {
 	cy_as_storage_inserted,
 
 	/* This event occurs when the West Bridge device
-	 * percieves an interrrupt from an SDIO card */
+	 * percieves an interrupt from an SDIO card */
 	cy_as_sdio_interrupt
 
 } cy_as_storage_event;
diff --git a/drivers/tty/serial/mrst_max3110.c b/drivers/tty/serial/mrst_max3110.c
index b62857b..6d18830 100644
--- a/drivers/tty/serial/mrst_max3110.c
+++ b/drivers/tty/serial/mrst_max3110.c
@@ -23,7 +23,7 @@
  *    1 word. If SPI master controller doesn't support sclk frequency change,
  *    then the char need be sent out one by one with some delay
  *
- * 2. Currently only RX availabe interrrupt is used, no need for waiting TXE
+ * 2. Currently only RX availabe interrupt is used, no need for waiting TXE
  *    interrupt for a low speed UART device
  */
 
diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index 1eca8b4..acc155a 100644
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
index 2fe3046..9d8b6ff 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -698,8 +698,8 @@ static void rxstate(struct musb *musb, struct musb_request *req)
 	 * request->length is routinely more than what the host sends. For
 	 * most these gadgets, end of is signified either by a short packet,
 	 * or filling the last byte of the buffer.  (Sending extra data in
-	 * that last pckate should trigger an overflow fault.)  But in mode 1,
-	 * we don't get DMA completion interrrupt for short packets.
+	 * that last packet should trigger an overflow fault.)  But in mode 1,
+	 * we don't get DMA completion interrupt for short packets.
 	 *
 	 * Theoretically, we could enable DMAReq irq (MUSB_RXCSR_DMAMODE = 1),
 	 * to get endpoint interrupt on every DMA req, but that didn't seem
diff --git a/include/linux/pxa2xx_ssp.h b/include/linux/pxa2xx_ssp.h
index 2f691e4..84a904e 100644
--- a/include/linux/pxa2xx_ssp.h
+++ b/include/linux/pxa2xx_ssp.h
@@ -56,7 +56,7 @@
 /* PXA27x, PXA3xx */
 #define SSCR0_EDSS	(1 << 20)	/* Extended data size select */
 #define SSCR0_NCS	(1 << 21)	/* Network clock select */
-#define SSCR0_RIM	(1 << 22)	/* Receive FIFO overrrun interrupt mask */
+#define SSCR0_RIM	(1 << 22)	/* Receive FIFO overrun interrupt mask */
 #define SSCR0_TUM	(1 << 23)	/* Transmit FIFO underrun interrupt mask */
 #define SSCR0_FRDC	(0x07000000)	/* Frame rate divider control (mask) */
 #define SSCR0_SlotsPerFrm(x) (((x) - 1) << 24)	/* Time slots per frame [1..8] */
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index a1151b8..9647259 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -374,7 +374,7 @@ static int ip_frag_queue(struct ipq *qp, struct sk_buff *skb)
 	/* Is this the final fragment? */
 	if ((flags & IP_MF) == 0) {
 		/* If we already have some bits beyond end
-		 * or have different end, the segment is corrrupted.
+		 * or have different end, the segment is corrupted.
 		 */
 		if (end < qp->q.len ||
 		    ((qp->q.last_in & INET_FRAG_LAST_IN) && end != qp->q.len))
-- 
1.7.4.1

