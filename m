Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab0HEK0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 06:26:42 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46301 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab0HEK0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 06:26:24 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 05 Aug 2010 12:27:37 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv6 3/7] USB: gadget: g_ffs: fixed vendor and product ID
In-reply-to: <c66a92a8efa1ec83017633035352ba4a936d0f94.1281002833.git.m.nazarewicz@samsung.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        USB <linux-usb@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <c59df14c2fff1e327bb37f382769dad9b41da01c.1281002833.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <cover.1281002833.git.m.nazarewicz@samsung.com>
 <4d9f94eea017dfb5c1931aecd56c7b3de92de1ad.1281002833.git.m.nazarewicz@samsung.com>
 <c66a92a8efa1ec83017633035352ba4a936d0f94.1281002833.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the vendor and product ID the gadget uses
by replacing the temporary IDs that were used during
development (which should never get into mainline) with
proper IDs.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/g_ffs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
index a9474f8..3c2f0a4 100644
--- a/drivers/usb/gadget/g_ffs.c
+++ b/drivers/usb/gadget/g_ffs.c
@@ -53,8 +53,8 @@ MODULE_AUTHOR("Michal Nazarewicz");
 MODULE_LICENSE("GPL");
 
 
-static unsigned short gfs_vendor_id    = 0x0525;	/* XXX NetChip */
-static unsigned short gfs_product_id   = 0xa4ac;	/* XXX */
+static unsigned short gfs_vendor_id    = 0x1d6b;	/* Linux Foundation */
+static unsigned short gfs_product_id   = 0x0105;	/* FunctionFS Gadget */
 
 static struct usb_device_descriptor gfs_dev_desc = {
 	.bLength		= sizeof gfs_dev_desc,
-- 
1.7.1

