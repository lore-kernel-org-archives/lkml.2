Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965728Ab2JaPD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:03:59 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:54729 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2JaPD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:03:57 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: balbi@ti.com, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH/Ver2] [trivial] usb: Fix typo in drivers/usb
Date: Thu,  1 Nov 2012 00:03:51 +0900
Message-Id: <1351695831-14294-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in debug messages within drivers/usb.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Acked-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/gadget/fsl_udc_core.c   | 2 +-
 drivers/usb/gadget/tcm_usb_gadget.c | 2 +-
 drivers/usb/musb/musb_dsps.c        | 2 +-
 drivers/usb/renesas_usbhs/fifo.c    | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 6ae70cb..c19f7f1 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -2126,7 +2126,7 @@ static int fsl_proc_read(char *page, char **start, off_t off, int count,
 
 	tmp_reg = fsl_readl(&dr_regs->usbintr);
 	t = scnprintf(next, size,
-			"USB Intrrupt Enable Reg:\n"
+			"USB Interrupt Enable Reg:\n"
 			"Sleep Enable: %d SOF Received Enable: %d "
 			"Reset Enable: %d\n"
 			"System Error Enable: %d "
diff --git a/drivers/usb/gadget/tcm_usb_gadget.c b/drivers/usb/gadget/tcm_usb_gadget.c
index 97e68b3..3849218 100644
--- a/drivers/usb/gadget/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/tcm_usb_gadget.c
@@ -1384,7 +1384,7 @@ static struct se_node_acl *usbg_alloc_fabric_acl(struct se_portal_group *se_tpg)
 
 	nacl = kzalloc(sizeof(struct usbg_nacl), GFP_KERNEL);
 	if (!nacl) {
-		printk(KERN_ERR "Unable to alocate struct usbg_nacl\n");
+		printk(KERN_ERR "Unable to allocate struct usbg_nacl\n");
 		return NULL;
 	}
 
diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index ff5f112..65470eb 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -296,7 +296,7 @@ static irqreturn_t dsps_interrupt(int irq, void *hci)
 	 * Also, DRVVBUS pulses for SRP (but not at 5V) ...
 	 */
 	if (usbintr & MUSB_INTR_BABBLE)
-		pr_info("CAUTION: musb: Babble Interrupt Occured\n");
+		pr_info("CAUTION: musb: Babble Interrupt Occurred\n");
 
 	if (usbintr & ((1 << wrp->drvvbus) << wrp->usb_shift)) {
 		int drvvbus = dsps_readl(reg_base, wrp->status);
diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs/fifo.c
index c021b20..0d6f9f3 100644
--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -163,7 +163,7 @@ static int usbhsf_pkt_handler(struct usbhs_pipe *pipe, int type)
 		func = pkt->handler->dma_done;
 		break;
 	default:
-		dev_err(dev, "unknown pkt hander\n");
+		dev_err(dev, "unknown pkt handler\n");
 		goto __usbhs_pkt_handler_end;
 	}
 
-- 
1.8.0.rc3.16.g8ead1bf

