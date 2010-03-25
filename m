Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab0CYOha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:37:30 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:59692 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab0CYOh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:37:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=D57SrjeL3+aqpwa1gA8SiN0UeLvhXvSNqBLc0+lwzz2zDulVZQbpiSXwOfLchPIOv3
         sNi0oiTS6Pj1yDrmq1Bt4IPmdAfPHC+1VUuldp9F3wcapM6md0ihyyCz/bEUd+SMJwx9
         iraJMIoTGrYIta6cRHwsImdxXBceDhGtkMXAI=
From: Maurice Dawson <mauricedawson2699@googlemail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 24/24] Staging: comedi: fix commented out code style in adq12b.c
Date: Thu, 25 Mar 2010 14:37:15 +0000
Message-Id: <1269527835-3639-1-git-send-email-mauricedawson2699@googlemail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the adq12b.c file that fixes an incorrect commented out code style that I used in my previous patch 23/23

Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
---
 drivers/staging/comedi/drivers/adq12b.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adq12b.c b/drivers/staging/comedi/drivers/adq12b.c
index ac3d42d..4a2814b 100644
--- a/drivers/staging/comedi/drivers/adq12b.c
+++ b/drivers/staging/comedi/drivers/adq12b.c
@@ -354,11 +354,10 @@ static int adq12b_ai_rinsn(struct comedi_device *dev,
 		/* read data */
 		hi = inb(dev->iobase + ADQ12B_ADHIG);
 		lo = inb(dev->iobase + ADQ12B_ADLOW);
-
-		/*
-		 *printk("debug: chan=%d range=%d status=%d hi=%d lo=%d\n",
-		 *channel, range, status,  hi, lo);
-		 */
+#if 0
+	printk(KERN_ERR "debug: chan=%d range=%d status=%d hi=%d lo=%d\n",
+					channel, range, status,  hi, lo);
+#endif
 		data[n] = (hi << 8) | lo;
 
 	}
-- 
1.6.3.3

