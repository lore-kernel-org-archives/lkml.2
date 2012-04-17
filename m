Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab2DQSy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:54:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:3445 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab2DQSyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:54:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="133604972"
From: Seth Heasley <seth.heasley@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>,
        Seth Heasley <seth.heasley@intel.com>
Subject: [PATCH 1/3] pci_ids: Add Intel Centerton Legacy Block DeviceID
Date: Tue, 17 Apr 2012 11:51:23 -0700
Message-Id: <1334688683-3280-1-git-send-email-seth.heasley@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Integrated Legacy Block DeviceID for the Centerton CPU.  It will be used in the GPIO and Multifunction Devices driver.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
---
 include/linux/pci_ids.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3329965..ab741b0 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2506,6 +2506,7 @@
 #define PCI_DEVICE_ID_INTEL_MRST_SD2	0x084F
 #define PCI_DEVICE_ID_INTEL_I960	0x0960
 #define PCI_DEVICE_ID_INTEL_I960RM	0x0962
+#define PCI_DEVICE_ID_INTEL_CENTERTON_ILB	0x0c60
 #define PCI_DEVICE_ID_INTEL_8257X_SOL	0x1062
 #define PCI_DEVICE_ID_INTEL_82573E_SOL	0x1085
 #define PCI_DEVICE_ID_INTEL_82573L_SOL	0x108F
-- 
1.7.4.4

