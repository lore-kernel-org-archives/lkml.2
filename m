Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab2AXC7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:59:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535Ab2AXCqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:46:46 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:31 2012
Message-Id: <20120124023931.682540331@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>
Subject: [087/129] HID: multitouch: add support for 3M 32"
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1136
Lines: 37

From: Benjamin Tissoires <benjamin.tissoires@gmail.com>

commit c4fad877cd0efb51d8180ae2eaa791c99c92051c upstream.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Acked-by: Henrik Rydberg <rydberg@euromail.se>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/hid-ids.h        |    1 +
 drivers/hid/hid-multitouch.c |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -21,6 +21,7 @@
 #define USB_VENDOR_ID_3M		0x0596
 #define USB_DEVICE_ID_3M1968		0x0500
 #define USB_DEVICE_ID_3M2256		0x0502
+#define USB_DEVICE_ID_3M3266		0x0506
 
 #define USB_VENDOR_ID_A4TECH		0x09da
 #define USB_DEVICE_ID_A4TECH_WCP32PU	0x0006
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -609,6 +609,9 @@ static const struct hid_device_id mt_dev
 	{ .driver_data = MT_CLS_3M,
 		HID_USB_DEVICE(USB_VENDOR_ID_3M,
 			USB_DEVICE_ID_3M2256) },
+	{ .driver_data = MT_CLS_3M,
+		HID_USB_DEVICE(USB_VENDOR_ID_3M,
+			USB_DEVICE_ID_3M3266) },
 
 	/* ActionStar panels */
 	{ .driver_data = MT_CLS_DEFAULT,


