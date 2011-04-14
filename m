Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930Ab1DNS3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:29:45 -0400
Received: from mail.windriver.com ([147.11.1.11]:37969 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918Ab1DNRqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:17 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Daniel Klaffenbach <danielklaffenbach@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 039/209] ssb: b43-pci-bridge: Add new vendor for BCM4318
Date: Thu, 14 Apr 2011 13:41:09 -0400
Message-Id: <1302803039-9400-40-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Klaffenbach <danielklaffenbach@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 1d8638d4038eb8709edc80e37a0bbb77253d86e9 upstream.

Add new vendor for Broadcom 4318.

Signed-off-by: Daniel Klaffenbach <danielklaffenbach@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/ssb/b43_pci_bridge.c |    1 +
 include/linux/pci_ids.h      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/ssb/b43_pci_bridge.c b/drivers/ssb/b43_pci_bridge.c
index ef9c6a0..744d3f6 100644
--- a/drivers/ssb/b43_pci_bridge.c
+++ b/drivers/ssb/b43_pci_bridge.c
@@ -24,6 +24,7 @@ static const struct pci_device_id b43_pci_bridge_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4312) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4315) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4318) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BCM_GVC,  0x4318) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4319) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4320) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4321) },
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 829ac3f..32aa93d 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2038,6 +2038,7 @@
 #define PCI_DEVICE_ID_AFAVLAB_P030	0x2182
 #define PCI_SUBDEVICE_ID_AFAVLAB_P061		0x2150
 
+#define PCI_VENDOR_ID_BCM_GVC          0x14a4
 #define PCI_VENDOR_ID_BROADCOM		0x14e4
 #define PCI_DEVICE_ID_TIGON3_5752	0x1600
 #define PCI_DEVICE_ID_TIGON3_5752M	0x1601
-- 
1.7.4.4

