Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab1CUXPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:15:41 -0400
Received: from kroah.org ([198.145.64.141]:49322 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755315Ab1CUXPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:11 2011
Message-Id: <20110321230711.745493336@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Per Jessen <per@computer.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [25/87] ahci: recognize Marvell 88se9125 PCIe SATA 6.0 Gb/s controller
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Per Jessen <per@computer.org>

commit 467b41c688c79d1b5e076fbdf082f9cd5d6a000c upstream.

Recognize Marvell 88SE9125 PCIe SATA 6.0 Gb/s controller.

Signed-off-by: Per Jessen <per@computer.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ahci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -380,6 +380,8 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
 	{ PCI_DEVICE(0x1b4b, 0x9123),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9128 */
+	{ PCI_DEVICE(0x1b4b, 0x9125),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
 
 	/* Promise */
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */


