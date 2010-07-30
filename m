Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab0G3SIj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:08:39 -0400
Received: from kroah.org ([198.145.64.141]:59212 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932511Ab0G3R5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:57:40 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:50 2010
Message-Id: <20100730175150.363934020@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:53:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [181/205] V4L/DVB: uvcvideo: Add support for Packard Bell EasyNote MX52 integrated webcam
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit f129b03ba272c86c42ad476684caa0d6109cb383 upstream.

The camera requires the STREAM_NO_FID quirk. Add a corresponding entry
in the device IDs list.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_driver.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -2105,6 +2105,15 @@ static struct usb_device_id uvc_ids[] =
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= UVC_QUIRK_STREAM_NO_FID },
+	/* Syntek (Packard Bell EasyNote MX52 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x174f,
+	  .idProduct		= 0x8a12,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_QUIRK_STREAM_NO_FID },
 	/* Syntek (Asus F9SG) */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,


