Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932727Ab0KSWMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:12:48 -0500
Received: from kroah.org ([198.145.64.141]:52964 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758105Ab0KSWEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:20 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:25 2010
Message-Id: <20101119220124.969389607@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:01:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [34/66] USB: gadget: g_multi: fixed vendor and product ID
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michal Nazarewicz <m.nazarewicz@samsung.com>

commit 1c6529e92b7682573837e9c9eb7b5ba7a8216a88 upstream.

This patch fixes the vendor and product ID the gadget uses
by replacing the temporary IDs that were used during
development (which should never get into mainline) with
proper IDs.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/multi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -74,8 +74,8 @@ MODULE_LICENSE("GPL");
 
 /***************************** Device Descriptor ****************************/
 
-#define MULTI_VENDOR_NUM	0x0525	/* XXX NetChip */
-#define MULTI_PRODUCT_NUM	0xa4ab	/* XXX */
+#define MULTI_VENDOR_NUM	0x1d6b	/* Linux Foundation */
+#define MULTI_PRODUCT_NUM	0x0104	/* Multifunction Composite Gadget */
 
 
 enum {


