Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab0GAWUC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:20:02 -0400
Received: from kroah.org ([198.145.64.141]:47200 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932509Ab0GAUtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:49:39 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:28 2010
Message-Id: <20100701173428.810589781@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:33:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Cory Maccarrone <darkstar6262@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [patch 023/164] HID: Add the GYR4101US USB ID to hid-gyration
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cory Maccarrone <darkstar6262@gmail.com>

commit c2fd1a4ebf9127c280d227acb635eb1df213439c upstream.

This change adds in the USB product ID for the Gyration
GYR4101US USB media center remote control.  This remote
is similar enough to the other two devices that this driver
can be used without any other changes to get full support
for the remote.

Signed-off-by: Cory Maccarrone <darkstar6262@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-core.c     |    1 +
 drivers/hid/hid-gyration.c |    1 +
 drivers/hid/hid-ids.h      |    1 +
 3 files changed, 3 insertions(+)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1305,6 +1305,7 @@ static const struct hid_device_id hid_bl
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GREENASIA, 0x0012) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_3) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KENSINGTON, USB_DEVICE_ID_KS_SLIMBLADE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_ERGO_525V) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LABTEC, USB_DEVICE_ID_LABTEC_WIRELESS_KEYBOARD) },
--- a/drivers/hid/hid-gyration.c
+++ b/drivers/hid/hid-gyration.c
@@ -73,6 +73,7 @@ static int gyration_event(struct hid_dev
 static const struct hid_device_id gyration_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_GYRATION, USB_DEVICE_ID_GYRATION_REMOTE_3) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, gyration_devices);
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -256,6 +256,7 @@
 #define USB_VENDOR_ID_GYRATION		0x0c16
 #define USB_DEVICE_ID_GYRATION_REMOTE	0x0002
 #define USB_DEVICE_ID_GYRATION_REMOTE_2 0x0003
+#define USB_DEVICE_ID_GYRATION_REMOTE_3 0x0008
 
 #define USB_VENDOR_ID_HAPP		0x078b
 #define USB_DEVICE_ID_UGCI_DRIVING	0x0010


