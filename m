Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215Ab1DGQKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 12:10:37 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63563 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab1DGQJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 12:09:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bkCdsAP4R6o2YNctyglS86S6FYtvVf1brvPmhj2ZUrb7eeQgg+cXS1YQdSdG0rArDj
         yq8u1EB7CJmmi5GeTrYhrJi0xPrkOVD+mg939XevxNyKBuX9Xkgy2vPxdPQ7RnJym0t3
         UNZv3pxi5o9HhPtSShX0sRkgbwPspe+sR1txo=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 4/6]Fix typo "recieve" in various parts of the kernel.
Date: Thu,  7 Apr 2011 09:09:25 -0700
Message-Id: <1302192567-842-4-git-send-email-justinmattock@gmail.com>
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
 drivers/scsi/cxgbi/libcxgbi.h        |    6 +++---
 drivers/scsi/libfc/fc_lport.c        |    2 +-
 drivers/scsi/lpfc/lpfc_bsg.c         |    2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c     |    4 ++--
 drivers/scsi/lpfc/lpfc_sli.c         |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    2 +-
 drivers/scsi/qla2xxx/qla_fw.h        |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c       |    2 +-
 drivers/scsi/qla4xxx/ql4_def.h       |    2 +-
 drivers/tty/mxser.h                  |    2 +-
 drivers/usb/class/usbtmc.c           |    2 +-
 drivers/usb/gadget/fsl_qe_udc.h      |    2 +-
 drivers/usb/host/fhci-tds.c          |    2 +-
 drivers/usb/host/oxu210hp-hcd.c      |    4 ++--
 14 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 0a20fd5..9267844 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -262,9 +262,9 @@ struct cxgbi_skb_tx_cb {
 enum cxgbi_skcb_flags {
 	SKCBF_TX_NEED_HDR,	/* packet needs a header */
 	SKCBF_RX_COALESCED,	/* received whole pdu */
-	SKCBF_RX_HDR,		/* recieved pdu header */
-	SKCBF_RX_DATA,		/* recieved pdu payload */
-	SKCBF_RX_STATUS,	/* recieved ddp status */
+	SKCBF_RX_HDR,		/* received pdu header */
+	SKCBF_RX_DATA,		/* received pdu payload */
+	SKCBF_RX_STATUS,	/* received ddp status */
 	SKCBF_RX_DATA_DDPD,	/* pdu payload ddp'd */
 	SKCBF_RX_HCRC_ERR,	/* header digest error */
 	SKCBF_RX_DCRC_ERR,	/* data digest error */
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 8c08b21..7651c8a 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -771,7 +771,7 @@ EXPORT_SYMBOL(fc_lport_set_local_id);
 
 /**
  * fc_lport_recv_flogi_req() - Receive a FLOGI request
- * @lport: The local port that recieved the request
+ * @lport: The local port that received the request
  * @rx_fp: The FLOGI frame
  *
  * A received FLOGI request indicates a point-to-point connection.
diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 793b9f1..77b2871 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1939,7 +1939,7 @@ out:
  * @rxxri: Receive exchange id
  * @len: Number of data bytes
  *
- * This function allocates and posts a data buffer of sufficient size to recieve
+ * This function allocates and posts a data buffer of sufficient size to receive
  * an unsolicted CT command.
  **/
 static int lpfcdiag_loop_post_rxbufs(struct lpfc_hba *phba, uint16_t rxxri,
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 154c715..1dbeadc 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4477,7 +4477,7 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 	if ((vport->fc_flag & FC_RSCN_MODE) &&
 	    !(vport->fc_flag & FC_NDISC_ACTIVE)) {
 		if (lpfc_rscn_payload_check(vport, did)) {
-			/* If we've already recieved a PLOGI from this NPort
+			/* If we've already received a PLOGI from this NPort
 			 * we don't need to try to discover it again.
 			 */
 			if (ndlp->nlp_flag & NLP_RCV_PLOGI)
@@ -4493,7 +4493,7 @@ lpfc_setup_disc_node(struct lpfc_vport *vport, uint32_t did)
 		} else
 			ndlp = NULL;
 	} else {
-		/* If we've already recieved a PLOGI from this NPort,
+		/* If we've already received a PLOGI from this NPort,
 		 * or we are already in the process of discovery on it,
 		 * we don't need to try to discover it again.
 		 */
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 4746dcd..d5791e7 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -9684,7 +9684,7 @@ out:
  * @cq: Pointer to the completion queue.
  * @wcqe: Pointer to a completion queue entry.
  *
- * This routine process a slow-path work-queue or recieve queue completion queue
+ * This routine process a slow-path work-queue or receive queue completion queue
  * entry.
  *
  * Return: true if work posted to worker thread, otherwise false.
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 6ceb775..b26502f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2984,7 +2984,7 @@ _scsih_check_for_pending_tm(struct MPT2SAS_ADAPTER *ioc, u16 smid)
  *
  * This routine added to better handle cable breaker.
  *
- * This handles the case where driver recieves multiple expander
+ * This handles the case where driver receives multiple expander
  * add and delete events in a single shot.  When there is a delete event
  * the routine will void any pending add events waiting in the event queue.
  *
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 631fefc..f5ba09c 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -539,7 +539,7 @@ struct sts_entry_24xx {
 	 * If DIF Error is set in comp_status, these additional fields are
 	 * defined:
 	 * &data[10] : uint8_t report_runt_bg[2];	- computed guard
-	 * &data[12] : uint8_t actual_dif[8];		- DIF Data recieved
+	 * &data[12] : uint8_t actual_dif[8];		- DIF Data received
 	 * &data[20] : uint8_t expected_dif[8];		- DIF Data computed
 	*/
 };
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7a7c0ec..6accb11 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3789,7 +3789,7 @@ qla2x00_loopback_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 	mcp->mb[20] = LSW(MSD(mreq->send_dma));
 	mcp->mb[21] = MSW(MSD(mreq->send_dma));
 
-	/* recieve data address */
+	/* receive data address */
 	mcp->mb[16] = LSW(mreq->rcv_dma);
 	mcp->mb[17] = MSW(mreq->rcv_dma);
 	mcp->mb[6] = LSW(MSD(mreq->rcv_dma));
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index c1f8d1b..4757878 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -182,7 +182,7 @@ struct srb {
 	uint16_t flags;		/* (1) Status flags. */
 
 #define SRB_DMA_VALID		BIT_3	/* DMA Buffer mapped. */
-#define SRB_GOT_SENSE		BIT_4	/* sense data recieved. */
+#define SRB_GOT_SENSE		BIT_4	/* sense data received. */
 	uint8_t state;		/* (1) Status flags. */
 
 #define SRB_NO_QUEUE_STATE	 0	/* Request is in between states */
diff --git a/drivers/tty/mxser.h b/drivers/tty/mxser.h
index 41878a6..0bf7943 100644
--- a/drivers/tty/mxser.h
+++ b/drivers/tty/mxser.h
@@ -113,7 +113,7 @@
 #define MOXA_MUST_IIR_RTO		0x0C
 #define MOXA_MUST_IIR_LSR		0x06
 
-/* recieved Xon/Xoff or specical interrupt pending */
+/* received Xon/Xoff or specical interrupt pending */
 #define MOXA_MUST_IIR_XSC		0x10
 
 /* RTS/CTS change state interrupt pending */
diff --git a/drivers/usb/class/usbtmc.c b/drivers/usb/class/usbtmc.c
index 6a54634..385acb8 100644
--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -483,7 +483,7 @@ static ssize_t usbtmc_read(struct file *filp, char __user *buf,
 		}
 
 		done += n_characters;
-		/* Terminate if end-of-message bit recieved from device */
+		/* Terminate if end-of-message bit received from device */
 		if ((buffer[8] &  0x01) && (actual >= n_characters + 12))
 			remaining = 0;
 		else
diff --git a/drivers/usb/gadget/fsl_qe_udc.h b/drivers/usb/gadget/fsl_qe_udc.h
index bea5b82..105eb62 100644
--- a/drivers/usb/gadget/fsl_qe_udc.h
+++ b/drivers/usb/gadget/fsl_qe_udc.h
@@ -379,7 +379,7 @@ struct qe_udc {
 #define T_LSP         0x01000000         /* Low-speed transaction */
 #define T_PID         0x00c00000         /* packet id */
 #define T_NAK         0x00100000         /* No ack. */
-#define T_STAL        0x00080000         /* Stall recieved */
+#define T_STAL        0x00080000         /* Stall received */
 #define T_TO          0x00040000         /* time out */
 #define T_UN          0x00020000         /* underrun */
 
diff --git a/drivers/usb/host/fhci-tds.c b/drivers/usb/host/fhci-tds.c
index 38fe058..7fd46f3 100644
--- a/drivers/usb/host/fhci-tds.c
+++ b/drivers/usb/host/fhci-tds.c
@@ -40,7 +40,7 @@
 #define TD_RXER		0x0020 /* Rx error or not */
 
 #define TD_NAK		0x0010 /* No ack. */
-#define TD_STAL		0x0008 /* Stall recieved */
+#define TD_STAL		0x0008 /* Stall received */
 #define TD_TO		0x0004 /* time out */
 #define TD_UN		0x0002 /* underrun */
 #define TD_NO		0x0010 /* Rx Non Octet Aligned Packet */
diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index 44e4deb..4a771f6 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -2879,7 +2879,7 @@ static int oxu_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 	/* Ok, we have more job to do! :) */
 
 	for (i = 0; i < num - 1; i++) {
-		/* Get free micro URB poll till a free urb is recieved */
+		/* Get free micro URB poll till a free urb is received */
 
 		do {
 			murb = (struct urb *) oxu_murb_alloc(oxu);
@@ -2911,7 +2911,7 @@ static int oxu_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
 
 	/* Last urb requires special handling  */
 
-	/* Get free micro URB poll till a free urb is recieved */
+	/* Get free micro URB poll till a free urb is received */
 	do {
 		murb = (struct urb *) oxu_murb_alloc(oxu);
 		if (!murb)
-- 
1.7.4.2

