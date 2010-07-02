Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289Ab0GBSl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 14:41:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45886 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab0GBSl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 14:41:56 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] trivial: fix typos concerning "already"
Date: Fri,  2 Jul 2010 20:41:51 +0200
Message-Id: <1278096111-31549-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
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
 drivers/block/drbd/drbd_receiver.c          |    2 +-
 drivers/isdn/hardware/mISDN/avmfritz.c      |    2 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c      |    4 ++--
 drivers/isdn/hardware/mISDN/hfcpci.c        |    2 +-
 drivers/isdn/hardware/mISDN/mISDNinfineon.c |    2 +-
 drivers/isdn/hardware/mISDN/speedfax.c      |    2 +-
 drivers/isdn/hardware/mISDN/w6692.c         |    2 +-
 drivers/isdn/hisax/callc.c                  |    2 +-
 drivers/isdn/hisax/tei.c                    |    2 +-
 drivers/isdn/mISDN/tei.c                    |    2 +-
 drivers/media/video/zoran/zoran_device.c    |    2 +-
 drivers/scsi/bfa/bfa_ioim.c                 |    2 +-
 drivers/usb/host/fhci-sched.c               |    2 +-
 kernel/time/tick-broadcast.c                |    2 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c     |    2 +-
 15 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index dff4870..ec1711f 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1087,7 +1087,7 @@ static enum finish_epoch drbd_may_finish_epoch(struct drbd_conf *mdev,
 			} else {
 				epoch->flags = 0;
 				atomic_set(&epoch->epoch_size, 0);
-				/* atomic_set(&epoch->active, 0); is alrady zero */
+				/* atomic_set(&epoch->active, 0); is already zero */
 				if (rv == FE_STILL_LIVE)
 					rv = FE_RECYCLED;
 			}
diff --git a/drivers/isdn/hardware/mISDN/avmfritz.c b/drivers/isdn/hardware/mISDN/avmfritz.c
index d421536..472a2af 100644
--- a/drivers/isdn/hardware/mISDN/avmfritz.c
+++ b/drivers/isdn/hardware/mISDN/avmfritz.c
@@ -1116,7 +1116,7 @@ fritz_remove_pci(struct pci_dev *pdev)
 		release_card(card);
 	else
 		if (debug)
-			pr_info("%s: drvdata allready removed\n", __func__);
+			pr_info("%s: drvdata already removed\n", __func__);
 }
 
 static struct pci_device_id fcpci_ids[] __devinitdata = {
diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 095ed76..d317195 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -4268,7 +4268,7 @@ init_card(struct hfc_multi *hc)
 		goto error;
 	/*
 	 * Finally enable IRQ output
-	 * this is only allowed, if an IRQ routine is allready
+	 * this is only allowed, if an IRQ routine is already
 	 * established for this HFC, so don't do that earlier
 	 */
 	spin_lock_irqsave(&hc->lock, flags);
@@ -5212,7 +5212,7 @@ static void __devexit hfc_remove_pci(struct pci_dev *pdev)
 		spin_unlock_irqrestore(&HFClock, flags);
 	}  else {
 		if (debug)
-			printk(KERN_DEBUG "%s: drvdata allready removed\n",
+			printk(KERN_DEBUG "%s: drvdata already removed\n",
 			    __func__);
 	}
 }
diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 5940a2c..65ded05 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -1773,7 +1773,7 @@ init_card(struct hfc_pci *hc)
 		inithfcpci(hc);
 		/*
 		 * Finally enable IRQ output
-		 * this is only allowed, if an IRQ routine is allready
+		 * this is only allowed, if an IRQ routine is already
 		 * established for this HFC, so don't do that earlier
 		 */
 		enable_hwirq(hc);
diff --git a/drivers/isdn/hardware/mISDN/mISDNinfineon.c b/drivers/isdn/hardware/mISDN/mISDNinfineon.c
index f5b3d2b..4975976 100644
--- a/drivers/isdn/hardware/mISDN/mISDNinfineon.c
+++ b/drivers/isdn/hardware/mISDN/mISDNinfineon.c
@@ -1150,7 +1150,7 @@ inf_remove(struct pci_dev *pdev)
 	if (card)
 		release_card(card);
 	else
-		pr_debug("%s: drvdata allready removed\n", __func__);
+		pr_debug("%s: drvdata already removed\n", __func__);
 }
 
 static struct pci_driver infineon_driver = {
diff --git a/drivers/isdn/hardware/mISDN/speedfax.c b/drivers/isdn/hardware/mISDN/speedfax.c
index d097a4e..9e07246 100644
--- a/drivers/isdn/hardware/mISDN/speedfax.c
+++ b/drivers/isdn/hardware/mISDN/speedfax.c
@@ -484,7 +484,7 @@ sfax_remove_pci(struct pci_dev *pdev)
 	if (card)
 		release_card(card);
 	else
-		pr_debug("%s: drvdata allready removed\n", __func__);
+		pr_debug("%s: drvdata already removed\n", __func__);
 }
 
 static struct pci_device_id sfaxpci_ids[] __devinitdata = {
diff --git a/drivers/isdn/hardware/mISDN/w6692.c b/drivers/isdn/hardware/mISDN/w6692.c
index 31f9d71..9e84870 100644
--- a/drivers/isdn/hardware/mISDN/w6692.c
+++ b/drivers/isdn/hardware/mISDN/w6692.c
@@ -1402,7 +1402,7 @@ w6692_remove_pci(struct pci_dev *pdev)
 		release_card(card);
 	else
 		if (debug)
-			pr_notice("%s: drvdata allready removed\n", __func__);
+			pr_notice("%s: drvdata already removed\n", __func__);
 }
 
 static struct pci_device_id w6692_ids[] = {
diff --git a/drivers/isdn/hisax/callc.c b/drivers/isdn/hisax/callc.c
index f58ded8..f150330 100644
--- a/drivers/isdn/hisax/callc.c
+++ b/drivers/isdn/hisax/callc.c
@@ -1172,7 +1172,7 @@ CallcFreeChan(struct IsdnCardState *csta)
 			kfree(csta->channel[i].b_st);
 			csta->channel[i].b_st = NULL;
 		} else
-			printk(KERN_WARNING "CallcFreeChan b_st ch%d allready freed\n", i);
+			printk(KERN_WARNING "CallcFreeChan b_st ch%d already freed\n", i);
 		if (i || test_bit(FLG_TWO_DCHAN, &csta->HW_Flags)) {
 			release_d_st(csta->channel + i);
 		} else
diff --git a/drivers/isdn/hisax/tei.c b/drivers/isdn/hisax/tei.c
index f4cb178..842f9c9 100644
--- a/drivers/isdn/hisax/tei.c
+++ b/drivers/isdn/hisax/tei.c
@@ -130,7 +130,7 @@ tei_id_request(struct FsmInst *fi, int event, void *arg)
 
 	if (st->l2.tei != -1) {
 		st->ma.tei_m.printdebug(&st->ma.tei_m,
-			"assign request for allready asigned tei %d",
+			"assign request for already asigned tei %d",
 			st->l2.tei);
 		return;
 	}
diff --git a/drivers/isdn/mISDN/tei.c b/drivers/isdn/mISDN/tei.c
index 34e898f..1b85d9d 100644
--- a/drivers/isdn/mISDN/tei.c
+++ b/drivers/isdn/mISDN/tei.c
@@ -457,7 +457,7 @@ tei_id_request(struct FsmInst *fi, int event, void *arg)
 
 	if (tm->l2->tei != GROUP_TEI) {
 		tm->tei_m.printdebug(&tm->tei_m,
-			"assign request for allready assigned tei %d",
+			"assign request for already assigned tei %d",
 			tm->l2->tei);
 		return;
 	}
diff --git a/drivers/media/video/zoran/zoran_device.c b/drivers/media/video/zoran/zoran_device.c
index e6ad4b2..6f846ab 100644
--- a/drivers/media/video/zoran/zoran_device.c
+++ b/drivers/media/video/zoran/zoran_device.c
@@ -484,7 +484,7 @@ zr36057_overlay (struct zoran *zr,
 				zr->overlay_settings.format);
 
 		/* Start and length of each line MUST be 4-byte aligned.
-		 * This should be allready checked before the call to this routine.
+		 * This should be already checked before the call to this routine.
 		 * All error messages are internal driver checking only! */
 
 		/* video display top and bottom registers */
diff --git a/drivers/scsi/bfa/bfa_ioim.c b/drivers/scsi/bfa/bfa_ioim.c
index 687f3d6..3d2eac1 100644
--- a/drivers/scsi/bfa/bfa_ioim.c
+++ b/drivers/scsi/bfa/bfa_ioim.c
@@ -488,7 +488,7 @@ bfa_ioim_sm_cleanup_qfull(struct bfa_ioim_s *ioim, enum bfa_ioim_event event)
 
 	case BFA_IOIM_SM_ABORT:
 		/**
-		 * IO is alraedy being cleaned up implicitly
+		 * IO is already being cleaned up implicitly
 		 */
 		ioim->io_cbfn = __bfa_cb_ioim_abort;
 		break;
diff --git a/drivers/usb/host/fhci-sched.c b/drivers/usb/host/fhci-sched.c
index 4f2cbdc..a42ef38 100644
--- a/drivers/usb/host/fhci-sched.c
+++ b/drivers/usb/host/fhci-sched.c
@@ -125,7 +125,7 @@ void fhci_transaction_confirm(struct fhci_usb *usb, struct packet *pkt)
 /*
  * Flush all transmitted packets from BDs
  * This routine is called when disabling the USB port to flush all
- * transmissions that are allready scheduled in the BDs
+ * transmissions that are already scheduled in the BDs
  */
 void fhci_flush_all_transmissions(struct fhci_usb *usb)
 {
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index b3bafd5..48b2761 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -188,7 +188,7 @@ static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 	/*
 	 * Setup the next period for devices, which do not have
 	 * periodic mode. We read dev->next_event first and add to it
-	 * when the event alrady expired. clockevents_program_event()
+	 * when the event already expired. clockevents_program_event()
 	 * sets dev->next_event only when the event is really
 	 * programmed to the device.
 	 */
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 6fb8901..4dc8805 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -201,7 +201,7 @@ static int nf_ct_frag6_queue(struct nf_ct_frag6_queue *fq, struct sk_buff *skb,
 	int offset, end;
 
 	if (fq->q.last_in & INET_FRAG_COMPLETE) {
-		pr_debug("Allready completed\n");
+		pr_debug("Already completed\n");
 		goto err;
 	}
 
-- 
1.7.1

