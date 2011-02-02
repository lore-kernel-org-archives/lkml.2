Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab1BBAor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:35413 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586Ab1BBAoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="598622554"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: t.sailer@alumni.ethz.ch, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [98/139] USB: misc: uss720.c: add another vendor/product ID
Message-Id: <20110202004456.51CE83E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Thomas Sailer <t.sailer@alumni.ethz.ch>

commit ecc1624a2fff45780959efbcb73ace18fdb3c58d upstream.

Fabio Battaglia report that he has another cable that works with this
driver, so this patch adds its vendor/product ID.

Signed-off-by: Thomas Sailer <t.sailer@alumni.ethz.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/misc/uss720.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/usb/misc/uss720.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/misc/uss720.c
+++ linux-2.6.35.y/drivers/usb/misc/uss720.c
@@ -3,7 +3,7 @@
 /*
  *	uss720.c  --  USS720 USB Parport Cable.
  *
- *	Copyright (C) 1999, 2005
+ *	Copyright (C) 1999, 2005, 2010
  *	    Thomas Sailer (t.sailer@alumni.ethz.ch)
  *
  *	This program is free software; you can redistribute it and/or modify
@@ -776,6 +776,8 @@ static const struct usb_device_id uss720
 	{ USB_DEVICE(0x0557, 0x2001) },
 	{ USB_DEVICE(0x0729, 0x1284) },
 	{ USB_DEVICE(0x1293, 0x0002) },
+	{ USB_DEVICE(0x1293, 0x0002) },
+	{ USB_DEVICE(0x050d, 0x0002) },
 	{ }						/* Terminating entry */
 };
 
