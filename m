Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2IIXRb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:17:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51484 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756367Ab2IIXRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:17:08 -0400
Message-Id: <20120909224151.136722090@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:41:51 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Cyrus Lien <cyrus.lien@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [ 01/95] HID: add ASUS AIO keyboard model AK1D
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyrus Lien <cyrus.lien@canonical.com>

commit 2d8767bb421574dfcf48e4be0751ce7d8f73d5d7 upstream.

Add Asus All-In-One PC keyboard model AK1D.

BugLink: https://bugs.launchpad.net/bugs/1027789

Signed-off-by: Cyrus Lien <cyrus.lien@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hid/hid-chicony.c |    1 +
 drivers/hid/hid-core.c    |    1 +
 drivers/hid/hid-ids.h     |    1 +
 3 files changed, 3 insertions(+)

--- a/drivers/hid/hid-chicony.c
+++ b/drivers/hid/hid-chicony.c
@@ -60,6 +60,7 @@ static int ch_input_mapping(struct hid_d
 static const struct hid_device_id ch_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_TACTICAL_PAD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_AK1D) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ch_devices);
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1398,6 +1398,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_TACTICAL_PAD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_AK1D) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHUNGHWAT, USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CREATIVELABS, USB_DEVICE_ID_PRODIKEYS_PCMIDI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CVTOUCH, USB_DEVICE_ID_CVTOUCH_SCREEN) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -196,6 +196,7 @@
 #define USB_DEVICE_ID_CHICONY_MULTI_TOUCH	0xb19d
 #define USB_DEVICE_ID_CHICONY_WIRELESS	0x0618
 #define USB_DEVICE_ID_CHICONY_WIRELESS2	0x1123
+#define USB_DEVICE_ID_CHICONY_AK1D	0x1125
 
 #define USB_VENDOR_ID_CHUNGHWAT		0x2247
 #define USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH	0x0001


