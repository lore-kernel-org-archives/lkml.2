Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab2DTS3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 14:29:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40933 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab2DTS3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 14:29:01 -0400
From: Renzo Dani <arons7@gmail.com>
To: laurent.pinchart@ideasonboard.com
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, arons7@gmail.com
Subject: [PATCH 1/1] Added GenesysLogic BW Microscope device id
Date: Fri, 20 Apr 2012 20:28:43 +0200
Message-Id: <1334946523-14618-1-git-send-email-arons7@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Renzo Dani <arons7@gmail.com>


Signed-off-by: Renzo Dani <arons7@gmail.com>
---
 drivers/media/video/uvc/uvc_driver.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 1d13172..b8c94b4 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -2176,7 +2176,16 @@ static struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_STREAM_NO_FID },
-	/* Hercules Classic Silver */
+	/* Genesys Logic USB 2.0 BW Microscope */
+        { .match_flags          = USB_DEVICE_ID_MATCH_DEVICE
+                                | USB_DEVICE_ID_MATCH_INT_INFO,
+          .idVendor             = 0x05e3,
+          .idProduct            = 0x0511,
+          .bInterfaceClass      = USB_CLASS_VIDEO,
+          .bInterfaceSubClass   = 1,
+          .bInterfaceProtocol   = 0,
+          .driver_info          = UVC_QUIRK_STREAM_NO_FID },
+        /* Hercules Classic Silver */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
 	  .idVendor		= 0x06f8,
-- 
1.7.3.4

