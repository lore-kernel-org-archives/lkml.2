Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491Ab2JZOn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:43:28 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44008 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933416Ab2JZOnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:43:25 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, balbi@ti.com
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] usb: Fix typo in drivers/usb
Date: Fri, 26 Oct 2012 23:43:19 +0900
Message-Id: <1351262599-15461-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in debug message within drivers/usb.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/usb/gadget/fsl_udc_core.c   | 2 +-
 drivers/usb/gadget/tcm_usb_gadget.c | 2 +-
 drivers/usb/host/Kconfig            | 4 ++--
 drivers/usb/musb/musb_dsps.c        | 2 +-
 drivers/usb/renesas_usbhs/fifo.c    | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 3def828..37a4e01 100644
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
index 5444866..73eac8f 100644
--- a/drivers/usb/gadget/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/tcm_usb_gadget.c
@@ -1387,7 +1387,7 @@ static struct se_node_acl *usbg_alloc_fabric_acl(struct se_portal_group *se_tpg)
 
 	nacl = kzalloc(sizeof(struct usbg_nacl), GFP_KERNEL);
 	if (!nacl) {
-		printk(KERN_ERR "Unable to alocate struct usbg_nacl\n");
+		printk(KERN_ERR "Unable to allocate struct usbg_nacl\n");
 		return NULL;
 	}
 
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 075d2ec..7cac2e8 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -418,7 +418,7 @@ config USB_OHCI_HCD_PLATFORM
 	default n
 	---help---
 	  Adds an OHCI host driver for a generic platform device, which
-	  provieds a memory space and an irq.
+	  provides a memory space and an irq.
 
 	  If unsure, say N.
 
@@ -428,7 +428,7 @@ config USB_EHCI_HCD_PLATFORM
 	default n
 	---help---
 	  Adds an EHCI host driver for a generic platform device, which
-	  provieds a memory space and an irq.
+	  provides a memory space and an irq.
 
 	  If unsure, say N.
 
diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 494772f..59ad13d 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -294,7 +294,7 @@ static irqreturn_t dsps_interrupt(int irq, void *hci)
 	 * Also, DRVVBUS pulses for SRP (but not at 5V) ...
 	 */
 	if ((usbintr & MUSB_INTR_BABBLE) && is_host_enabled(musb))
-		pr_info("CAUTION: musb: Babble Interrupt Occured\n");
+		pr_info("CAUTION: musb: Babble Interrupt Occurred\n");
 
 	if (usbintr & ((1 << wrp->drvvbus) << wrp->usb_shift)) {
 		int drvvbus = dsps_readl(reg_base, wrp->status);
diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs/fifo.c
index ecd1730..2a5b78d 100644
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

