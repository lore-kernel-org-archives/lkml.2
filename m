Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab1BFXqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:46:38 -0500
Received: from 1wt.eu ([62.212.114.60]:60329 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180Ab1BFXqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:46:36 -0500
Message-Id: <20110206232252.744607298@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:22:57 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Thomas Sailer <t.sailer@alumni.ethz.ch>,
        Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH 05/23] USB: misc: uss720.c: add another vendor/product ID
In-Reply-To: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.58-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Sailer <t.sailer@alumni.ethz.ch>

commit ecc1624a2fff45780959efbcb73ace18fdb3c58d upstream.

Fabio Battaglia report that he has another cable that works with this
driver, so this patch adds its vendor/product ID.

Signed-off-by: Thomas Sailer <t.sailer@alumni.ethz.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>

---
 drivers/usb/misc/uss720.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: longterm-2.6.27/drivers/usb/misc/uss720.c
===================================================================
--- longterm-2.6.27.orig/drivers/usb/misc/uss720.c	2011-01-29 11:19:14.700064522 +0100
+++ longterm-2.6.27/drivers/usb/misc/uss720.c	2011-01-29 11:27:23.196065599 +0100
@@ -3,7 +3,7 @@
 /*
  *	uss720.c  --  USS720 USB Parport Cable.
  *
- *	Copyright (C) 1999, 2005
+ *	Copyright (C) 1999, 2005, 2010
  *	    Thomas Sailer (t.sailer@alumni.ethz.ch)
  *
  *	This program is free software; you can redistribute it and/or modify
@@ -774,6 +774,8 @@
 	{ USB_DEVICE(0x0557, 0x2001) },
 	{ USB_DEVICE(0x0729, 0x1284) },
 	{ USB_DEVICE(0x1293, 0x0002) },
+	{ USB_DEVICE(0x1293, 0x0002) },
+	{ USB_DEVICE(0x050d, 0x0002) },
 	{ }						/* Terminating entry */
 };
 


