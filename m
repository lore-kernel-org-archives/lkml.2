Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab1GNXuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 19:50:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:38235 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab1GNXt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 19:49:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,531,1304319600"; 
   d="scan'208";a="27841964"
From: Seth Heasley <seth.heasley@intel.com>
To: jgarzik@pobox.com
Subject: [PATCH 3.0-rc7] ahci: RAID-mode SATA patch for Intel Panther Point DeviceIDs
Date: Thu, 14 Jul 2011 16:50:49 -0700
User-Agent: KMail/1.13.6 (Linux/2.6.35.12-88.fc14.x86_64; KDE/4.6.1; x86_64; ; )
Cc: seth.heasley@gmail.com, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <201107141650.49929.seth.heasley@intel.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an additional SATA RAID controller DeviceID for the Intel Panther Point PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
---

--- linux-3.0-rc7/drivers/ata/ahci.c.orig	2011-07-14 16:07:21.000000000 -0700
+++ linux-3.0-rc7/drivers/ata/ahci.c	2011-07-14 16:35:06.000000000 -0700
@@ -267,6 +267,7 @@
 	{ PCI_VDEVICE(INTEL, 0x1e05), board_ahci }, /* Panther Point RAID */
 	{ PCI_VDEVICE(INTEL, 0x1e06), board_ahci }, /* Panther Point RAID */
 	{ PCI_VDEVICE(INTEL, 0x1e07), board_ahci }, /* Panther Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x1e0e), board_ahci }, /* Panther Point RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
