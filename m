Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab0CXDd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 23:33:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55211 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023Ab0CXDd5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 23:33:57 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: David Airlie <airlied@linux.ie>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Mar 2010 03:33:48 +0000
Message-ID: <1269401628.18314.264.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [PATCH 1/2] sis-agp: Remove SIS 760, handled by amd64-agp
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SIS 760 is listed in the device tables for both amd64-agp and sis-agp.
amd64-agp is apparently preferable since it has workarounds for some
BIOS misconfigurations that sis-agp doesn't handle.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/agp/sis-agp.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/char/agp/sis-agp.c b/drivers/char/agp/sis-agp.c
index 6c3837a..95fdd4d 100644
--- a/drivers/char/agp/sis-agp.c
+++ b/drivers/char/agp/sis-agp.c
@@ -415,14 +415,6 @@ static struct pci_device_id agp_sis_pci_table[] = {
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
 
-- 
1.7.0



