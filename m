Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab1AJVHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:07:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:1607 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab1AJVHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:07:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,303,1291622400"; 
   d="scan'208";a="695399588"
From: Seth Heasley <seth.heasley@intel.com>
Organization: Intel Corporation
To: jgarzik@pobox.com
Subject: [PATCH 2.3.37] ahci: AHCI mode SATA patch for Intel DH89xxCC DeviceIDs
Date: Mon, 10 Jan 2011 12:57:17 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-9-default; KDE/4.1.3; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        seth.heasley@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201101101257.17449.seth.heasley@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the AHCI-mode SATA DeviceID for the Intel DH89xxCC PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>

--- linux-2.6.37/drivers/ata/ahci.c.orig	2011-01-04 16:50:19.000000000 -0800
+++ linux-2.6.37/drivers/ata/ahci.c	2011-01-06 14:16:00.000000000 -0800
@@ -260,6 +260,7 @@
 	{ PCI_VDEVICE(INTEL, 0x1d02), board_ahci }, /* PBG AHCI */
 	{ PCI_VDEVICE(INTEL, 0x1d04), board_ahci }, /* PBG RAID */
 	{ PCI_VDEVICE(INTEL, 0x1d06), board_ahci }, /* PBG RAID */
+	{ PCI_VDEVICE(INTEL, 0x2323), board_ahci }, /* DH89xxCC AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
