Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab0IJXqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:46:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:11263 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387Ab0IJXqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:46:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,348,1280732400"; 
   d="scan'208";a="656229094"
From: Seth Heasley <seth.heasley@intel.com>
Organization: Intel Corporation
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.35.4] iTCO_wdt: TCO Watchdog patch for Intel Patsburg DeviceIDs
Date: Fri, 10 Sep 2010 16:38:13 -0700
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
References: <201001121704.44010.seth.heasley@intel.com> <201009090958.03975.seth.heasley@intel.com>
In-Reply-To: <201009090958.03975.seth.heasley@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009101638.13571.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Patsburg (PCH) DeviceIDs for iTCO Watchdog.
  
Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.35.4/drivers/watchdog/iTCO_wdt.c.orig	2010-08-26 16:47:12.000000000 -0700
+++ linux-2.6.35.4/drivers/watchdog/iTCO_wdt.c	2010-08-31 17:29:43.699146841 -0700
@@ -146,6 +146,7 @@
 	TCO_CPT29,	/* Cougar Point */
 	TCO_CPT30,	/* Cougar Point */
 	TCO_CPT31,	/* Cougar Point */
+	TCO_PBG,	/* Patsburg */
 };
 
 static struct {
@@ -233,6 +234,7 @@
 	{"Cougar Point", 2},
 	{"Cougar Point", 2},
 	{"Cougar Point", 2},
+	{"Patsburg", 2},
 	{NULL, 0}
 };
 
@@ -348,6 +350,7 @@
 	{ ITCO_PCI_DEVICE(0x1c5d,				TCO_CPT29)},
 	{ ITCO_PCI_DEVICE(0x1c5e,				TCO_CPT30)},
 	{ ITCO_PCI_DEVICE(0x1c5f,				TCO_CPT31)},
+	{ ITCO_PCI_DEVICE(0x1d40,				TCO_PBG)},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
