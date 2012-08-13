Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2HMUaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:30:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51310 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab2HMUYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:24:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Cyrus Lien <cyrus.lien@canonical.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [ 63/82] HID: add ASUS AIO keyboard model AK1D
Date: Mon, 13 Aug 2012 13:19:39 -0700
Message-Id: <20120813201751.977156956@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cyrus Lien <cyrus.lien@canonical.com>

commit 2d8767bb421574dfcf48e4be0751ce7d8f73d5d7 upstream.

Add Asus All-In-One PC keyboard model AK1D.

BugLink: https://bugs.launchpad.net/bugs/1027789

Signed-off-by: Cyrus Lien <cyrus.lien@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
@@ -1521,6 +1521,7 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_TACTICAL_PAD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELESS2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_AK1D) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CREATIVELABS, USB_DEVICE_ID_PRODIKEYS_PCMIDI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_1) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE_2) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -208,6 +208,7 @@
 #define USB_DEVICE_ID_CHICONY_MULTI_TOUCH	0xb19d
 #define USB_DEVICE_ID_CHICONY_WIRELESS	0x0618
 #define USB_DEVICE_ID_CHICONY_WIRELESS2	0x1123
+#define USB_DEVICE_ID_CHICONY_AK1D	0x1125
 
 #define USB_VENDOR_ID_CHUNGHWAT		0x2247
 #define USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH	0x0001


