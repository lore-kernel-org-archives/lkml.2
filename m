Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab1CVABA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 20:01:00 -0400
Received: from kroah.org ([198.145.64.141]:48974 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab1CUXNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:13:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:10:52 2011
Message-Id: <20110321231052.006831417@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:09:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Seth Heasley <seth.heasley@intel.com>, Jeff Garzik <jgarzik@pobox.com>
Subject: [12/44] ahci: AHCI mode SATA patch for Intel Patsburg SATA RAID controller
In-Reply-To: <20110321231105.GA1744@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


