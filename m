Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab1HQT7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 15:59:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61579 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab1HQT7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 15:59:18 -0400
From: Akshay Joshi <me@akshayjoshi.com>
To: Matt Mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Akshay Joshi <me@akshayjoshi.com>
Subject: [PATCH 2/2] Staging: usbip: Fix braces and spaces to match coding style.
Date: Wed, 17 Aug 2011 15:58:32 -0400
Message-Id: <1313611112-16083-2-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313611112-16083-1-git-send-email-me@akshayjoshi.com>
References: <1313611112-16083-1-git-send-email-me@akshayjoshi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix brace positioning and spaces at the start of lines in order to
comply with the kernel coding style.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 drivers/staging/usbip/stub_dev.c |    2 +-
 drivers/staging/usbip/stub_rx.c  |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/staging/usbip/stub_dev.c
index 1dacdc0..77d6469 100644
--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -548,4 +548,4 @@ struct usb_driver stub_driver = {
 	.id_table	= stub_table,
 	.pre_reset	= stub_pre_reset,
 	.post_reset	= stub_post_reset,
- };
+};
diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/staging/usbip/stub_rx.c
index 1c1957f..6b4e3e1 100644
--- a/drivers/staging/usbip/stub_rx.c
+++ b/drivers/staging/usbip/stub_rx.c
@@ -179,8 +179,7 @@ static int tweak_reset_device_cmd(struct urb *urb)
 	 * longer unbinds. This allows the use of synchronous reset.
 	 */
 
-	if (usb_lock_device_for_reset(sdev->udev, sdev->interface)<0)
-	{
+	if (usb_lock_device_for_reset(sdev->udev, sdev->interface) < 0) {
 		dev_err(&urb->dev->dev, "could not obtain lock to reset device\n");
 		return 0;
 	}
-- 
1.7.5.4

