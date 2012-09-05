Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab2IEQav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 12:30:51 -0400
Received: from masquerade.micron.com ([137.201.242.130]:30053 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab2IEQat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 12:30:49 -0400
Message-ID: <50477E2E.8030102@micron.com>
Date: Wed, 5 Sep 2012 22:00:38 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>,
        "Selvan Mani (smani) [CONT - Type 2]" <smani@micron.com>
Subject: [PATCH 1/6] mtip32xx: Add support for new devices
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19164.003
X-TM-AS-Result: No--7.858900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Added supported device IDs in pci table

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Selvan Mani <smani@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    8 +++++++-
 drivers/block/mtip32xx/mtip32xx.h |    8 +++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index a8fddeb..a935f4f 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4168,7 +4168,13 @@ static void mtip_pci_shutdown(struct pci_dev *pdev)
 
 /* Table of device ids supported by this driver. */
 static DEFINE_PCI_DEVICE_TABLE(mtip_pci_tbl) = {
-	{  PCI_DEVICE(PCI_VENDOR_ID_MICRON, P320_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MICRON, P320H_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MICRON, P320M_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MICRON, P320S_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MICRON, P325M_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MICRON, P420H_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MICRON, P420M_DEVICE_ID) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MICRON, P425M_DEVICE_ID) },
 	{ 0 }
 };
 
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index f51fc23..0255d19 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -76,7 +76,13 @@
 
 /* Micron Vendor ID & P320x SSD Device ID */
 #define PCI_VENDOR_ID_MICRON    0x1344
-#define P320_DEVICE_ID		0x5150
+#define P320H_DEVICE_ID		0x5150
+#define P320M_DEVICE_ID		0x5151
+#define P320S_DEVICE_ID		0x5152
+#define P325M_DEVICE_ID		0x5153
+#define P420H_DEVICE_ID		0x5160
+#define P420M_DEVICE_ID		0x5161
+#define P425M_DEVICE_ID		0x5163
 
 /* Driver name and version strings */
 #define MTIP_DRV_NAME		"mtip32xx"
-- 
1.7.1

