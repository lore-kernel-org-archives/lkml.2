Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab1B1Gam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 01:30:42 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:45257 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab1B1Gal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 01:30:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Q0NVLc4qRKFB5FoGXr0xlSg9nbqX8OH6f92f2KCqnetMcXE2Il92oiLE6MIu0UXEiQ
         +eRVpAScSgBR/geKgTg8hHY+mlz71pX/oOpXQ+yxdW+wf0F7gvFuUiywOlqpvvq25vZw
         blQyH3nDSfq03HkVA0l4ooYeGcTCvIKqFCkXY=
Subject: [PATCH 3/3] mfd: vx855: add MODULE_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <HaraldWelte@viatech.com>,
        Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1298874735.5562.3.camel@mola>
References: <1298874735.5562.3.camel@mola>
Content-Type: text/plain
Date: Mon, 28 Feb 2011 14:34:27 +0800
Message-Id: <1298874867.5562.7.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device table is required to load modules based on modaliases.
After adding the MODULE_DEVICE_TABLE, below entries will be added to
modules.pcimap:
vx855                0x00001106 0x00008409 0xffffffff 0xffffffff 0x00000000 0x00000000 0x0

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/vx855.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/vx855.c b/drivers/mfd/vx855.c
index 348052a..d698703 100644
--- a/drivers/mfd/vx855.c
+++ b/drivers/mfd/vx855.c
@@ -122,6 +122,7 @@ static struct pci_device_id vx855_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VX855) },
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, vx855_pci_tbl);
 
 static struct pci_driver vx855_pci_driver = {
 	.name		= "vx855",
-- 
1.7.2



