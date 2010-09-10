Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab0IJXq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:46:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:27361 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755007Ab0IJXq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:46:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,348,1280732400"; 
   d="scan'208";a="605887700"
From: Seth Heasley <seth.heasley@intel.com>
Organization: Intel Corporation
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.35.4] ahci: AHCI and RAID mode SATA patch for Intel Patsburg DeviceIDs
Date: Fri, 10 Sep 2010 16:38:48 -0700
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
References: <201001121700.18234.seth.heasley@intel.com> <201009090944.56546.seth.heasley@intel.com>
In-Reply-To: <201009090944.56546.seth.heasley@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009101638.48922.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Intel Patsburg (PCH) SATA AHCI and RAID Controller DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.35.4/drivers/ata/ahci.c.orig	2010-08-26 16:47:12.000000000 -0700
+++ linux-2.6.35.4/drivers/ata/ahci.c	2010-08-31 17:29:43.698135766 -0700
@@ -244,6 +244,9 @@
 	{ PCI_VDEVICE(INTEL, 0x1c05), board_ahci }, /* CPT RAID */
 	{ PCI_VDEVICE(INTEL, 0x1c06), board_ahci }, /* CPT RAID */
 	{ PCI_VDEVICE(INTEL, 0x1c07), board_ahci }, /* CPT RAID */
+	{ PCI_VDEVICE(INTEL, 0x1d02), board_ahci }, /* PBG AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1d04), board_ahci }, /* PBG RAID */
+	{ PCI_VDEVICE(INTEL, 0x1d06), board_ahci }, /* PBG RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
