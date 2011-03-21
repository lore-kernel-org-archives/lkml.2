Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab1CUXf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:35:29 -0400
Received: from kroah.org ([198.145.64.141]:49673 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111Ab1CUXQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:16:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:17 2011
Message-Id: <20110321230717.734025282@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:07:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Manoj Iyer <manoj.iyer@canonical.com>, Chris Ball <cjb@laptop.org>
Subject: [83/87] mmc: sdhci: Add Ricoh e823 PCI ID
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Manoj Iyer <manoj.iyer@canonical.com>

commit 5fd11c0754fa069b6aba64b65734aa2fb193552d upstream.

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/sdhci-pci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -454,6 +454,14 @@ static const struct pci_device_id pci_id
 	},
 
 	{
+		.vendor         = PCI_VENDOR_ID_RICOH,
+		.device         = 0xe823,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.driver_data    = (kernel_ulong_t)&sdhci_ricoh_mmc,
+	},
+
+	{
 		.vendor		= PCI_VENDOR_ID_ENE,
 		.device		= PCI_DEVICE_ID_ENE_CB712_SD,
 		.subvendor	= PCI_ANY_ID,


