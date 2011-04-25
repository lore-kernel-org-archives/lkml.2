Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab1DYUta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:49:30 -0400
Received: from 1wt.eu ([62.212.114.60]:34173 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226Ab1DYUYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:32 -0400
Message-Id: <20110425200236.731788608@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Seth Heasley <seth.heasley@intel.com>, Jeff Garzik <jgarzik@pobox.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 086/173] ahci: AHCI mode SATA patch for Intel Patsburg SATA RAID controller
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit 64a3903d0885879ba8706a8bcf71c5e3e7664db2 upstream.

This patch adds an updated SATA RAID DeviceID for the Intel Patsburg PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ahci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -579,6 +579,7 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(INTEL, 0x1d02), board_ahci }, /* PBG AHCI */
 	{ PCI_VDEVICE(INTEL, 0x1d04), board_ahci }, /* PBG RAID */
 	{ PCI_VDEVICE(INTEL, 0x1d06), board_ahci }, /* PBG RAID */
+	{ PCI_VDEVICE(INTEL, 0x2826), board_ahci }, /* PBG RAID */
 	{ PCI_VDEVICE(INTEL, 0x2323), board_ahci }, /* DH89xxCC AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */


