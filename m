Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934267Ab2KZRSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:18:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48326 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934179Ab2KZRQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:16:24 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 264/270] e1000e: add device IDs for i218
Date: Mon, 26 Nov 2012 14:59:14 -0200
Message-Id: <1353949160-26803-265-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bruce Allan <bruce.w.allan@intel.com>

commit 16e310ae6ed352c4963b1f2413fcd88fa693eeda upstream.

i218 is the next-generation LOM that will be available on systems with the
Lynx Point LP Platform Controller Hub (PCH) chipset from Intel.  This patch
provides the initial support of those devices.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/intel/e1000e/hw.h     |    2 ++
 drivers/net/ethernet/intel/e1000e/netdev.c |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
index ed5b409..d37bfd9 100644
--- a/drivers/net/ethernet/intel/e1000e/hw.h
+++ b/drivers/net/ethernet/intel/e1000e/hw.h
@@ -412,6 +412,8 @@ enum e1e_registers {
 #define E1000_DEV_ID_PCH2_LV_V			0x1503
 #define E1000_DEV_ID_PCH_LPT_I217_LM		0x153A
 #define E1000_DEV_ID_PCH_LPT_I217_V		0x153B
+#define E1000_DEV_ID_PCH_LPTLP_I218_LM		0x155A
+#define E1000_DEV_ID_PCH_LPTLP_I218_V		0x1559
 
 #define E1000_REVISION_4 4
 
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 9bbfa1d..7e750ae 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6519,6 +6519,8 @@ static DEFINE_PCI_DEVICE_TABLE(e1000_pci_tbl) = {
 
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LPT_I217_LM), board_pch_lpt },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LPT_I217_V), board_pch_lpt },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LPTLP_I218_LM), board_pch_lpt },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LPTLP_I218_V), board_pch_lpt },
 
 	{ 0, 0, 0, 0, 0, 0, 0 }	/* terminate list */
 };
-- 
1.7.9.5

