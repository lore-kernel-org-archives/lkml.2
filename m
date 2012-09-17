Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab2IQBVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:21:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33554 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753294Ab2IQAuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:05 -0400
Message-Id: <20120917003643.891603544@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:33 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 128/135] ahci: Add alternate identifier for the 88SE9172
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 17c60c6b763cb5b83b0185e7d38d01d18e55a05a upstream.

This can also appear as 0x9192. Reported in bugzilla and confirmed with the
board documentation for these boards.

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=42970
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/ahci.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index c3f52eb..51548dd 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -396,6 +396,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
 	{ PCI_DEVICE(0x1b4b, 0x917a),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
+	{ PCI_DEVICE(0x1b4b, 0x9192),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte */
 	{ PCI_DEVICE(0x1b4b, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
 


