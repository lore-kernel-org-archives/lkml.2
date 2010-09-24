Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab0IXQge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:36:34 -0400
Received: from kroah.org ([198.145.64.141]:37486 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933162Ab0IXQgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:36:05 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:49 2010
Message-Id: <20100924163349.870703596@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>, Dave Airlie <airlied@redhat.com>
Subject: [66/68] sis-agp: Remove SIS 760, handled by amd64-agp
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit d831692a1a8e9ceaaa9bb16bb3fc503b7e372558 upstream.

SIS 760 is listed in the device tables for both amd64-agp and sis-agp.
amd64-agp is apparently preferable since it has workarounds for some
BIOS misconfigurations that sis-agp doesn't handle.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/sis-agp.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/char/agp/sis-agp.c
+++ b/drivers/char/agp/sis-agp.c
@@ -415,14 +415,6 @@ static struct pci_device_id agp_sis_pci_
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
 	},
-	{
-		.class		= (PCI_CLASS_BRIDGE_HOST << 8),
-		.class_mask	= ~0,
-		.vendor		= PCI_VENDOR_ID_SI,
-		.device		= PCI_DEVICE_ID_SI_760,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-	},
 	{ }
 };
 


