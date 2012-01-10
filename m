Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820Ab2AJUKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 15:10:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699Ab2AJUKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 15:10:34 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 12:08:50 2012
Message-Id: <20120110200850.284344976@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 12:06:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Aurelien Jacobs <aurel@gnuage.org>,
        Grant Grundler <grundler@chromium.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [06/20] asix: new device id
In-Reply-To: <20120110200902.GA5674@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Aurelien Jacobs <aurel@gnuage.org>

commit e8303a3b2196272c3eb994d0fd1a189a958a2bdd upstream.

Adds the device id needed for the USB Ethernet Adapter delivered by
ASUS with their Zenbook.

Signed-off-by: Aurelien Jacobs <aurel@gnuage.org>
Acked-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/asix.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -1522,6 +1522,10 @@ static const struct usb_device_id	produc
 	// ASIX 88772a
 	USB_DEVICE(0x0db0, 0xa877),
 	.driver_info = (unsigned long) &ax88772_info,
+}, {
+	// Asus USB Ethernet Adapter
+	USB_DEVICE (0x0b95, 0x7e2b),
+	.driver_info = (unsigned long) &ax88772_info,
 },
 	{ },		// END
 };


