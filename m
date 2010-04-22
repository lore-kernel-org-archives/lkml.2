Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab0DVUNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:13:05 -0400
Received: from kroah.org ([198.145.64.141]:59951 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758077Ab0DVUBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:24 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:15 2010
Message-Id: <20100422195415.658919458@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Seth Heasley <seth.heasley@intel.com>, Jeff Garzik <jgarzik@redhat.com>,
       maximilian attems <max@stro.at>
Subject: [102/139] ahci: AHCI and RAID mode SATA patch for Intel Cougar Point DeviceIDs
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit 5623cab83ea61e0420f2064216d83eab067a24c6 upstream.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ahci.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -570,6 +570,12 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(INTEL, 0x3b2b), board_ahci }, /* PCH RAID */
 	{ PCI_VDEVICE(INTEL, 0x3b2c), board_ahci }, /* PCH RAID */
 	{ PCI_VDEVICE(INTEL, 0x3b2f), board_ahci }, /* PCH AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1c02), board_ahci }, /* CPT AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1c03), board_ahci }, /* CPT AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1c04), board_ahci }, /* CPT RAID */
+	{ PCI_VDEVICE(INTEL, 0x1c05), board_ahci }, /* CPT RAID */
+	{ PCI_VDEVICE(INTEL, 0x1c06), board_ahci }, /* CPT RAID */
+	{ PCI_VDEVICE(INTEL, 0x1c07), board_ahci }, /* CPT RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,


