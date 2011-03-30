Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965073Ab1C3VJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:09:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:56389 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933623Ab1C3VJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411278554"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: seth.heasley@intel.com, jgarzik@pobox.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [194/275] ahci: AHCI mode SATA patch for Intel Patsburg SATA RAID controller
Message-Id: <20110330210717.F33083E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Seth Heasley <seth.heasley@intel.com>

commit 64a3903d0885879ba8706a8bcf71c5e3e7664db2 upstream.

This patch adds an updated SATA RAID DeviceID for the Intel Patsburg PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/ata/ahci.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/ata/ahci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/ata/ahci.c	2011-03-29 23:03:02.308241108 -0700
+++ linux-2.6.35.y/drivers/ata/ahci.c	2011-03-29 23:03:02.328240597 -0700
@@ -251,6 +251,7 @@
 	{ PCI_VDEVICE(INTEL, 0x1d02), board_ahci }, /* PBG AHCI */
 	{ PCI_VDEVICE(INTEL, 0x1d04), board_ahci }, /* PBG RAID */
 	{ PCI_VDEVICE(INTEL, 0x1d06), board_ahci }, /* PBG RAID */
+	{ PCI_VDEVICE(INTEL, 0x2826), board_ahci }, /* PBG RAID */
 	{ PCI_VDEVICE(INTEL, 0x2323), board_ahci }, /* DH89xxCC AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
