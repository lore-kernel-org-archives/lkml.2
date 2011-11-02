Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934719Ab1KCBl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:41:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934684Ab1KCBly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:41:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:42 2011
Message-Id: <20111102222742.715676749@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marek Vasut <marek.vasut@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [033/101] ASIX: Add AX88772B USB ID
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Marek Vasut <marek.vasut@gmail.com>

commit 308859097831831a979f2e82cbeef0a94f438080 upstream.

This device can be found in Acer Iconia TAB W500 tablet dock.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/asix.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -1441,6 +1441,10 @@ static const struct usb_device_id	produc
 	USB_DEVICE (0x04f1, 0x3008),
 	.driver_info = (unsigned long) &ax8817x_info,
 }, {
+	// ASIX AX88772B 10/100
+	USB_DEVICE (0x0b95, 0x772b),
+	.driver_info = (unsigned long) &ax88772_info,
+}, {
 	// ASIX AX88772 10/100
 	USB_DEVICE (0x0b95, 0x7720),
 	.driver_info = (unsigned long) &ax88772_info,


