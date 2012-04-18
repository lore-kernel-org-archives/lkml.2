Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab2DRPEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:04:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54380 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab2DRPEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:04:52 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-usb@vger.kernel.org, stern@rowland.harvard.edu, trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] usb: Fix various typo within usb
Date: Thu, 19 Apr 2012 00:04:46 +0900
Message-Id: <1334761486-12817-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10.169.g146fe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo within usb

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/usb/gadget/f_hid.c       |    2 +-
 drivers/usb/host/ehci-platform.c |    4 ++--
 drivers/usb/host/fhci-tds.c      |    2 +-
 drivers/usb/host/ohci-platform.c |    4 ++--
 drivers/usb/host/ohci-ppc-of.c   |    2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/f_hid.c b/drivers/usb/gadget/f_hid.c
index b211342..3b3932c 100644
--- a/drivers/usb/gadget/f_hid.c
+++ b/drivers/usb/gadget/f_hid.c
@@ -374,7 +374,7 @@ static int hidg_setup(struct usb_function *f,
 			break;
 
 		default:
-			VDBG(cdev, "Unknown decriptor request 0x%x\n",
+			VDBG(cdev, "Unknown descriptor request 0x%x\n",
 				 value >> 8);
 			goto stall;
 			break;
diff --git a/drivers/usb/host/ehci-platform.c b/drivers/usb/host/ehci-platform.c
index d238b4e2..23c530a 100644
--- a/drivers/usb/host/ehci-platform.c
+++ b/drivers/usb/host/ehci-platform.c
@@ -94,12 +94,12 @@ static int __devinit ehci_platform_probe(struct platform_device *dev)
 
 	irq = platform_get_irq(dev, 0);
 	if (irq < 0) {
-		pr_err("no irq provieded");
+		pr_err("no irq provided");
 		return irq;
 	}
 	res_mem = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!res_mem) {
-		pr_err("no memory recourse provieded");
+		pr_err("no memory recourse provided");
 		return -ENXIO;
 	}
 
diff --git a/drivers/usb/host/fhci-tds.c b/drivers/usb/host/fhci-tds.c
index 0ea577b..c5ed881 100644
--- a/drivers/usb/host/fhci-tds.c
+++ b/drivers/usb/host/fhci-tds.c
@@ -155,7 +155,7 @@ u32 fhci_create_ep(struct fhci_usb *usb, enum fhci_mem_alloc data_mem,
 	struct endpoint *ep;
 	struct usb_td __iomem *td;
 	unsigned long ep_offset;
-	char *err_for = "enpoint PRAM";
+	char *err_for = "endpoint PRAM";
 	int ep_mem_size;
 	u32 i;
 
diff --git a/drivers/usb/host/ohci-platform.c b/drivers/usb/host/ohci-platform.c
index ec5c679..670c705 100644
--- a/drivers/usb/host/ohci-platform.c
+++ b/drivers/usb/host/ohci-platform.c
@@ -93,13 +93,13 @@ static int __devinit ohci_platform_probe(struct platform_device *dev)
 
 	irq = platform_get_irq(dev, 0);
 	if (irq < 0) {
-		pr_err("no irq provieded");
+		pr_err("no irq provided");
 		return irq;
 	}
 
 	res_mem = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!res_mem) {
-		pr_err("no memory recourse provieded");
+		pr_err("no memory recourse provided");
 		return -ENXIO;
 	}
 
diff --git a/drivers/usb/host/ohci-ppc-of.c b/drivers/usb/host/ohci-ppc-of.c
index d24cc89d..b2b5767 100644
--- a/drivers/usb/host/ohci-ppc-of.c
+++ b/drivers/usb/host/ohci-ppc-of.c
@@ -236,7 +236,7 @@ MODULE_DEVICE_TABLE(of, ohci_hcd_ppc_of_match);
 
 #if	!defined(CONFIG_USB_OHCI_HCD_PPC_OF_BE) && \
 	!defined(CONFIG_USB_OHCI_HCD_PPC_OF_LE)
-#error "No endianess selected for ppc-of-ohci"
+#error "No endianness selected for ppc-of-ohci"
 #endif
 
 
-- 
1.7.10.169.g146fe

