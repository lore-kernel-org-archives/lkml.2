Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2K1RZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:25:52 -0500
Received: from leviathan.tchmachines.com ([208.76.85.180]:49248 "EHLO
	leviathan.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab2K1RZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:25:51 -0500
From: Eli Billauer <eli.billauer@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org,
        Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 1/2] pci_ids: Added FPGA-related entries
Date: Wed, 28 Nov 2012 17:41:32 +0200
Message-Id: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
X-Mailer: git-send-email 1.7.2.3
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - leviathan.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - billauer.co.il
X-Get-Message-Sender-Via: leviathan.tchmachines.com: authenticated_id: billaue/sender_address_domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These entries are referred to by the Xillybus driver.

Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
---
 include/linux/pci_ids.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 9d36b82..9f2c724 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1320,6 +1320,12 @@
 #define PCI_DEVICE_ID_REALTEK_8139	0x8139
 
 #define PCI_VENDOR_ID_XILINX		0x10ee
+#define PCI_VENDOR_ID_ALTERA		0x1172
+#define PCI_VENDOR_ID_ACTEL		0x11aa
+#define PCI_VENDOR_ID_LATTICE		0x1204
+
+#define PCI_DEVICE_ID_XILLYBUS		0xebeb
+
 #define PCI_DEVICE_ID_RME_DIGI96	0x3fc0
 #define PCI_DEVICE_ID_RME_DIGI96_8	0x3fc1
 #define PCI_DEVICE_ID_RME_DIGI96_8_PRO	0x3fc2
-- 
1.7.2.3

