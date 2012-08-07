Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab2HGW1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:27:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64363 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932272Ab2HGW1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:27:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Albert Pool <albertpool@solcon.nl>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 017/122] rt2800usb: 2001:3c17 is an RT3370 device
Date: Tue,  7 Aug 2012 15:25:05 -0700
Message-Id: <20120807221949.787828382@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807221948.220495155@linuxfoundation.org>
References: <20120807221948.220495155@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Albert Pool <albertpool@solcon.nl>

commit 8fd9d059af12786341dec5a688e607bcdb372238 upstream.

D-Link DWA-123 rev A1

Signed-off-by: Albert Pool<albertpool@solcon.nl>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800usb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1137,6 +1137,8 @@ static struct usb_device_id rt2800usb_de
 #ifdef CONFIG_RT2800USB_RT33XX
 	/* Belkin */
 	{ USB_DEVICE(0x050d, 0x945b) },
+	/* D-Link */
+	{ USB_DEVICE(0x2001, 0x3c17) },
 	/* Panasonic */
 	{ USB_DEVICE(0x083a, 0xb511) },
 	/* Philips */
@@ -1237,7 +1239,6 @@ static struct usb_device_id rt2800usb_de
 	/* D-Link */
 	{ USB_DEVICE(0x07d1, 0x3c0b) },
 	{ USB_DEVICE(0x07d1, 0x3c17) },
-	{ USB_DEVICE(0x2001, 0x3c17) },
 	/* Encore */
 	{ USB_DEVICE(0x203d, 0x14a1) },
 	/* Gemtek */


