Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab1KJFBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:01:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935089Ab1KJD3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:29:31 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:18 2011
Message-Id: <20111109212718.148406528@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ricardo Mendoza <ricmm@gentoo.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [175/262] Bluetooth: Add Toshiba laptops AR30XX device ID
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Mendoza <ricmm@gentoo.org>

commit 8e7c3d2e4ba18ee4cdcc1f89aec944fbff4ce735 upstream.

Blacklist Toshiba-branded AR3011 based AR5B195 [0930:0215] and add to
ath3k.c for firmware loading.

Signed-off-by: Ricardo Mendoza <ricmm@gentoo.org>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/bluetooth/ath3k.c |    1 +
 drivers/bluetooth/btusb.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -63,6 +63,7 @@ static struct usb_device_id ath3k_table[
 	/* Atheros AR3011 with sflash firmware*/
 	{ USB_DEVICE(0x0CF3, 0x3002) },
 	{ USB_DEVICE(0x13d3, 0x3304) },
+	{ USB_DEVICE(0x0930, 0x0215) },
 
 	/* Atheros AR9285 Malbec with sflash firmware */
 	{ USB_DEVICE(0x03F0, 0x311D) },
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -108,6 +108,7 @@ static struct usb_device_id blacklist_ta
 	/* Atheros 3011 with sflash firmware */
 	{ USB_DEVICE(0x0cf3, 0x3002), .driver_info = BTUSB_IGNORE },
 	{ USB_DEVICE(0x13d3, 0x3304), .driver_info = BTUSB_IGNORE },
+	{ USB_DEVICE(0x0930, 0x0215), .driver_info = BTUSB_IGNORE },
 
 	/* Atheros AR9285 Malbec with sflash firmware */
 	{ USB_DEVICE(0x03f0, 0x311d), .driver_info = BTUSB_IGNORE },


