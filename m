Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab1DMQNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:13:14 -0400
Received: from kroah.org ([198.145.64.141]:52890 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932747Ab1DMQNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:46 2011
Message-Id: <20110413161046.488638500@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:10:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marc-Antoine Perennou <Marc-Antoine@Perennou.com>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [38/71] Bluetooth: add support for Apple MacBook Pro 8,2
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Marc-Antoine Perennou <Marc-Antoine@Perennou.com>

commit 63a8588debd4dc72becb9e27add9343c76301c7d upstream.

Just adding the vendor details makes it work fine.

Signed-off-by: Marc-Antoine Perennou <Marc-Antoine@Perennou.com>
Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/bluetooth/btusb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -59,6 +59,9 @@ static struct usb_device_id btusb_table[
 	/* Generic Bluetooth USB device */
 	{ USB_DEVICE_INFO(0xe0, 0x01, 0x01) },
 
+	/* Apple MacBookPro8,2 */
+	{ USB_DEVICE(0x05ac, 0x821a) },
+
 	/* AVM BlueFRITZ! USB v2.0 */
 	{ USB_DEVICE(0x057c, 0x3800) },
 


