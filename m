Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab1HQT7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 15:59:18 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33269 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab1HQT7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 15:59:15 -0400
From: Akshay Joshi <me@akshayjoshi.com>
To: Matt Mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Akshay Joshi <me@akshayjoshi.com>
Subject: [PATCH 1/2] Staging: usbip: Remove trailing spaces.
Date: Wed, 17 Aug 2011 15:58:31 -0400
Message-Id: <1313611112-16083-1-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove trailing spaces to comply with the kernel coding style.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 drivers/staging/usbip/stub_dev.c |    4 ++--
 drivers/staging/usbip/stub_rx.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index fce22f2..1dacdc0 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -524,11 +524,11 @@ static void stub_disconnect(struct usb_interface *interface)
 	}
 }
 
-/* 
+/*
  * Presence of pre_reset and post_reset prevents the driver from being unbound
  * when the device is being reset
  */
- 
+
 int stub_pre_reset(struct usb_interface *interface)
 {
 	dev_dbg(&interface->dev, "pre_reset\n");
diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
index 538fb9e..1c1957f 100644
--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -175,7 +175,7 @@ static int tweak_reset_device_cmd(struct urb *urb)
 	dev_info(&urb->dev->dev, "usb_queue_reset_device\n");
 
 	/*
-	 * With the implementation of pre_reset and post_reset the driver no 
+	 * With the implementation of pre_reset and post_reset the driver no
 	 * longer unbinds. This allows the use of synchronous reset.
 	 */
 
-- 
1.7.5.4

