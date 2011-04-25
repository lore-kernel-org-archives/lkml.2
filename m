Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab1DYUsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:48:52 -0400
Received: from 1wt.eu ([62.212.114.60]:34197 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756748Ab1DYUYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:35 -0400
Message-Id: <20110425200236.644896263@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Seth Heasley <seth.heasley@intel.com>, Jeff Garzik <jgarzik@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 084/173] ahci: AHCI and RAID mode SATA patch for Intel Patsburg DeviceIDs
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit 992b3fb9b5391bc4de5b42bb810dc6dd583a6c4a upstream.

This patch adds the Intel Patsburg (PCH) SATA AHCI and RAID Controller
DeviceIDs.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ahci.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -576,6 +576,9 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(INTEL, 0x1c05), board_ahci }, /* CPT RAID */
 	{ PCI_VDEVICE(INTEL, 0x1c06), board_ahci }, /* CPT RAID */
 	{ PCI_VDEVICE(INTEL, 0x1c07), board_ahci }, /* CPT RAID */
+	{ PCI_VDEVICE(INTEL, 0x1d02), board_ahci }, /* PBG AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1d04), board_ahci }, /* PBG RAID */
+	{ PCI_VDEVICE(INTEL, 0x1d06), board_ahci }, /* PBG RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,


