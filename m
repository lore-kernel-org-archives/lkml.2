Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab0KBPbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 11:31:24 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59333 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab0KBPbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 11:31:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EE7W+ewXGOaE9ixxCb4DLor/XjV/dA3vNRH5qqMYAJ7rkjF74L8EfGKuOh6fAxr3qa
         LN54SIAnMKvYoFZWtDCunLbuJnSgX3wDCRPhtjVw9cgfUqSrvAbxmD4FmRhNsTdUrMfe
         pXqR3B3H/R4TISmD83mDS0nBLkU9yM8eo9+Ps=
From: Audun Hoem <audun.hoem@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Audun Hoem <audun.hoem@gmail.com>
Subject: [PATCH] staging: frontier: alphatrack: fixed coding style issues
Date: Tue,  2 Nov 2010 16:31:01 +0100
Message-Id: <1288711861-3625-1-git-send-email-audun.hoem@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaned up a macro definition and another simple style warning.

Signed-off-by: Audun Hoem <audun.hoem@gmail.com>
---
 drivers/staging/frontier/alphatrack.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
index ef7fbf8..6e3bd73 100644
--- a/drivers/staging/frontier/alphatrack.c
+++ b/drivers/staging/frontier/alphatrack.c
@@ -88,8 +88,11 @@ MODULE_SUPPORTED_DEVICE("Frontier Designs Alphatrack Control Surface");
 static int debug = ALPHATRACK_DEBUG;
 
 /* Use our own dbg macro */
-#define dbg_info(dev, format, arg...) do \
-    { if (debug) dev_info(dev , format , ## arg); } while (0)
+#define dbg_info(dev, format, arg...) \
+do { \
+	if (debug) \
+		dev_info(dev , format , ## arg); \
+} while (0)
 
 #define alphatrack_ocmd_info(dev, cmd, format, arg...)
 
@@ -769,7 +772,7 @@ static int usb_alphatrack_probe(struct usb_interface *intf,
 	}
 
 	dev->write_buffer =
-	    kmalloc(sizeof(struct alphatrack_ocmd) * true_size, GFP_KERNEL);
+	    kmalloc(sizeof(struct alphatrack_ocmd) *true_size, GFP_KERNEL);
 
 	if (!dev->write_buffer) {
 		dev_err(&intf->dev, "Couldn't allocate write_buffer\n");
-- 
1.7.0.4

