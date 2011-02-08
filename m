Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab1BHMZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 07:25:39 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61026 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab1BHMZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 07:25:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=qahU+W1ImWjHJKCt1HH/UpwYsU0PHbeS1UvKqwmVqYFyfzhgUBShuqRkEgsyMTlL/2
         loh1D/4erYhlXZ+8y744J0nklNqvGuOxkfH7lA+ZRTcjX0QtgMc/y2pqAgXMYhg93VwU
         oA8AVKzmYlhYshaAsNJDCys2QtcWGRcVSzR7g=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Feb 2011 13:25:27 +0100
Message-Id: <20110208122527.19110.18002.sendpatchset@linux-mhg7.site>
In-Reply-To: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
Subject: [PATCH 15/20] pata_oldpiix: enable parallel scan
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0343103ea4e3f8c35f938d9198f3ea265755ea6a Mon Sep 17 00:00:00 2001
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 8 Feb 2011 12:39:27 +0100
Subject: [PATCH 15/20] pata_oldpiix: enable parallel scan

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_oldpiix.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 845ede1..819192d 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -222,7 +222,8 @@ static int oldpiix_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_bmdma_init_one(pdev, ppi, &oldpiix_sht, NULL, 0);
+	return ata_pci_bmdma_init_one(pdev, ppi, &oldpiix_sht, NULL,
+				      ATA_HOST_PARALLEL_SCAN);
 }
 
 static const struct pci_device_id oldpiix_pci_tbl[] = {
-- 
1.7.1

