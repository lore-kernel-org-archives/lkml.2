Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab2AJW5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:57:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668Ab2AJW5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:57:16 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:46:18 2012
Message-Id: <20120110214618.582839587@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:45:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Ivo van Doorn <IvDoorn@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [04/40] rt2800usb: Move ID out of unknown
In-Reply-To: <20120110214630.GA14384@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 3f81f8f1524ccca24df1029b0cf825ecef5e5cdc upstream.

Testing on the openSUSE wireless forum has shown that a Linksys
WUSB54GC v3 with USB ID 1737:0077 works with rt2800usb when the ID is
written to /sys/.../new_id. This ID can therefore be moved out of UNKNOWN.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -878,6 +878,7 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x13b1, 0x0031) },
 	{ USB_DEVICE(0x1737, 0x0070) },
 	{ USB_DEVICE(0x1737, 0x0071) },
+	{ USB_DEVICE(0x1737, 0x0077) },
 	/* Logitec */
 	{ USB_DEVICE(0x0789, 0x0162) },
 	{ USB_DEVICE(0x0789, 0x0163) },
@@ -1069,7 +1070,6 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x1740, 0x0605) },
 	{ USB_DEVICE(0x1740, 0x0615) },
 	/* Linksys */
-	{ USB_DEVICE(0x1737, 0x0077) },
 	{ USB_DEVICE(0x1737, 0x0078) },
 	/* Logitec */
 	{ USB_DEVICE(0x0789, 0x0168) },


