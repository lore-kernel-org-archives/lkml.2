Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964Ab2AXAmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:42:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:63065 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484Ab2AXAmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:42:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="99803364"
From: Seth Heasley <seth.heasley@intel.com>
To: wim@iguana.be, linux-watchdog@vger.kernel.org
Subject: [PATCH 5/6] iTCO_wdt: TCO Watchdog patch for Intel Lynx Point DeviceIDs
Date: Mon, 23 Jan 2012 16:40:55 -0800
User-Agent: KMail/1.13.6 (Linux/2.6.35.12-88.fc14.x86_64; KDE/4.6.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, james.d.ralston@intel.com,
        seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201231640.55956.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the TCO Watchdog DeviceIDs for the Intel Lynx Point PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
---
 drivers/watchdog/iTCO_wdt.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 99796c5..bdf401b 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -36,6 +36,7 @@
  *	document number TBD                   : Patsburg (PBG)
  *	document number TBD                   : DH89xxCC
  *	document number TBD                   : Panther Point
+ *	document number TBD                   : Lynx Point
  */
 
 /*
@@ -126,6 +127,7 @@ enum iTCO_chipsets {
 	TCO_PBG,	/* Patsburg */
 	TCO_DH89XXCC,	/* DH89xxCC */
 	TCO_PPT,	/* Panther Point */
+	TCO_LPT,	/* Lynx Point */
 };
 
 static struct {
@@ -189,6 +191,7 @@ static struct {
 	{"Patsburg", 2},
 	{"DH89xxCC", 2},
 	{"Panther Point", 2},
+	{"Lynx Point", 2},
 	{NULL, 0}
 };
 
@@ -331,6 +334,38 @@ static DEFINE_PCI_DEVICE_TABLE(iTCO_wdt_pci_tbl) = {
 	{ PCI_VDEVICE(INTEL, 0x1e5d), TCO_PPT},
 	{ PCI_VDEVICE(INTEL, 0x1e5e), TCO_PPT},
 	{ PCI_VDEVICE(INTEL, 0x1e5f), TCO_PPT},
+	{ PCI_VDEVICE(INTEL, 0x8c40), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c41), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c42), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c43), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c44), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c45), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c46), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c47), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c48), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c49), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4a), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4b), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4c), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4d), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4e), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c4f), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c50), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c51), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c52), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c53), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c54), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c55), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c56), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c57), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c58), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c59), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5a), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5b), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5c), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5d), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5e), TCO_LPT},
+	{ PCI_VDEVICE(INTEL, 0x8c5f), TCO_LPT},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
-- 
1.7.4.4

