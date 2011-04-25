Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741Ab1DYUly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:41:54 -0400
Received: from 1wt.eu ([62.212.114.60]:34365 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299Ab1DYUYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:54 -0400
Message-Id: <20110425200236.948840860@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:03 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 091/173] USB: serial: ch341: add new id
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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
@@ -73,6 +73,7 @@ static int debug;
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x4348, 0x5523) },
 	{ USB_DEVICE(0x1a86, 0x7523) },
+	{ USB_DEVICE(0x1a86, 0x5523) },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);


