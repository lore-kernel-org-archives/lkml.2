Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab1DGQKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 12:10:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39445 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab1DGQJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 12:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=e6IqEQ3ixfyf+6D6T0zZzYxMcKiJ1mA23s6XM5DbHzLN+SEL66o+IV8c9wA38URiMq
         0dT0veQvBt+6o1E++QZsXdGXl4o+TbwSQ26EXVjO9DFzR7Fjb8ks3iw3t1kxXa+lSg3u
         aNCw0ZsAZ5LNNIkezT6GCeUPhVIcinXAabg9Q=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 3/6]Fix typo "recieve" in various parts of the kernel. 
Date: Thu,  7 Apr 2011 09:09:24 -0700
Message-Id: <1302192567-842-3-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1302192567-842-1-git-send-email-justinmattock@gmail.com>
References: <1302192567-842-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below fixes "recieve" in various parts of the kernel.
Note: patches 2,3,4,5 are fixes to comments only(no code).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/tehuti.c                         |    2 +-
 drivers/net/wimax/i2400m/driver.c            |    2 +-
 drivers/net/wireless/ath/ath5k/reg.h         |    4 ++--
 drivers/net/wireless/ath/regd.c              |    2 +-
 drivers/net/wireless/ipw2x00/ipw2200.c       |    2 +-
 drivers/net/wireless/rt2x00/rt2x00link.c     |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.h    |    2 +-
 drivers/net/wireless/rtlwifi/regd.c          |    2 +-
 drivers/net/wireless/zd1211rw/zd_rf_uw2453.c |    2 +-
 drivers/ps3/ps3-lpm.c                        |    4 ++--
 drivers/rapidio/rio-scan.c                   |    2 +-
 drivers/scsi/aic7xxx/aic79xx.reg             |    2 +-
 drivers/scsi/be2iscsi/be_cmds.h              |   14 +++++++-------
 drivers/scsi/bfa/bfa_defs_svc.h              |    2 +-
 drivers/scsi/bfa/bfa_fc.h                    |    2 +-
 drivers/scsi/bfa/bfa_svc.c                   |    2 +-
 16 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
index 3397618..cf1568d 100644
--- a/drivers/net/tehuti.c
+++ b/drivers/net/tehuti.c
@@ -1200,7 +1200,7 @@ static void bdx_recycle_skb(struct bdx_priv *priv, struct rxd_desc *rxdd)
 	RET();
 }
 
-/* bdx_rx_receive - recieves full packets from RXD fifo and pass them to OS
+/* bdx_rx_receive - receives full packets from RXD fifo and pass them to OS
  * NOTE: a special treatment is given to non-continous descriptors
  * that start near the end, wraps around and continue at the beginning. a second
  * part is copied right after the first, and then descriptor is interpreted as
diff --git a/drivers/net/wimax/i2400m/driver.c b/drivers/net/wimax/i2400m/driver.c
index 65bc334..f510ec7 100644
--- a/drivers/net/wimax/i2400m/driver.c
+++ b/drivers/net/wimax/i2400m/driver.c
@@ -755,7 +755,7 @@ EXPORT_SYMBOL_GPL(i2400m_error_recovery);
  * Alloc the command and ack buffers for boot mode
  *
  * Get the buffers needed to deal with boot mode messages.  These
- * buffers need to be allocated before the sdio recieve irq is setup.
+ * buffers need to be allocated before the sdio receive irq is setup.
  */
 static
 int i2400m_bm_buf_alloc(struct i2400m *i2400m)
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index e1c9abd..9a717af 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -283,7 +283,7 @@
  */
 #define AR5K_ISR		0x001c			/* Register Address [5210] */
 #define AR5K_PISR		0x0080			/* Register Address [5211+] */
-#define AR5K_ISR_RXOK		0x00000001	/* Frame successfuly recieved */
+#define AR5K_ISR_RXOK		0x00000001	/* Frame successfuly received */
 #define AR5K_ISR_RXDESC		0x00000002	/* RX descriptor request */
 #define AR5K_ISR_RXERR		0x00000004	/* Receive error */
 #define AR5K_ISR_RXNOFRM	0x00000008	/* No frame received (receive timeout) */
@@ -377,7 +377,7 @@
  */
 #define	AR5K_IMR		0x0020			/* Register Address [5210] */
 #define AR5K_PIMR		0x00a0			/* Register Address [5211+] */
-#define AR5K_IMR_RXOK		0x00000001	/* Frame successfuly recieved*/
+#define AR5K_IMR_RXOK		0x00000001	/* Frame successfuly received*/
 #define AR5K_IMR_RXDESC		0x00000002	/* RX descriptor request*/
 #define AR5K_IMR_RXERR		0x00000004	/* Receive error*/
 #define AR5K_IMR_RXNOFRM	0x00000008	/* No frame received (receive timeout)*/
diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index f828f29..4c95a29 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -268,7 +268,7 @@ ath_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	}
 
 	/*
-	 * If a country IE has been recieved check its rule for this
+	 * If a country IE has been received check its rule for this
 	 * channel first before enabling active scan. The passive scan
 	 * would have been enforced by the initial processing of our
 	 * custom regulatory domain.
diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 160881f..9f862b8 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -8342,7 +8342,7 @@ static void ipw_handle_mgmt_packet(struct ipw_priv *priv,
 /*
  * Main entry function for recieving a packet with 80211 headers.  This
  * should be called when ever the FW has notified us that there is a new
- * skb in the recieve queue.
+ * skb in the receive queue.
  */
 static void ipw_rx(struct ipw_priv *priv)
 {
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index c975b0a..29abfde 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -283,7 +283,7 @@ void rt2x00link_start_tuner(struct rt2x00_dev *rt2x00dev)
 	/**
 	 * While scanning, link tuning is disabled. By default
 	 * the most sensitive settings will be used to make sure
-	 * that all beacons and probe responses will be recieved
+	 * that all beacons and probe responses will be received
 	 * during the scan.
 	 */
 	if (test_bit(DEVICE_STATE_SCANNING, &rt2x00dev->flags))
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 0c8b0c6..fa4f3cb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -365,7 +365,7 @@ enum queue_entry_flags {
  * @flags: Entry flags, see &enum queue_entry_flags.
  * @queue: The data queue (&struct data_queue) to which this entry belongs.
  * @skb: The buffer which is currently being transmitted (for TX queue),
- *	or used to directly recieve data in (for RX queue).
+ *	or used to directly receive data in (for RX queue).
  * @entry_idx: The entry index number.
  * @priv_data: Private data belonging to this queue entry. The pointer
  *	points to data specific to a particular driver and queue type.
diff --git a/drivers/net/wireless/rtlwifi/regd.c b/drivers/net/wireless/rtlwifi/regd.c
index 3336ca9..d26f957 100644
--- a/drivers/net/wireless/rtlwifi/regd.c
+++ b/drivers/net/wireless/rtlwifi/regd.c
@@ -179,7 +179,7 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	}
 
 	/*
-	 *If a country IE has been recieved check its rule for this
+	 *If a country IE has been received check its rule for this
 	 *channel first before enabling active scan. The passive scan
 	 *would have been enforced by the initial processing of our
 	 *custom regulatory domain.
diff --git a/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c b/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
index 9e74eb1..ba0a0cc 100644
--- a/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
+++ b/drivers/net/wireless/zd1211rw/zd_rf_uw2453.c
@@ -353,7 +353,7 @@ static int uw2453_init_hw(struct zd_rf *rf)
 	};
 
 	static const u32 rv[] = {
-		UW2453_REGWRITE(4, 0x2b),    /* configure reciever gain */
+		UW2453_REGWRITE(4, 0x2b),    /* configure receiver gain */
 		UW2453_REGWRITE(5, 0x19e4f), /* configure transmitter gain */
 		UW2453_REGWRITE(6, 0xf81ad), /* enable RX/TX filter tuning */
 		UW2453_REGWRITE(7, 0x3fffe), /* disable TX gain in test mode */
diff --git a/drivers/ps3/ps3-lpm.c b/drivers/ps3/ps3-lpm.c
index 8000985..1e5c4c3 100644
--- a/drivers/ps3/ps3-lpm.c
+++ b/drivers/ps3/ps3-lpm.c
@@ -919,7 +919,7 @@ EXPORT_SYMBOL_GPL(ps3_disable_pm);
  * @offset: Offset in bytes from the start of the trace buffer.
  * @buf: Copy destination.
  * @count: Maximum count of bytes to copy.
- * @bytes_copied: Pointer to a variable that will recieve the number of
+ * @bytes_copied: Pointer to a variable that will receive the number of
  *  bytes copied to @buf.
  *
  * On error @buf will contain any successfully copied trace buffer data
@@ -974,7 +974,7 @@ EXPORT_SYMBOL_GPL(ps3_lpm_copy_tb);
  * @offset: Offset in bytes from the start of the trace buffer.
  * @buf: A __user copy destination.
  * @count: Maximum count of bytes to copy.
- * @bytes_copied: Pointer to a variable that will recieve the number of
+ * @bytes_copied: Pointer to a variable that will receive the number of
  *  bytes copied to @buf.
  *
  * On error @buf will contain any successfully copied trace buffer data
diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 3a59d5f..ee89358 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -295,7 +295,7 @@ static int __devinit rio_add_device(struct rio_dev *rdev)
 }
 
 /**
- * rio_enable_rx_tx_port - enable input reciever and output transmitter of
+ * rio_enable_rx_tx_port - enable input receiver and output transmitter of
  * given port
  * @port: Master port associated with the RIO network
  * @local: local=1 select local port otherwise a far device is reached
diff --git a/drivers/scsi/aic7xxx/aic79xx.reg b/drivers/scsi/aic7xxx/aic79xx.reg
index 0666c22..3c7f5a3 100644
--- a/drivers/scsi/aic7xxx/aic79xx.reg
+++ b/drivers/scsi/aic7xxx/aic79xx.reg
@@ -1249,7 +1249,7 @@ register TARGPCISTAT {
 
 /*
  * LQ Packet In
- * The last LQ Packet recieved
+ * The last LQ Packet received
  */
 register LQIN {
 	address			0x020
diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 5218de4..17cb16d 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -877,7 +877,7 @@ struct be_all_if_id {
 						 */
 #define CXN_KILLED_PDU_SIZE_EXCEEDS_DSL 3	/* Connection got invalidated
 						 * internally
-						 * due to a recieved PDU
+						 * due to a received PDU
 						 * size > DSL
 						 */
 #define CXN_KILLED_BURST_LEN_MISMATCH   4	/* Connection got invalidated
@@ -886,7 +886,7 @@ struct be_all_if_id {
 						 * FBL/MBL.
 						 */
 #define CXN_KILLED_AHS_RCVD		5	/* Connection got invalidated
-						 * internally due to a recieved
+						 * internally due to a received
 						 * PDU Hdr that has
 						 * AHS */
 #define CXN_KILLED_HDR_DIGEST_ERR	6	/* Connection got invalidated
@@ -899,12 +899,12 @@ struct be_all_if_id {
 						 * pdu hdr
 						 */
 #define CXN_KILLED_STALE_ITT_TTT_RCVD	8	/* Connection got invalidated
-						 * internally due to a recieved
+						 * internally due to a received
 						 * ITT/TTT that does not belong
 						 * to this Connection
 						 */
 #define CXN_KILLED_INVALID_ITT_TTT_RCVD 9	/* Connection got invalidated
-						 * internally due to recieved
+						 * internally due to received
 						 * ITT/TTT value > Max
 						 * Supported ITTs/TTTs
 						 */
@@ -946,11 +946,11 @@ struct be_all_if_id {
 						 * run bytes.
 						 */
 #define CMD_KILLED_INVALID_STATSN_RCVD	18	/* Command got invalidated
-						 * internally due to a recieved
+						 * internally due to a received
 						 * PDU has an invalid StatusSN
 						 */
 #define CMD_KILLED_INVALID_R2T_RCVD	19	/* Command got invalidated
-						 * internally due to a recieved
+						 * internally due to a received
 						 * an R2T with some invalid
 						 * fields in it
 						 */
@@ -973,7 +973,7 @@ struct be_all_if_id {
 						 */
 #define CMD_CXN_KILLED_INVALID_DATASN_RCVD 24	/* Command got invalidated
 						 * internally due to a
-						 * recieved PDU has an invalid
+						 * received PDU has an invalid
 						 * DataSN
 						 */
 #define CXN_INVALIDATE_NOTIFY		25	/* Connection invalidation
diff --git a/drivers/scsi/bfa/bfa_defs_svc.h b/drivers/scsi/bfa/bfa_defs_svc.h
index 648c841..56399be 100644
--- a/drivers/scsi/bfa/bfa_defs_svc.h
+++ b/drivers/scsi/bfa/bfa_defs_svc.h
@@ -145,7 +145,7 @@ struct bfa_fw_io_stats_s {
 	u32	ioh_data_oor_event;	/*  Data out of range */
 	u32	ioh_ro_ooo_event;	/*  Relative offset out of range */
 	u32	ioh_cpu_owned_event;	/*  IOH hit -iost owned by f/w */
-	u32	ioh_unexp_frame_event;	/*  unexpected frame recieved
+	u32	ioh_unexp_frame_event;	/*  unexpected frame received
 						 *   count */
 	u32	ioh_err_int;		/*  IOH error int during data-phase
 						 *   for scsi write
diff --git a/drivers/scsi/bfa/bfa_fc.h b/drivers/scsi/bfa/bfa_fc.h
index 8e764fa..bf0067e 100644
--- a/drivers/scsi/bfa/bfa_fc.h
+++ b/drivers/scsi/bfa/bfa_fc.h
@@ -315,7 +315,7 @@ struct fc_plogi_csp_s {
 			query_dbc:1,
 			hg_supp:1;
 #endif
-	__be16		rxsz;		/* recieve data_field size */
+	__be16		rxsz;		/* receive data_field size */
 	__be16		conseq;
 	__be16		ro_bitmap;
 	__be32		e_d_tov;
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 1d34921..f8debef 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -5022,7 +5022,7 @@ bfa_uf_start(struct bfa_s *bfa)
 }
 
 /*
- * Register handler for all unsolicted recieve frames.
+ * Register handler for all unsolicted receive frames.
  *
  * @param[in]	bfa		BFA instance
  * @param[in]	ufrecv	receive handler function
-- 
1.7.4.2

