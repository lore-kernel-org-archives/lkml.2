Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab1GGWAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 18:00:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39079 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab1GGWAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 18:00:08 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/2] staging: et131x: Convert et1310_address_map.h names from camel case
Date: Thu,  7 Jul 2011 22:59:04 +0100
Message-Id: <1310075944-2679-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1310075944-2679-1-git-send-email-mark.einon@gmail.com>
References: <1310075944-2679-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial name changes.
Tested on an ET-131x device.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_address_map.h |  122 +++++++++++++-------------
 drivers/staging/et131x/et1310_mac.c         |  108 ++++++++++++------------
 drivers/staging/et131x/et1310_tx.c          |    2 +-
 drivers/staging/et131x/et131x_isr.c         |    2 +-
 4 files changed, 117 insertions(+), 117 deletions(-)

diff --git a/drivers/staging/et131x/et1310_address_map.h b/drivers/staging/et131x/et1310_address_map.h
index a925300..a02335a 100644
--- a/drivers/staging/et131x/et1310_address_map.h
+++ b/drivers/staging/et131x/et1310_address_map.h
@@ -267,19 +267,19 @@ struct txdma_regs {			/* Location: */
 	u32 service_complete;		/*  0x1028 */
 	u32 cache_rd_index;		/*  0x102C */
 	u32 cache_wr_index;		/*  0x1030 */
-	u32 TxDmaError;			/*  0x1034 */
-	u32 DescAbortCount;		/*  0x1038 */
-	u32 PayloadAbortCnt;		/*  0x103c */
-	u32 WriteBackAbortCnt;		/*  0x1040 */
-	u32 DescTimeoutCnt;		/*  0x1044 */
-	u32 PayloadTimeoutCnt;		/*  0x1048 */
-	u32 WriteBackTimeoutCnt;	/*  0x104c */
-	u32 DescErrorCount;		/*  0x1050 */
-	u32 PayloadErrorCnt;		/*  0x1054 */
-	u32 WriteBackErrorCnt;		/*  0x1058 */
-	u32 DroppedTLPCount;		/*  0x105c */
-	u32 NewServiceComplete;		/*  0x1060 */
-	u32 EthernetPacketCount;	/*  0x1064 */
+	u32 tx_dma_error;		/*  0x1034 */
+	u32 desc_abort_cnt;		/*  0x1038 */
+	u32 payload_abort_cnt;		/*  0x103c */
+	u32 writeback_abort_cnt;	/*  0x1040 */
+	u32 desc_timeout_cnt;		/*  0x1044 */
+	u32 payload_timeout_cnt;	/*  0x1048 */
+	u32 writeback_timeout_cnt;	/*  0x104c */
+	u32 desc_error_cnt;		/*  0x1050 */
+	u32 payload_error_cnt;		/*  0x1054 */
+	u32 writeback_error_cnt;	/*  0x1058 */
+	u32 dropped_tlp_cnt;		/*  0x105c */
+	u32 new_service_complete;	/*  0x1060 */
+	u32 ethernet_packet_cnt;	/*  0x1064 */
 };
 
 /* END OF TXDMA REGISTER ADDRESS MAP */
@@ -1204,148 +1204,148 @@ struct macstat_regs {			/* Location: */
 	u32 pad[32];			/*  0x6000 - 607C */
 
 	/* Tx/Rx 0-64 Byte Frame Counter */
-	u32 TR64;			/*  0x6080 */
+	u32 txrx_0_64_byte_frames;	/*  0x6080 */
 
 	/* Tx/Rx 65-127 Byte Frame Counter */
-	u32 TR127;			/*  0x6084 */
+	u32 txrx_65_127_byte_frames;	/*  0x6084 */
 
 	/* Tx/Rx 128-255 Byte Frame Counter */
-	u32 TR255;			/*  0x6088 */
+	u32 txrx_128_255_byte_frames;	/*  0x6088 */
 
 	/* Tx/Rx 256-511 Byte Frame Counter */
-	u32 TR511;			/*  0x608C */
+	u32 txrx_256_511_byte_frames;	/*  0x608C */
 
 	/* Tx/Rx 512-1023 Byte Frame Counter */
-	u32 TR1K;			/*  0x6090 */
+	u32 txrx_512_1023_byte_frames;	/*  0x6090 */
 
 	/* Tx/Rx 1024-1518 Byte Frame Counter */
-	u32 TRMax;			/*  0x6094 */
+	u32 txrx_1024_1518_byte_frames;	/*  0x6094 */
 
 	/* Tx/Rx 1519-1522 Byte Good VLAN Frame Count */
-	u32 TRMgv;			/*  0x6098 */
+	u32 txrx_1519_1522_gvln_frames;	/*  0x6098 */
 
 	/* Rx Byte Counter */
-	u32 RByt;			/*  0x609C */
+	u32 rx_bytes;	 		/*  0x609C */
 
 	/* Rx Packet Counter */
-	u32 RPkt;			/*  0x60A0 */
+	u32 rx_packets;			/*  0x60A0 */
 
 	/* Rx FCS Error Counter */
-	u32 RFcs;			/*  0x60A4 */
+	u32 rx_fcs_errs;		/*  0x60A4 */
 
 	/* Rx Multicast Packet Counter */
-	u32 RMca;			/*  0x60A8 */
+	u32 rx_multicast_packets;	/*  0x60A8 */
 
 	/* Rx Broadcast Packet Counter */
-	u32 RBca;			/*  0x60AC */
+	u32 rx_broadcast_packets;	/*  0x60AC */
 
 	/* Rx Control Frame Packet Counter */
-	u32 RxCf;			/*  0x60B0 */
+	u32 rx_control_frames; 		/*  0x60B0 */
 
 	/* Rx Pause Frame Packet Counter */
-	u32 RxPf;			/*  0x60B4 */
+	u32 rx_pause_frames;		/*  0x60B4 */
 
 	/* Rx Unknown OP Code Counter */
-	u32 RxUo;			/*  0x60B8 */
+	u32 rx_unknown_opcodes;		/*  0x60B8 */
 
 	/* Rx Alignment Error Counter */
-	u32 RAln;			/*  0x60BC */
+	u32 rx_align_errs;		/*  0x60BC */
 
 	/* Rx Frame Length Error Counter */
-	u32 RFlr;			/*  0x60C0 */
+	u32 rx_frame_len_errs;		/*  0x60C0 */
 
 	/* Rx Code Error Counter */
-	u32 RCde;			/*  0x60C4 */
+	u32 rx_code_errs;		/*  0x60C4 */
 
 	/* Rx Carrier Sense Error Counter */
-	u32 RCse;			/*  0x60C8 */
+	u32 rx_carrier_sense_errs;	/*  0x60C8 */
 
 	/* Rx Undersize Packet Counter */
-	u32 RUnd;			/*  0x60CC */
+	u32 rx_undersize_packets;	/*  0x60CC */
 
 	/* Rx Oversize Packet Counter */
-	u32 ROvr;			/*  0x60D0 */
+	u32 rx_oversize_packets;	/*  0x60D0 */
 
 	/* Rx Fragment Counter */
-	u32 RFrg;			/*  0x60D4 */
+	u32 rx_fragment_packets;	/*  0x60D4 */
 
 	/* Rx Jabber Counter */
-	u32 RJbr;			/*  0x60D8 */
+	u32 rx_jabbers;			/*  0x60D8 */
 
 	/* Rx Drop */
-	u32 RDrp;			/*  0x60DC */
+	u32 rx_drops;			/*  0x60DC */
 
 	/* Tx Byte Counter */
-	u32 TByt;			/*  0x60E0 */
+	u32 tx_bytes;	 		/*  0x60E0 */
 
 	/* Tx Packet Counter */
-	u32 TPkt;			/*  0x60E4 */
+	u32 tx_packets;			/*  0x60E4 */
 
 	/* Tx Multicast Packet Counter */
-	u32 TMca;			/*  0x60E8 */
+	u32 tx_multicast_packets;	/*  0x60E8 */
 
 	/* Tx Broadcast Packet Counter */
-	u32 TBca;			/*  0x60EC */
+	u32 tx_broadcast_packets;	/*  0x60EC */
 
 	/* Tx Pause Control Frame Counter */
-	u32 TxPf;			/*  0x60F0 */
+	u32 tx_pause_frames;		/*  0x60F0 */
 
 	/* Tx Deferral Packet Counter */
-	u32 TDfr;			/*  0x60F4 */
+	u32 tx_deferred;		/*  0x60F4 */
 
 	/* Tx Excessive Deferral Packet Counter */
-	u32 TEdf;			/*  0x60F8 */
+	u32 tx_excessive_deferred;	/*  0x60F8 */
 
 	/* Tx Single Collision Packet Counter */
-	u32 TScl;			/*  0x60FC */
+	u32 tx_single_collisions;	/*  0x60FC */
 
 	/* Tx Multiple Collision Packet Counter */
-	u32 TMcl;			/*  0x6100 */
+	u32 tx_multiple_collisions;	/*  0x6100 */
 
 	/* Tx Late Collision Packet Counter */
-	u32 TLcl;			/*  0x6104 */
+	u32 tx_late_collisions;		/*  0x6104 */
 
 	/* Tx Excessive Collision Packet Counter */
-	u32 TXcl;			/*  0x6108 */
+	u32 tx_excessive_collisions;	/*  0x6108 */
 
 	/* Tx Total Collision Packet Counter */
-	u32 TNcl;			/*  0x610C */
+	u32 tx_total_collisions;	/*  0x610C */
 
 	/* Tx Pause Frame Honored Counter */
-	u32 TPfh;			/*  0x6110 */
+	u32 tx_pause_honored_frames;	/*  0x6110 */
 
 	/* Tx Drop Frame Counter */
-	u32 TDrp;			/*  0x6114 */
+	u32 tx_drops;			/*  0x6114 */
 
 	/* Tx Jabber Frame Counter */
-	u32 TJbr;			/*  0x6118 */
+	u32 tx_jabbers;			/*  0x6118 */
 
 	/* Tx FCS Error Counter */
-	u32 TFcs;			/*  0x611C */
+	u32 tx_fcs_errs;		/*  0x611C */
 
 	/* Tx Control Frame Counter */
-	u32 TxCf;			/*  0x6120 */
+	u32 tx_control_frames;		/*  0x6120 */
 
 	/* Tx Oversize Frame Counter */
-	u32 TOvr;			/*  0x6124 */
+	u32 tx_oversize_frames;		/*  0x6124 */
 
 	/* Tx Undersize Frame Counter */
-	u32 TUnd;			/*  0x6128 */
+	u32 tx_undersize_frames;	/*  0x6128 */
 
 	/* Tx Fragments Frame Counter */
-	u32 TFrg;			/*  0x612C */
+	u32 tx_fragments;		/*  0x612C */
 
 	/* Carry Register One Register */
-	u32 Carry1;			/*  0x6130 */
+	u32 carry_reg1;			/*  0x6130 */
 
 	/* Carry Register Two Register */
-	u32 Carry2;			/*  0x6134 */
+	u32 carry_reg2;	 		/*  0x6134 */
 
 	/* Carry Register One Mask Register */
-	u32 Carry1M;			/*  0x6138 */
+	u32 carry_reg1_mask;		/*  0x6138 */
 
 	/* Carry Register Two Mask Register */
-	u32 Carry2M;			/*  0x613C */
+	u32 carry_reg2_mask;		/*  0x613C */
 };
 
 /* END OF MAC STAT REGISTER ADDRESS MAP */
diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index e6c243a..dc3e062 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -384,31 +384,31 @@ void ConfigMacStatRegs(struct et131x_adapter *etdev)
 	struct macstat_regs __iomem *macstat =
 		&etdev->regs->macstat;
 
-	/* Next we need to initialize all the MAC_STAT registers to zero on
+	/* Next we need to initialize all the macstat registers to zero on
 	 * the device.
 	 */
-	writel(0, &macstat->RFcs);
-	writel(0, &macstat->RAln);
-	writel(0, &macstat->RFlr);
-	writel(0, &macstat->RDrp);
-	writel(0, &macstat->RCde);
-	writel(0, &macstat->ROvr);
-	writel(0, &macstat->RFrg);
-
-	writel(0, &macstat->TScl);
-	writel(0, &macstat->TDfr);
-	writel(0, &macstat->TMcl);
-	writel(0, &macstat->TLcl);
-	writel(0, &macstat->TNcl);
-	writel(0, &macstat->TOvr);
-	writel(0, &macstat->TUnd);
+	writel(0, &macstat->rx_fcs_errs);
+	writel(0, &macstat->rx_align_errs);
+	writel(0, &macstat->rx_frame_len_errs);
+	writel(0, &macstat->rx_code_errs);
+	writel(0, &macstat->rx_drops);
+	writel(0, &macstat->rx_oversize_packets);
+	writel(0, &macstat->rx_fragment_packets);
+
+	writel(0, &macstat->tx_deferred);
+	writel(0, &macstat->tx_single_collisions);
+	writel(0, &macstat->tx_multiple_collisions);
+	writel(0, &macstat->tx_late_collisions);
+	writel(0, &macstat->tx_total_collisions);
+	writel(0, &macstat->tx_oversize_frames);
+	writel(0, &macstat->tx_undersize_frames);
 
 	/* Unmask any counters that we want to track the overflow of.
 	 * Initially this will be all counters.  It may become clear later
 	 * that we do not need to track all counters.
 	 */
-	writel(0xFFFFBE32, &macstat->Carry1M);
-	writel(0xFFFE7E8B, &macstat->Carry2M);
+	writel(0xFFFFBE32, &macstat->carry_reg1_mask);
+	writel(0xFFFE7E8B, &macstat->carry_reg2_mask);
 }
 
 void ConfigFlowControl(struct et131x_adapter *etdev)
@@ -456,22 +456,22 @@ void UpdateMacStatHostCounters(struct et131x_adapter *etdev)
 	struct macstat_regs __iomem *macstat =
 		&etdev->regs->macstat;
 
-	stats->collisions += readl(&macstat->TNcl);
-	stats->first_collision += readl(&macstat->TScl);
-	stats->tx_deferred += readl(&macstat->TDfr);
-	stats->excessive_collisions += readl(&macstat->TMcl);
-	stats->late_collisions += readl(&macstat->TLcl);
-	stats->tx_uflo += readl(&macstat->TUnd);
-	stats->max_pkt_error += readl(&macstat->TOvr);
-
-	stats->alignment_err += readl(&macstat->RAln);
-	stats->crc_err += readl(&macstat->RCde);
-	stats->norcvbuf += readl(&macstat->RDrp);
-	stats->rx_ov_flow += readl(&macstat->ROvr);
-	stats->code_violations += readl(&macstat->RFcs);
-	stats->length_err += readl(&macstat->RFlr);
-
-	stats->other_errors += readl(&macstat->RFrg);
+	stats->collisions += readl(&macstat->tx_total_collisions);
+	stats->first_collision += readl(&macstat->tx_single_collisions);
+	stats->tx_deferred += readl(&macstat->tx_deferred);
+	stats->excessive_collisions += readl(&macstat->tx_multiple_collisions);
+	stats->late_collisions += readl(&macstat->tx_late_collisions);
+	stats->tx_uflo += readl(&macstat->tx_undersize_frames);
+	stats->max_pkt_error += readl(&macstat->tx_oversize_frames);
+
+	stats->alignment_err += readl(&macstat->rx_align_errs);
+	stats->crc_err += readl(&macstat->rx_code_errs);
+	stats->norcvbuf += readl(&macstat->rx_drops);
+	stats->rx_ov_flow += readl(&macstat->rx_oversize_packets);
+	stats->code_violations += readl(&macstat->rx_fcs_errs);
+	stats->length_err += readl(&macstat->rx_frame_len_errs);
+
+	stats->other_errors += readl(&macstat->rx_fragment_packets);
 }
 
 /**
@@ -484,17 +484,17 @@ void UpdateMacStatHostCounters(struct et131x_adapter *etdev)
  */
 void HandleMacStatInterrupt(struct et131x_adapter *etdev)
 {
-	u32 Carry1;
-	u32 Carry2;
+	u32 carry_reg1;
+	u32 carry_reg2;
 
 	/* Read the interrupt bits from the register(s).  These are Clear On
 	 * Write.
 	 */
-	Carry1 = readl(&etdev->regs->macstat.Carry1);
-	Carry2 = readl(&etdev->regs->macstat.Carry2);
+	carry_reg1 = readl(&etdev->regs->macstat.carry_reg1);
+	carry_reg2 = readl(&etdev->regs->macstat.carry_reg2);
 
-	writel(Carry1, &etdev->regs->macstat.Carry1);
-	writel(Carry2, &etdev->regs->macstat.Carry2);
+	writel(carry_reg2, &etdev->regs->macstat.carry_reg1);
+	writel(carry_reg2, &etdev->regs->macstat.carry_reg2);
 
 	/* We need to do update the host copy of all the MAC_STAT counters.
 	 * For each counter, check it's overflow bit.  If the overflow bit is
@@ -502,33 +502,33 @@ void HandleMacStatInterrupt(struct et131x_adapter *etdev)
 	 * revolution of the counter.  This routine is called when the counter
 	 * block indicates that one of the counters has wrapped.
 	 */
-	if (Carry1 & (1 << 14))
+	if (carry_reg1 & (1 << 14))
 		etdev->stats.code_violations += COUNTER_WRAP_16_BIT;
-	if (Carry1 & (1 << 8))
+	if (carry_reg1 & (1 << 8))
 		etdev->stats.alignment_err += COUNTER_WRAP_12_BIT;
-	if (Carry1 & (1 << 7))
+	if (carry_reg1 & (1 << 7))
 		etdev->stats.length_err += COUNTER_WRAP_16_BIT;
-	if (Carry1 & (1 << 2))
+	if (carry_reg1 & (1 << 2))
 		etdev->stats.other_errors += COUNTER_WRAP_16_BIT;
-	if (Carry1 & (1 << 6))
+	if (carry_reg1 & (1 << 6))
 		etdev->stats.crc_err += COUNTER_WRAP_16_BIT;
-	if (Carry1 & (1 << 3))
+	if (carry_reg1 & (1 << 3))
 		etdev->stats.rx_ov_flow += COUNTER_WRAP_16_BIT;
-	if (Carry1 & (1 << 0))
+	if (carry_reg1 & (1 << 0))
 		etdev->stats.norcvbuf += COUNTER_WRAP_16_BIT;
-	if (Carry2 & (1 << 16))
+	if (carry_reg2 & (1 << 16))
 		etdev->stats.max_pkt_error += COUNTER_WRAP_12_BIT;
-	if (Carry2 & (1 << 15))
+	if (carry_reg2 & (1 << 15))
 		etdev->stats.tx_uflo += COUNTER_WRAP_12_BIT;
-	if (Carry2 & (1 << 6))
+	if (carry_reg2 & (1 << 6))
 		etdev->stats.first_collision += COUNTER_WRAP_12_BIT;
-	if (Carry2 & (1 << 8))
+	if (carry_reg2 & (1 << 8))
 		etdev->stats.tx_deferred += COUNTER_WRAP_12_BIT;
-	if (Carry2 & (1 << 5))
+	if (carry_reg2 & (1 << 5))
 		etdev->stats.excessive_collisions += COUNTER_WRAP_12_BIT;
-	if (Carry2 & (1 << 4))
+	if (carry_reg2 & (1 << 4))
 		etdev->stats.late_collisions += COUNTER_WRAP_12_BIT;
-	if (Carry2 & (1 << 2))
+	if (carry_reg2 & (1 << 2))
 		etdev->stats.collisions += COUNTER_WRAP_12_BIT;
 }
 
diff --git a/drivers/staging/et131x/et1310_tx.c b/drivers/staging/et131x/et1310_tx.c
index 8b1af64..8fb3051 100644
--- a/drivers/staging/et131x/et1310_tx.c
+++ b/drivers/staging/et131x/et1310_tx.c
@@ -747,7 +747,7 @@ void et131x_handle_send_interrupt(struct et131x_adapter *etdev)
 	struct tcb *tcb;
 	u32 index;
 
-	serviced = readl(&etdev->regs->txdma.NewServiceComplete);
+	serviced = readl(&etdev->regs->txdma.new_service_complete);
 	index = INDEX10(serviced);
 
 	/* Has the ring wrapped?  Process any descriptors that do not have
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index 0a5ce80..9c33209 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -268,7 +268,7 @@ void et131x_isr_handler(struct work_struct *work)
 			u32 txdma_err;
 
 			/* Following read also clears the register (COR) */
-			txdma_err = readl(&iomem->txdma.TxDmaError);
+			txdma_err = readl(&iomem->txdma.tx_dma_error);
 
 			dev_warn(&etdev->pdev->dev,
 				    "TXDMA_ERR interrupt, error = %d\n",
-- 
1.7.4.4

