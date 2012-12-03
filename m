Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab2LCOkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:40:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43917 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755497Ab2LCOg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:36:58 -0500
Message-Id: <20121203143153.292966977@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:32:27 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Seth Heasley <seth.heasley@intel.com>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [ 41/89] watchdog: iTCO_wdt: add Intel Lynx Point DeviceIDs
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit 84e83c2846ffb42772056a0f825d8578dc92d586 upstream.

This patch adds the TCO Watchdog DeviceIDs for the Intel Lynx Point PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/watchdog/iTCO_wdt.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

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


