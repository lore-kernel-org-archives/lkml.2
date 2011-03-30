Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770Ab1C3V1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:27:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:14820 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965020Ab1C3VJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903735988"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: seth.heasley@intel.com, jgarzik@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [192/275] ahci: AHCI and RAID mode SATA patch for Intel Patsburg DeviceIDs
Message-Id: <20110330210715.D7A773E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Seth Heasley <seth.heasley@intel.com>

commit 992b3fb9b5391bc4de5b42bb810dc6dd583a6c4a upstream.

This patch adds the Intel Patsburg (PCH) SATA AHCI and RAID Controller
DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/ata/ahci.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.35.y/drivers/ata/ahci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/ata/ahci.c	2011-03-29 22:50:44.387122663 -0700
+++ linux-2.6.35.y/drivers/ata/ahci.c	2011-03-29 23:54:15.478606367 -0700
@@ -248,6 +248,9 @@
 	{ PCI_VDEVICE(INTEL, 0x1c05), board_ahci }, /* CPT RAID */
 	{ PCI_VDEVICE(INTEL, 0x1c06), board_ahci }, /* CPT RAID */
 	{ PCI_VDEVICE(INTEL, 0x1c07), board_ahci }, /* CPT RAID */
+	{ PCI_VDEVICE(INTEL, 0x1d02), board_ahci }, /* PBG AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1d04), board_ahci }, /* PBG RAID */
+	{ PCI_VDEVICE(INTEL, 0x1d06), board_ahci }, /* PBG RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
