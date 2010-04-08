Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694Ab0DHMnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 08:43:49 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:43655 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab0DHMns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 08:43:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=iUc8NEekjgKJIMwTAxCgikkrSN1fMo4Moc0BlrNJzXIG0xUoihGoypSRwqxm9tkm28
         b1iCqS5lcutX1mgal0CfFirQEWJby3yEk0JDKTbg301CqhxrdXcJmb5xqKSUcer0MRXL
         kjfql+hVwnvhbvAyzF75lB+j/CmRAchLDUETI=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, mithlesh@linsyssoft.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 29/29] Staging: comedi: fix print(k) coding style issues in aio_iiro_16.c
Date: Thu,  8 Apr 2010 13:43:35 +0100
Message-Id: <1270730615-3456-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the aio_iiro_16.c file that fixes up print(k) warnings found by the checkpatch.pl tool

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com
---
 drivers/staging/comedi/drivers/aio_iiro_16.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/aio_iiro_16.c b/drivers/staging/comedi/drivers/aio_iiro_16.c
index 3857fd5..6ccf2b9 100644
--- a/drivers/staging/comedi/drivers/aio_iiro_16.c
+++ b/drivers/staging/comedi/drivers/aio_iiro_16.c
@@ -98,7 +98,7 @@ static int aio_iiro_16_attach(struct comedi_device *dev,
 	int iobase;
 	struct comedi_subdevice *s;
 
-	printk("comedi%d: aio_iiro_16: ", dev->minor);
+	printk(KERN_ERR "comedi%d: aio_iiro_16: ", dev->minor);
 
 	dev->board_name = thisboard->name;
 
@@ -140,7 +140,7 @@ static int aio_iiro_16_attach(struct comedi_device *dev,
 
 static int aio_iiro_16_detach(struct comedi_device *dev)
 {
-	printk("comedi%d: aio_iiro_16: remove\n", dev->minor);
+	printk(KERN_ERR "comedi%d: aio_iiro_16: remove\n", dev->minor);
 
 	if (dev->iobase)
 		release_region(dev->iobase, AIO_IIRO_16_SIZE);
-- 
1.6.3.3

