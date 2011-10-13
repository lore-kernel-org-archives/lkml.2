Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab1JMLRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 07:17:06 -0400
Received: from mail-dy0-f46.google.com ([209.85.220.46]:63132 "EHLO
	mail-dy0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906Ab1JMLRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 07:17:05 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] pata_cs5535: fix DRV_NAME
Date: Thu, 13 Oct 2011 12:52:21 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110131252.21866.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cs5535: fix DRV_NAME

.. and also a module description while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cs5535.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ata/pata_cs5535.c
===================================================================
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -38,7 +38,7 @@
 #include <linux/libata.h>
 #include <asm/msr.h>
 
-#define DRV_NAME	"cs5535"
+#define DRV_NAME	"pata_cs5535"
 #define DRV_VERSION	"0.2.12"
 
 /*
@@ -218,7 +218,7 @@ static void __exit cs5535_exit(void)
 }
 
 MODULE_AUTHOR("Alan Cox, Jens Altmann, Wolfgan Zuleger, Alexander Kiausch");
-MODULE_DESCRIPTION("low-level driver for the NS/AMD 5530");
+MODULE_DESCRIPTION("low-level driver for the NS/AMD 5535");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, cs5535);
 MODULE_VERSION(DRV_VERSION);
