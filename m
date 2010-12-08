Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab0LHBXC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:23:02 -0500
Received: from kroah.org ([198.145.64.141]:33547 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932569Ab0LHBCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:52 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:41 2010
Message-Id: <20101208005741.185448164@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Josh Wu <josh.wu@atmel.com>, Jiri Kosina <jkosina@suse.cz>
Subject: [197/289] USB: gadget: AT91: fix typo in atmel_usba_udc driver
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Josh Wu <josh.wu@atmel.com>

commit b48809518631880207796b4aab0fc39c2f036754 upstream.

compile fix for bug introduced by 969affff547027)

Signed-off-by: Josh Wu <josh.wu@atmel.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/atmel_usba_udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -2016,7 +2016,7 @@ static int __init usba_udc_probe(struct
 			}
 		} else {
 			/* gpio_request fail so use -EINVAL for gpio_is_valid */
-			ubc->vbus_pin = -EINVAL;
+			udc->vbus_pin = -EINVAL;
 		}
 	}
 


