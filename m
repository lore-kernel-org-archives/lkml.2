Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab1AHBVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 20:21:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:29072 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab1AHBVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 20:21:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,292,1291622400"; 
   d="scan'208";a="590999336"
From: Seth Heasley <seth.heasley@intel.com>
Organization: Intel Corporation
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, seth.heasley@intel.com
Subject: [PATCH 2.6.37] iTCO_wdt: TCO Watchdog patch for Intel DH89xxCC PCH
Date: Fri, 7 Jan 2011 17:11:08 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101071711.08302.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the DeviceIDs for TCO Watchdog on the Intel DH89xxCC PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.37/drivers/watchdog/iTCO_wdt.c.orig	2011-01-04 16:50:19.000000000 -0800
+++ linux-2.6.37/drivers/watchdog/iTCO_wdt.c	2011-01-07 10:57:09.000000000 -0800
@@ -31,8 +31,9 @@
  *	document number 319973-002, 319974-002: 82801J (ICH10)
  *	document number 322169-001, 322170-003: 5 Series, 3400 Series (PCH)
  *	document number 320066-003, 320257-008: EP80597 (IICH)
- *	document number TBD                   : Cougar Point (CPT)
+ *	document number 324645-001, 324646-001: Cougar Point (CPT)
  *	document number TBD                   : Patsburg (PBG)
+ *	document number TBD                   : DH89xxCC 
  */
 
 /*
@@ -149,6 +150,7 @@
 	TCO_CPT31,	/* Cougar Point */
 	TCO_PBG1,	/* Patsburg */
 	TCO_PBG2,	/* Patsburg */
+	TCO_DH89XXCC,	/* DH89xxCC */
 };
 
 static struct {
@@ -238,6 +240,7 @@
 	{"Cougar Point", 2},
 	{"Patsburg", 2},
 	{"Patsburg", 2},
+	{"DH89xxCC", 2},
 	{NULL, 0}
 };
 
@@ -355,6 +358,7 @@
 	{ ITCO_PCI_DEVICE(0x1c5f,				TCO_CPT31)},
 	{ ITCO_PCI_DEVICE(0x1d40,				TCO_PBG1)},
 	{ ITCO_PCI_DEVICE(0x1d41,				TCO_PBG2)},
+	{ ITCO_PCI_DEVICE(0x2310,				TCO_DH89XXCC)},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
