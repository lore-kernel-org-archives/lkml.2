Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab1E0FFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 01:05:04 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:11189 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776Ab1E0FFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 01:05:03 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        alexander.stein@systec-electronic.com
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH v2 1/3] pch_gpio: add EG20T PCH GPIO device definition
Date: Fri, 27 May 2011 14:04:49 +0900
Message-Id: <1306472691-6055-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add EG20T PCH GPIO device ID definition to pci_ids.h.
And use the definition in pch_gpio.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/gpio/pch_gpio.c |    2 +-
 include/linux/pci_ids.h |    1 +
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/pch_gpio.c b/drivers/gpio/pch_gpio.c
index f970a5f..4d1c9c6 100644
--- a/drivers/gpio/pch_gpio.c
+++ b/drivers/gpio/pch_gpio.c
@@ -284,7 +284,7 @@ static int pch_gpio_resume(struct pci_dev *pdev)
 #endif
 
 static DEFINE_PCI_DEVICE_TABLE(pch_gpio_pcidev_id) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x8803) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_EG20TPCH_GPIO) },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, pch_gpio_pcidev_id);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 8abe8d7..6322199 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2742,6 +2742,7 @@
 #define PCI_DEVICE_ID_INTEL_IXP4XX	0x8500
 #define PCI_DEVICE_ID_INTEL_IXP2800	0x9004
 #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
+#define PCI_DEVICE_ID_INTEL_EG20TPCH_GPIO	0x8803
 
 #define PCI_VENDOR_ID_SCALEMP		0x8686
 #define PCI_DEVICE_ID_SCALEMP_VSMP_CTL	0x1010
-- 
1.7.4

