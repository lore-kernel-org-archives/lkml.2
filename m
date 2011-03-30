Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751Ab1C3V1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:27:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:12876 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965060Ab1C3VJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903736003"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: seth.heasley@intel.com, jgarzik@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [193/275] ahci: AHCI mode SATA patch for Intel DH89xxCC DeviceIDs
Message-Id: <20110330210716.E6A0D3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Seth Heasley <seth.heasley@intel.com>

commit a4a461a6df6c0481d5a3d61660ed97f5b539cf16 upstream.

This patch adds the AHCI-mode SATA DeviceID for the Intel DH89xxCC PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/ata/ahci.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/ata/ahci.c
===================================================================
--- linux-2.6.35.y.orig/drivers/ata/ahci.c	2011-03-29 23:03:02.289241594 -0700
+++ linux-2.6.35.y/drivers/ata/ahci.c	2011-03-29 23:54:14.951619850 -0700
@@ -251,6 +251,7 @@
 	{ PCI_VDEVICE(INTEL, 0x1d02), board_ahci }, /* PBG AHCI */
 	{ PCI_VDEVICE(INTEL, 0x1d04), board_ahci }, /* PBG RAID */
 	{ PCI_VDEVICE(INTEL, 0x1d06), board_ahci }, /* PBG RAID */
+	{ PCI_VDEVICE(INTEL, 0x2323), board_ahci }, /* DH89xxCC AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
