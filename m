Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab0LLXrd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:47:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36424 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab0LLXra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:30 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: josh.wu@atmel.com, jkosina@suse.cz, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [146/223] USB: gadget: AT91: fix typo in atmel_usba_udc driver
Message-Id: <20101212234729.36843B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Josh Wu <josh.wu@atmel.com>

commit b48809518631880207796b4aab0fc39c2f036754 upstream.

compile fix for bug introduced by 969affff547027)

Signed-off-by: Josh Wu <josh.wu@atmel.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/usb/gadget/atmel_usba_udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/usb/gadget/atmel_usba_udc.c
===================================================================
--- linux.orig/drivers/usb/gadget/atmel_usba_udc.c
+++ linux/drivers/usb/gadget/atmel_usba_udc.c
@@ -2016,7 +2016,7 @@ static int __init usba_udc_probe(struct
 			}
 		} else {
 			/* gpio_request fail so use -EINVAL for gpio_is_valid */
-			ubc->vbus_pin = -EINVAL;
+			udc->vbus_pin = -EINVAL;
 		}
 	}
 
