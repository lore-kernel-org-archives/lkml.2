Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1FSJYe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 05:24:34 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62907 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab1FSJYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 05:24:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=li6WU6SM387RCF9dDYuilBJSKJ7v9TSJlVh1qPq/zCzLwzegUxe+lVkC0U1ykxwx85
         yXkQMIS4aIJTPbXTj+p6ZspKqI0yUUsoO++Y/WEFoYhrzAR4Kx1vXK9692oYHPYeLXK8
         O2DEm+UNzXeetGf0QmvmDoXPNIQ66OLaA4AlQ=
From: Zac Storer <zac.3.14159@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH] Staging: keucr: usb: fixed a brace coding style warning
Date: Sun, 19 Jun 2011 03:23:20 -0600
Message-Id: <1308475400-9352-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style warning.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/staging/keucr/usb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/keucr/usb.c b/drivers/staging/keucr/usb.c
index d8c5c62..65cf2e3 100644
--- a/drivers/staging/keucr/usb.c
+++ b/drivers/staging/keucr/usb.c
@@ -640,8 +640,7 @@ static int eucr_probe(struct usb_interface *intf, const struct usb_device_id *id
 
 	/* Start up the thread for delayed SCSI-device scanning */
 	th = kthread_create(usb_stor_scan_thread, us, "eucr-stor-scan");
-	if (IS_ERR(th))
-	{
+	if (IS_ERR(th)) {
 		pr_info("Unable to start the device-scanning thread\n");
 		complete(&us->scanning_done);
 		quiesce_and_remove_host(us);
-- 
1.7.4.1

