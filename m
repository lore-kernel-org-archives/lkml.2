Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0FZTyA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 15:54:00 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:53373 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753961Ab0FZTx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 15:53:59 -0400
Date: Sat, 26 Jun 2010 21:48:21 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: xhci: fixed brace and spacing coding style issues
Message-ID: <20100626214821.26157640@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed brace and spacing coding style issues.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/usb/host/pci-quirks.c |    3 +--
 drivers/usb/host/xhci-mem.c   |    4 ++--
 drivers/usb/host/xhci-pci.c   |    2 +-
 drivers/usb/host/xhci-ring.c  |    2 +-
 drivers/usb/host/xhci.c       |    9 +++------
 5 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 83b5f9c..843848a 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -329,9 +329,8 @@ static void __devinit quirk_usb_disable_ehci(struct pci_dev *pdev)
 			udelay(delta);
 			wait_time -= delta;
 			val = readl(op_reg_base + EHCI_USBSTS);
-			if ((val == ~(u32)0) || (val & EHCI_USBSTS_HALTED)) {
+			if ((val == ~(u32)0) || (val & EHCI_USBSTS_HALTED))
 				break;
-			}
 		} while (wait_time > 0);
 	}
 	writel(0, op_reg_base + EHCI_USBINTR);
diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index fd9e03a..27fbcd2 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1479,7 +1479,7 @@ static int xhci_check_trb_in_td_math(struct xhci_hcd *xhci, gfp_t mem_flags)
 	struct {
 		dma_addr_t		input_dma;
 		struct xhci_segment	*result_seg;
-	} simple_test_vector [] = {
+	} simple_test_vector[] = {
 		/* A zeroed DMA field should fail */
 		{ 0, NULL },
 		/* One TRB before the ring start should fail */
@@ -1504,7 +1504,7 @@ static int xhci_check_trb_in_td_math(struct xhci_hcd *xhci, gfp_t mem_flags)
 		union xhci_trb		*end_trb;
 		dma_addr_t		input_dma;
 		struct xhci_segment	*result_seg;
-	} complex_test_vector [] = {
+	} complex_test_vector[] = {
 		/* Test feeding a valid DMA address from a different ring */
 		{	.input_seg = xhci->event_ring->first_seg,
 			.start_trb = xhci->event_ring->first_seg->trbs,
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 11482b6..dd12371 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -176,7 +176,7 @@ static struct pci_driver xhci_pci_driver = {
 	.remove =	usb_hcd_pci_remove,
 	/* suspend and resume implemented later */
 
-	.shutdown = 	usb_hcd_pci_shutdown,
+	.shutdown =	usb_hcd_pci_shutdown,
 };
 
 int xhci_register_pci(void)
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 9012098..9e2fccb 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1857,7 +1857,7 @@ static unsigned int count_sg_trbs_needed(struct xhci_hcd *xhci, struct urb *urb)
 	num_sgs = urb->num_sgs;
 	temp = urb->transfer_buffer_length;
 
-	xhci_dbg(xhci, "count sg list trbs: \n");
+	xhci_dbg(xhci, "count sg list trbs:\n");
 	num_trbs = 0;
 	for_each_sg(urb->sg, sg, num_sgs, i) {
 		unsigned int previous_total_trbs = num_trbs;
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 27345cd..812b81f 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -390,9 +390,8 @@ void xhci_event_ring_work(unsigned long arg)
 	for (i = 0; i < MAX_HC_SLOTS; ++i) {
 		if (!xhci->devs[i])
 			continue;
-		for (j = 0; j < 31; ++j) {
+		for (j = 0; j < 31; ++j)
 			xhci_dbg_ep_rings(xhci, i, j, &xhci->devs[i]->eps[j]);
-		}
 	}
 
 	if (xhci->noops_submitted != NUM_TEST_NOOPS)
@@ -1329,9 +1328,8 @@ int xhci_check_bandwidth(struct usb_hcd *hcd, struct usb_device *udev)
 		/* Only cache or free the old ring if it exists.
 		 * It may not if this is the first add of an endpoint.
 		 */
-		if (virt_dev->eps[i].ring) {
+		if (virt_dev->eps[i].ring)
 			xhci_free_or_cache_endpoint_ring(xhci, virt_dev, i);
-		}
 		virt_dev->eps[i].ring = virt_dev->eps[i].new_ring;
 		virt_dev->eps[i].new_ring = NULL;
 	}
@@ -2185,9 +2183,8 @@ int xhci_address_device(struct usb_hcd *hcd, struct usb_device *udev)
 		ret = -EINVAL;
 		break;
 	}
-	if (ret) {
+	if (ret)
 		return ret;
-	}
 	temp_64 = xhci_read_64(xhci, &xhci->op_regs->dcbaa_ptr);
 	xhci_dbg(xhci, "Op regs DCBAA ptr = %#016llx\n", temp_64);
 	xhci_dbg(xhci, "Slot ID %d dcbaa entry @%p = %#016llx\n",
-- 
1.7.1
