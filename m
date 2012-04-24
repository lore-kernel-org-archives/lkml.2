Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964925Ab2DXWmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:42:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964795Ab2DXWin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:38:43 -0400
Message-Id: <20120424223256.138435895@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Gertjan van Wingerde <gwingerde@gmail.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 31/42] rt2x00: Properly identify rt2800usb devices.
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gertjan van Wingerde <gwingerde@gmail.com>

commit acb56120d2c386d6dd104a6515c1a15dabc1ef87 upstream.

Sitecom WLA4000 (USB ID 0x0df6:0x0060) is an RT3072 chipset.
Sitecom WLA5000 (USB ID 0x0df6:0x0062) is an RT3572 chipset.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800usb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -943,6 +943,7 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x0df6, 0x0048) },
 	{ USB_DEVICE(0x0df6, 0x0051) },
 	{ USB_DEVICE(0x0df6, 0x005f) },
+	{ USB_DEVICE(0x0df6, 0x0060) },
 	/* SMC */
 	{ USB_DEVICE(0x083a, 0x6618) },
 	{ USB_DEVICE(0x083a, 0x7511) },
@@ -999,6 +1000,7 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x148f, 0x3572) },
 	/* Sitecom */
 	{ USB_DEVICE(0x0df6, 0x0041) },
+	{ USB_DEVICE(0x0df6, 0x0062) },
 	/* Toshiba */
 	{ USB_DEVICE(0x0930, 0x0a07) },
 	/* Zinwell */
@@ -1096,8 +1098,6 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x0df6, 0x004a) },
 	{ USB_DEVICE(0x0df6, 0x004d) },
 	{ USB_DEVICE(0x0df6, 0x0053) },
-	{ USB_DEVICE(0x0df6, 0x0060) },
-	{ USB_DEVICE(0x0df6, 0x0062) },
 	/* SMC */
 	{ USB_DEVICE(0x083a, 0xa512) },
 	{ USB_DEVICE(0x083a, 0xc522) },


