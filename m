Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab1CUXPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:15:36 -0400
Received: from kroah.org ([198.145.64.141]:49328 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab1CUXPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:24 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:11 2011
Message-Id: <20110321230711.847229724@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Seth Heasley <seth.heasley@intel.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [26/87] ahci: AHCI mode SATA patch for Intel DH89xxCC DeviceIDs
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit a4a461a6df6c0481d5a3d61660ed97f5b539cf16 upstream.

This patch adds the AHCI-mode SATA DeviceID for the Intel DH89xxCC PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ahci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -260,6 +260,7 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(INTEL, 0x1d02), board_ahci }, /* PBG AHCI */
 	{ PCI_VDEVICE(INTEL, 0x1d04), board_ahci }, /* PBG RAID */
 	{ PCI_VDEVICE(INTEL, 0x1d06), board_ahci }, /* PBG RAID */
+	{ PCI_VDEVICE(INTEL, 0x2323), board_ahci }, /* DH89xxCC AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,


