Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034Ab0KSW3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:29:35 -0500
Received: from kroah.org ([198.145.64.141]:45083 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757387Ab0KSV6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:58:38 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:41 2010
Message-Id: <20101119215641.306568974@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:55:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [31/82] USB: gadget: g_ffs: fixed vendor and product ID
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michal Nazarewicz <m.nazarewicz@samsung.com>

commit ba0534be935d7b24e5fdd6f82c443ee75abc9149 upstream.

This patch fixes the vendor and product ID the gadget uses
by replacing the temporary IDs that were used during
development (which should never get into mainline) with
proper IDs.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/g_ffs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -52,8 +52,8 @@ MODULE_AUTHOR("Michal Nazarewicz");
 MODULE_LICENSE("GPL");
 
 
-static unsigned short gfs_vendor_id    = 0x0525;	/* XXX NetChip */
-static unsigned short gfs_product_id   = 0xa4ac;	/* XXX */
+static unsigned short gfs_vendor_id    = 0x1d6b;	/* Linux Foundation */
+static unsigned short gfs_product_id   = 0x0105;	/* FunctionFS Gadget */
 
 static struct usb_device_descriptor gfs_dev_desc = {
 	.bLength		= sizeof gfs_dev_desc,


