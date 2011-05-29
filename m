Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab1E2VFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 17:05:37 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51815 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab1E2VFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 17:05:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type;
        b=t/VCOB9yR5KqO+LREKdDSztBbrP+EL1AEp4fiO/blsrkrZ7v9G/3gthTHF8uiFJnIK
         A6ak+S88ois7Djv3MlbBgoNPzqoa2ekXWK7l0fITPFDNMj0Tj6HWOGgg3z5EGv7tQoaS
         mwIBWRFluywRlRb+aJrgkNrAjK/DZifOe8esM=
Message-ID: <4DE2B51E.7010807@gmail.com>
Date: Sun, 29 May 2011 23:05:34 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: usb: Move device id for quirk to pci_ids
Content-Type: multipart/mixed;
 boundary="------------090305050709000804050807"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090305050709000804050807
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
---
When adding a quirk for asrock p67 xhci controller I noticed it being 
defined on top, I don't know what the policy is, but shouldn't it be in 
pci_ids?

--------------090305050709000804050807
Content-Type: text/plain;
 name="0001-usb-Move-device-id-for-quirk-to-pci_ids.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-usb-Move-device-id-for-quirk-to-pci_ids.txt"

>From 9259b45bf91729235e165d584de1a65a09664325 Mon Sep 17 00:00:00 2001
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Date: Sun, 29 May 2011 22:56:47 +0200
Subject: [PATCH 1/2] usb: Move device id for quirk to pci_ids

---
 drivers/usb/host/xhci-pci.c |    4 ----
 include/linux/pci_ids.h     |    3 +++
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index a10494c..5a41f05 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -24,10 +24,6 @@
 
 #include "xhci.h"
 
-/* Device for a quirk */
-#define PCI_VENDOR_ID_FRESCO_LOGIC	0x1b73
-#define PCI_DEVICE_ID_FRESCO_LOGIC_PDK	0x1000
-
 static const char hcd_name[] = "xhci_hcd";
 
 /* called after powerup, by probe or system-pm "wakeup" */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 8abe8d7..1c56294 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2387,6 +2387,9 @@
 
 #define PCI_VENDOR_ID_AZWAVE		0x1a3b
 
+#define PCI_VENDOR_ID_FRESCO_LOGIC	0x1b73
+#define PCI_DEVICE_ID_FRESCO_LOGIC_PDK	0x1000
+
 #define PCI_VENDOR_ID_TEKRAM		0x1de1
 #define PCI_DEVICE_ID_TEKRAM_DC290	0xdc29
 
-- 
1.7.4.1


--------------090305050709000804050807--
