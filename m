Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab1HAXbJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:31:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab1HAX1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:27:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:53 2011
Message-Id: <20110801232053.895442745@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [33/70] carl9170: add NEC WL300NU-AG usbid
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit 06a86ddbf557cb8a0f7ded54e872e9d456002d52 upstream.

Reported-by: Mark Davis
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/carl9170/usb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -112,6 +112,8 @@ static struct usb_device_id carl9170_usb
 	{ USB_DEVICE(0x04bb, 0x093f) },
 	/* NEC WL300NU-G */
 	{ USB_DEVICE(0x0409, 0x0249) },
+	/* NEC WL300NU-AG */
+	{ USB_DEVICE(0x0409, 0x02b4) },
 	/* AVM FRITZ!WLAN USB Stick N */
 	{ USB_DEVICE(0x057c, 0x8401) },
 	/* AVM FRITZ!WLAN USB Stick N 2.4 */


