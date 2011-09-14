Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112Ab1INUAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:00:07 -0400
Received: from mail-gx0-f170.google.com ([209.85.161.170]:44162 "EHLO
	mail-gx0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611Ab1INUAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:00:04 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/3]Fix typos in the kernel 
Date: Wed, 14 Sep 2011 12:52:47 -0700
Message-Id: <1316029968-11277-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1316029968-11277-1-git-send-email-justinmattock@gmail.com>
References: <1316029968-11277-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch fixes some typos that I have found in the kernel.
Note:not sure if I am able to send this, due to kernel.org being down.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/message/fusion/lsi/mpi_ioc.h        |    2 +-
 drivers/net/arm/ks8695net.c                 |    2 +-
 drivers/net/atlx/atl1.c                     |    2 +-
 drivers/net/cs89x0.c                        |    2 +-
 drivers/net/irda/nsc-ircc.c                 |    2 +-
 drivers/net/irda/via-ircc.c                 |    4 ++--
 drivers/net/irda/w83977af_ir.c              |    2 +-
 drivers/net/qlge/qlge_main.c                |    2 +-
 drivers/net/sky2.c                          |    2 +-
 drivers/net/tile/tilepro.c                  |    2 +-
 drivers/net/wimax/i2400m/i2400m.h           |    2 +-
 drivers/net/wireless/rtlwifi/pci.c          |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c |    4 ++--
 drivers/parport/parport_mfc3.c              |    2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm.c        |    2 +-
 drivers/scsi/ips.c                          |    2 +-
 drivers/scsi/qla4xxx/ql4_fw.h               |    2 +-
 drivers/scsi/vmw_pvscsi.c                   |    2 +-
 18 files changed, 20 insertions(+), 20 deletions(-)

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
diff --git a/drivers/net/arm/ks8695net.c b/drivers/net/arm/ks8695net.c
index c827a60..8d0baec 100644
--- a/drivers/net/arm/ks8695net.c
+++ b/drivers/net/arm/ks8695net.c
@@ -414,7 +414,7 @@ ks8695_tx_irq(int irq, void *dev_id)
  *    Interrupt Status Register (Offset 0xF208)
  *        Bit29: WAN MAC Receive Status
  *        Bit16: LAN MAC Receive Status
- *    So, this Rx interrrupt enable/status bit number is equal
+ *    So, this Rx interrupt enable/status bit number is equal
  *    as Rx IRQ number.
  */
 static inline u32 ks8695_get_rx_enable_bit(struct ks8695_priv *ksp)
diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 97e6954..9f3e530 100644
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
diff --git a/drivers/net/cs89x0.c b/drivers/net/cs89x0.c
index 537a4b2..afbfd8c 100644
--- a/drivers/net/cs89x0.c
+++ b/drivers/net/cs89x0.c
@@ -1341,7 +1341,7 @@ release_irq:
                 if (result==DETECTED_NONE) {
                         printk(KERN_WARNING "%s: 10Base-5 (AUI) has no cable\n", dev->name);
                         if (lp->auto_neg_cnf & IMM_BIT) /* check "ignore missing media" bit */
-                                result = DETECTED_AUI; /* Yes! I don't care if I see a carrrier */
+                                result = DETECTED_AUI; /* Yes! I don't care if I see a carrier */
                 }
 		break;
 	case A_CNF_MEDIA_10B_2:
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
 		
diff --git a/drivers/net/qlge/qlge_main.c b/drivers/net/qlge/qlge_main.c
index f07e96e..8897c8d 100644
--- a/drivers/net/qlge/qlge_main.c
+++ b/drivers/net/qlge/qlge_main.c
@@ -2066,7 +2066,7 @@ static unsigned long ql_process_mac_rx_intr(struct ql_adapter *qdev,
 						length, vlan_id);
 	} else {
 		/* Non-TCP/UDP large frames that span multiple buffers
-		 * can be processed corrrectly by the split frame logic.
+		 * can be processed correctly by the split frame logic.
 		 */
 		ql_process_mac_split_rx_intr(qdev, rx_ring, ib_mac_rsp,
 						vlan_id);
diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 57339da..d7f879d 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -2057,7 +2057,7 @@ static void sky2_hw_down(struct sky2_port *sky2)
 
 	sky2_write8(hw, SK_REG(port, RX_GMF_CTRL_T), GMF_RST_SET);
 
-	/* Force any delayed status interrrupt and NAPI */
+	/* Force any delayed status interrupt and NAPI */
 	sky2_write32(hw, STAT_LEV_TIMER_CNT, 0);
 	sky2_write32(hw, STAT_TX_TIMER_CNT, 0);
 	sky2_write32(hw, STAT_ISR_TIMER_CNT, 0);
diff --git a/drivers/net/tile/tilepro.c b/drivers/net/tile/tilepro.c
index 1e2af96..7b46e75d 100644
--- a/drivers/net/tile/tilepro.c
+++ b/drivers/net/tile/tilepro.c
@@ -177,7 +177,7 @@ struct tile_net_cpu {
 	struct tile_net_stats_t stats;
 	/* True iff NAPI is enabled. */
 	bool napi_enabled;
-	/* True if this tile has succcessfully registered with the IPP. */
+	/* True if this tile has successfully registered with the IPP. */
 	bool registered;
 	/* True if the link was down last time we tried to register. */
 	bool link_down;
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
diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 56f1235..9ced572 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1559,7 +1559,7 @@ static void rtl_pci_stop(struct ieee80211_hw *hw)
 	u8 RFInProgressTimeOut = 0;
 
 	/*
-	 *should before disable interrrupt&adapter
+	 *should before disable interrupt&adapter
 	 *and will do it immediately.
 	 */
 	set_hal_stop(rtlhal);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/rtlwifi/rtl8192de/hw.c
index 0073cf1..4e4ca20 100644
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
+/* ASSUMED to be called from within a lock                                  */
 /*                                                                          */
 /****************************************************************************/
 static ips_scb_t *
diff --git a/drivers/scsi/qla4xxx/ql4_fw.h b/drivers/scsi/qla4xxx/ql4_fw.h
index 01082aa..76e7c14 100644
--- a/drivers/scsi/qla4xxx/ql4_fw.h
+++ b/drivers/scsi/qla4xxx/ql4_fw.h
@@ -616,7 +616,7 @@ struct dev_db_entry {
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
-- 
1.7.6

