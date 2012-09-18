Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab2IRWRi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 18:17:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:53463 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351Ab2IRWRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 18:17:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,445,1344236400"; 
   d="scan'208";a="207366480"
From: Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH v2] ioat: Adding Ivy Bridge IOATDMA PCI device IDs
To: djbw@fb.com
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Date: Tue, 18 Sep 2012 15:17:32 -0700
Message-ID: <20120918221605.19383.19083.stgit@djiang5-linux.ch.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
Sorry about the churn. I had to move the PCI dev IDs to the header file
after realizing that dma_v3.c actually sometimes check the PCI IDs in order
to work around certain silicon bugs.

 drivers/dma/ioat/hw.h  |   11 +++++++++++
 drivers/dma/ioat/pci.c |   11 +++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ioat/hw.h b/drivers/dma/ioat/hw.h
index 60e6754..e2db4c7 100644
--- a/drivers/dma/ioat/hw.h
+++ b/drivers/dma/ioat/hw.h
@@ -31,6 +31,17 @@
 #define IOAT_PCI_DID_SCNB       0x65FF
 #define IOAT_PCI_DID_SNB        0x402F
 
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
 #define IOAT_PCI_RID            0x00
 #define IOAT_PCI_SVID           0x8086
 #define IOAT_PCI_SID            0x8086
diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
index 5e3a40f..01be1c9 100644
--- a/drivers/dma/ioat/pci.c
+++ b/drivers/dma/ioat/pci.c
@@ -83,6 +83,17 @@ static struct pci_device_id ioat_pci_tbl[] = {
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

