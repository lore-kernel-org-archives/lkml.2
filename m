Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab1CUXSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:18:14 -0400
Received: from kroah.org ([198.145.64.141]:52598 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236Ab1CUXRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:17:52 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:03:24 2011
Message-Id: <20110321230324.567633354@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:01:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [28/78] USB: serial: ch341: add new id
In-Reply-To: <20110321230346.GA14681@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: wangyanqing <udknight@gmail.com>

commit d0781383038e983a63843a9a6a067ed781db89c1 upstream.

I picked up a new DAK-780EX(professional digitl reverb/mix system),
which use CH341T chipset to communication with computer on 3/2011
and the CH341T's vendor code is 1a86

Looking up the CH341T's vendor and product id's I see:

1a86  QinHeng Electronics
  5523  CH341 in serial mode, usb to serial port converter

CH341T,CH341 are the products of the same company, maybe
have some common hardware, and I test the ch341.c works
well with CH341T

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/serial/ch341.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -75,6 +75,7 @@ static int debug;
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x4348, 0x5523) },
 	{ USB_DEVICE(0x1a86, 0x7523) },
+	{ USB_DEVICE(0x1a86, 0x5523) },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);


