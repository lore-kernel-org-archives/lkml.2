Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab2HXXgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 19:36:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:63863 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242Ab2HXXgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 19:36:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,307,1344236400"; 
   d="scan'208";a="210944692"
From: Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH] ioat: Adding Ivy Bridge IOATDMA PCI device IDs
To: djbw@fb.com
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Date: Fri, 24 Aug 2012 16:36:20 -0700
Message-ID: <20120824233619.9218.25014.stgit@djiang5-linux.ch.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

 drivers/dma/ioat/pci.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
index 5e3a40f..c057306 100644
--- a/drivers/dma/ioat/pci.c
+++ b/drivers/dma/ioat/pci.c
@@ -40,6 +40,17 @@ MODULE_VERSION(IOAT_DMA_VERSION);
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel Corporation");
 
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB0	0x0e20
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB1	0x0e21
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB2	0x0e22
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB3	0x0e23
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB4	0x0e24
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB5	0x0e25
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB6	0x0e26
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB7	0x0e27
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB8	0x0e2e
+#define PCI_DEVICE_ID_INTEL_IOAT_IVB9	0x0e2f
+
 static struct pci_device_id ioat_pci_tbl[] = {
 	/* I/OAT v1 platforms */
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT) },
@@ -83,6 +94,17 @@ static struct pci_device_id ioat_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB8) },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB9) },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB0) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB1) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB2) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB3) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB4) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB5) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB6) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB7) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB8) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB9) },
+
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, ioat_pci_tbl);

