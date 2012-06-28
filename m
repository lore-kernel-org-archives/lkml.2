Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021Ab2F1EE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 00:04:28 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:36074 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2F1EE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 00:04:26 -0400
From: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
Subject: [PATCH] Staging: comedi: drivers: usbduxfast: changed "printk(KERN_INFO ..." for "pr_info(..."
Date: Thu, 28 Jun 2012 01:04:20 -0300
Message-Id: <1340856260-18093-1-git-send-email-sebastianbenvenuti@gmail.com>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changed 3 instances of printk(KERN_INFO for the prefered pr_info(

Signed-off-by: Sebastian Benvenuti <sebastianbenvenuti@gmail.com>
---
 drivers/staging/comedi/drivers/usbduxfast.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 7b1d21a..c37371c 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -1589,7 +1589,7 @@ static int usbduxfastsub_probe(struct usb_interface *uinterf,
 		return ret;
 	}
 
-	printk(KERN_INFO "comedi_: usbduxfast%d has been successfully "
+	pr_info("comedi_: usbduxfast%d has been successfully "
 	       "initialized.\n", index);
 	/* success */
 	return 0;
@@ -1684,7 +1684,7 @@ static int usbduxfast_attach(struct comedi_device *dev,
 		return ret;
 	}
 
-	printk(KERN_INFO "comedi%d: usbduxfast: usb-device %d is attached to "
+	pr_info("comedi%d: usbduxfast: usb-device %d is attached to "
 	       "comedi.\n", dev->minor, index);
 	/* private structure is also simply the usb-structure */
 	dev->private = usbduxfastsub + index;
@@ -1720,7 +1720,7 @@ static int usbduxfast_attach(struct comedi_device *dev,
 
 	up(&(usbduxfastsub[index].sem));
 	up(&start_stop_sem);
-	printk(KERN_INFO "comedi%d: successfully attached to usbduxfast.\n",
+	pr_info("comedi%d: successfully attached to usbduxfast.\n",
 	       dev->minor);
 
 	return 0;
-- 
1.7.11.1

