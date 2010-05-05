Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab0EEXtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 19:49:06 -0400
Received: from kroah.org ([198.145.64.141]:60478 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab0EEXtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 19:49:03 -0400
Subject: patch usb-gadget-webcam-depends-on-video_dev.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, dbrownell@users.sourceforge.net, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       sfr@canb.auug.org.au
From: <gregkh@suse.de>
Date: Wed, 05 May 2010 16:48:22 -0700
In-Reply-To: <20100505154626.2c036f1d.randy.dunlap@oracle.com>
Message-ID: <12731033021951@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: USB: gadget webcam: depends on VIDEO_DEV

to my gregkh-2.6 tree.  Its filename is

    usb-gadget-webcam-depends-on-video_dev.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From randy.dunlap@oracle.com  Wed May  5 16:12:11 2010
From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 5 May 2010 15:46:26 -0700
Subject: USB: gadget webcam: depends on VIDEO_DEV
To: Stephen Rothwell <sfr@canb.auug.org.au>, lud <linux-usb@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de
Message-ID: <20100505154626.2c036f1d.randy.dunlap@oracle.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

g_webcam uses v4l[2] interfaces, so it should depend on VIDEO_DEV.

ERROR: "v4l2_event_unsubscribe" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_event_queue" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "video_device_release" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "video_usercopy" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_event_dequeue" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "video_register_device" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "video_device_alloc" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_event_subscribe" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "video_unregister_device" [drivers/usb/gadget/g_webcam.ko] ndefined!
ERROR: "v4l2_event_pending" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_fh_init" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_event_init" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "video_devdata" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_event_alloc" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_fh_add" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_fh_del" [drivers/usb/gadget/g_webcam.ko] undefined!
ERROR: "v4l2_fh_exit" [drivers/usb/gadget/g_webcam.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -879,6 +879,7 @@ config USB_G_HID
 # or video class gadget drivers), or specific hardware, here.
 config USB_G_WEBCAM
 	tristate "USB Webcam Gadget"
+	depends on VIDEO_DEV
 	help
 	  The Webcam Gadget acts as a composite USB Audio and Video Class
 	  device. It provides a userspace API to process UVC control requests

