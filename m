Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab0KARMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 13:12:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58086 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab0KARMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 13:12:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Vfavswzap0J4no+hu2S4UcV4aqOsssnveeF9aHObRTjz/ZEfk9h5Ioo8LDubLjeFwI
         nfu5FFft/jlb/d6I8SuqF5x0+W4kTAABZhK8T1onFR6Xba/rvKl1+7MwQ3P2Lo9qogN6
         4YsSQph5UOzjozMFiUDn1PPabRfhY8n1F0v6g=
From: Mauro Schilman <maurito.s@gmail.com>
To: gregkh@suse.de
Cc: u.kleine-koenig@pengutronix.de, eli@siliconsprawl.com,
        michael.tate@wanadoo.fr, arnd@arndb.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ehames@gmail.com, maurito.s@gmail.com,
        md.bustos90@gmail.com, facugaich@gmail.com
Subject: Staging: frontier: fix space and * coding style issues in alphatrack.c This is a patch to the alphatrack.c file that fixes up a space warning and a space after '*' warning found by the checkpatch.pl tool Signed-off-by: Mauro Schilman <maurito.s@gmail.com>
Date: Mon,  1 Nov 2010 14:12:05 -0300
Message-Id: <1288631525-8766-1-git-send-email-maurito.s@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/frontier/alphatrack.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
index ef7fbf8..2babb03 100644
--- a/drivers/staging/frontier/alphatrack.c
+++ b/drivers/staging/frontier/alphatrack.c
@@ -89,7 +89,7 @@ static int debug = ALPHATRACK_DEBUG;
 
 /* Use our own dbg macro */
 #define dbg_info(dev, format, arg...) do \
-    { if (debug) dev_info(dev , format , ## arg); } while (0)
+	{ if (debug) dev_info(dev , format , ## arg); } while (0)
 
 #define alphatrack_ocmd_info(dev, cmd, format, arg...)
 
@@ -769,7 +769,7 @@ static int usb_alphatrack_probe(struct usb_interface *intf,
 	}
 
 	dev->write_buffer =
-	    kmalloc(sizeof(struct alphatrack_ocmd) * true_size, GFP_KERNEL);
+	    kmalloc(true_size * sizeof(struct alphatrack_ocmd), GFP_KERNEL);
 
 	if (!dev->write_buffer) {
 		dev_err(&intf->dev, "Couldn't allocate write_buffer\n");
-- 
1.7.1

