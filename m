Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab1BVWVk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:21:40 -0500
Received: from kroah.org ([198.145.64.141]:46669 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab1BVWVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:21:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:39 2011
Message-Id: <20110222221839.273401396@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [22/70] HID: add Add Cando touch screen 10.1-inch product id
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benjamin Tissoires <benjamin.tissoires@enac.fr>

commit bc5ab083a68bfec212780281f8e57d871d8882a0 upstream.

This device has been reported to be an hid-cando one.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-cando.c |    2 ++
 drivers/hid/hid-core.c  |    1 +
 drivers/hid/hid-ids.h   |    1 +
 3 files changed, 4 insertions(+)

--- a/drivers/hid/hid-cando.c
+++ b/drivers/hid/hid-cando.c
@@ -236,6 +236,8 @@ static const struct hid_device_id cando_
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
+			USB_DEVICE_ID_CANDO_MULTI_TOUCH_10_1) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
 			USB_DEVICE_ID_CANDO_MULTI_TOUCH_11_6) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO,
 		USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6) },
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1287,6 +1287,7 @@ static const struct hid_device_id hid_bl
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BTC, USB_DEVICE_ID_BTC_EMPREX_REMOTE_2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO, USB_DEVICE_ID_CANDO_MULTI_TOUCH) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO, USB_DEVICE_ID_CANDO_MULTI_TOUCH_10_1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO, USB_DEVICE_ID_CANDO_MULTI_TOUCH_11_6) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CANDO, USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_CYMOTION) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -135,6 +135,7 @@
 
 #define USB_VENDOR_ID_CANDO		0x2087
 #define USB_DEVICE_ID_CANDO_MULTI_TOUCH	0x0a01
+#define USB_DEVICE_ID_CANDO_MULTI_TOUCH_10_1 0x0a02
 #define USB_DEVICE_ID_CANDO_MULTI_TOUCH_11_6 0x0b03
 #define USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6 0x0f01
 


