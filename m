Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0LLXqT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35949 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab0LLXqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:17 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: danielklaffenbach@gmail.com, Larry.Finger@lwfinger.net,
        linville@tuxdriver.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [77/223] ssb: b43-pci-bridge: Add new vendor for BCM4318
Message-Id: <20101212234616.1C1F0B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:16 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Daniel Klaffenbach <danielklaffenbach@gmail.com>

commit 1d8638d4038eb8709edc80e37a0bbb77253d86e9 upstream.

Add new vendor for Broadcom 4318.

Signed-off-by: Daniel Klaffenbach <danielklaffenbach@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/ssb/b43_pci_bridge.c |    1 +
 include/linux/pci_ids.h      |    1 +
 2 files changed, 2 insertions(+)

Index: linux/drivers/ssb/b43_pci_bridge.c
===================================================================
--- linux.orig/drivers/ssb/b43_pci_bridge.c
+++ linux/drivers/ssb/b43_pci_bridge.c
@@ -24,6 +24,7 @@ static const struct pci_device_id b43_pc
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4312) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4315) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4318) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BCM_GVC,  0x4318) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4319) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4320) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4321) },
Index: linux/include/linux/pci_ids.h
===================================================================
--- linux.orig/include/linux/pci_ids.h
+++ linux/include/linux/pci_ids.h
@@ -2038,6 +2038,7 @@
 #define PCI_DEVICE_ID_AFAVLAB_P030	0x2182
 #define PCI_SUBDEVICE_ID_AFAVLAB_P061		0x2150
 
+#define PCI_VENDOR_ID_BCM_GVC          0x14a4
 #define PCI_VENDOR_ID_BROADCOM		0x14e4
 #define PCI_DEVICE_ID_TIGON3_5752	0x1600
 #define PCI_DEVICE_ID_TIGON3_5752M	0x1601
