Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab2LDRIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 12:08:51 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:47566
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751938Ab2LDRIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 12:08:49 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1155h)
X-WSS-ID: 0MEINME-02-H0Y-02
X-M-MSG: 
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
To: <herrmann.der.user@googlemail.com>, <khali@linux-fr.org>,
        <bhelgaas@google.com>
CC: <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@amd.com>
Subject: [PATCH] x86,AMD: Power driver support for AMD's family 16h processors
Date: Tue, 4 Dec 2012 07:10:04 -0500
Message-ID: <1354623004-8169-1-git-send-email-boris.ostrovsky@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add family 16h PCI ID to AMD's power driver to allow it report
power consumption on these processors.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
---
 drivers/hwmon/fam15h_power.c |    1 +
 include/linux/pci_ids.h      |    1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index 4f41104..dda1113 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -248,6 +248,7 @@ static void __devexit fam15h_power_remove(struct pci_dev *pdev)
 
 static DEFINE_PCI_DEVICE_TABLE(fam15h_power_id_table) = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, fam15h_power_id_table);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 9d36b82..9c9a464 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -524,6 +524,7 @@
 #define PCI_DEVICE_ID_AMD_15H_NB_F3	0x1603
 #define PCI_DEVICE_ID_AMD_15H_NB_F4	0x1604
 #define PCI_DEVICE_ID_AMD_15H_NB_F5	0x1605
+#define PCI_DEVICE_ID_AMD_16H_NB_F4	0x1534
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
-- 
1.7.10.4


