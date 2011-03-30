Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789Ab1C3V1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:27:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:48428 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964956Ab1C3VJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133726"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: udknight@gmail.com, torvalds@linux-foundation.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [200/275] USB: serial: ch341: add new id
Message-Id: <20110330210724.4AE133E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/serial/ch341.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/usb/serial/ch341.c
===================================================================
--- linux-2.6.35.y.orig/drivers/usb/serial/ch341.c	2011-03-29 23:02:58.478339106 -0700
+++ linux-2.6.35.y/drivers/usb/serial/ch341.c	2011-03-29 23:03:02.441237705 -0700
@@ -75,6 +75,7 @@
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x4348, 0x5523) },
 	{ USB_DEVICE(0x1a86, 0x7523) },
+	{ USB_DEVICE(0x1a86, 0x5523) },
 	{ },
 };
 MODULE_DEVICE_TABLE(usb, id_table);
