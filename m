Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1AEXpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:45:19 -0500
Received: from kroah.org ([198.145.64.141]:41056 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623Ab1AEXpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:45:18 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:27 2011
Message-Id: <20110105230327.173873064@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Thomas Sailer <t.sailer@alumni.ethz.ch>
Subject: [37/49] USB: misc: uss720.c: add another vendor/product ID
In-Reply-To: <20110105234415.GA22369@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Sailer <t.sailer@alumni.ethz.ch>

commit ecc1624a2fff45780959efbcb73ace18fdb3c58d upstream.

Fabio Battaglia report that he has another cable that works with this
driver, so this patch adds its vendor/product ID.

Signed-off-by: Thomas Sailer <t.sailer@alumni.ethz.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/misc/uss720.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/misc/uss720.c
+++ b/drivers/usb/misc/uss720.c
@@ -3,7 +3,7 @@
 /*
  *	uss720.c  --  USS720 USB Parport Cable.
  *
- *	Copyright (C) 1999, 2005
+ *	Copyright (C) 1999, 2005, 2010
  *	    Thomas Sailer (t.sailer@alumni.ethz.ch)
  *
  *	This program is free software; you can redistribute it and/or modify
@@ -775,6 +775,8 @@ static struct usb_device_id uss720_table
 	{ USB_DEVICE(0x0557, 0x2001) },
 	{ USB_DEVICE(0x0729, 0x1284) },
 	{ USB_DEVICE(0x1293, 0x0002) },
+	{ USB_DEVICE(0x1293, 0x0002) },
+	{ USB_DEVICE(0x050d, 0x0002) },
 	{ }						/* Terminating entry */
 };
 


