Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab0KAViq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:38:46 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52899 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab0KAVim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:38:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IAhUxYEREN6wLNA4uiMMwwJWOan8qifzNneHdFZuZjuSEis6z/+4e+cQBfM480Cr9T
         JZvu4pEUIsrtSb+lTJMslrboZJbI6M7hjyolZTtMchrOsUA5pLWL7waU0pV5mN1m2IGF
         d/bFamUpeSFiIBrfd46H3T6yVvO96ntsAT62A=
From: Mauro Schilman <maurito.s@gmail.com>
To: gregkh@suse.de
Cc: u.kleine-koenig@pengutronix.de, eli@siliconsprawl.com,
        michael.tate@wanadoo.fr, arnd@arndb.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ehames@gmail.com, maurito.s@gmail.com,
        md.bustos90@gmail.com, facugaich@gmail.com
Subject: [PATCH] Staging: frontier: fix space and * coding style issues in alphatrack.c
Date: Mon,  1 Nov 2010 18:38:10 -0300
Message-Id: <1288647490-2088-1-git-send-email-maurito.s@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This is a patch to the alphatrack.c file that fixes up a space warning and a
     space after '*' warning found by the checkpatch.pl tool
 Signed-off-by: Mauro Schilman <maurito.s@gmail.com>

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

