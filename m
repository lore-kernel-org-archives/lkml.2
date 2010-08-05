Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab0HEK00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 06:26:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29408 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab0HEK0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 06:26:19 -0400
Date: Thu, 05 Aug 2010 12:27:36 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv6 2/7] USB: gadget: g_multi: fixed vendor and product ID
In-reply-to: <4d9f94eea017dfb5c1931aecd56c7b3de92de1ad.1281002833.git.m.nazarewicz@samsung.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        USB <linux-usb@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <c66a92a8efa1ec83017633035352ba4a936d0f94.1281002833.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1281002833.git.m.nazarewicz@samsung.com>
 <4d9f94eea017dfb5c1931aecd56c7b3de92de1ad.1281002833.git.m.nazarewicz@samsung.com>
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
 drivers/usb/gadget/multi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/multi.c b/drivers/usb/gadget/multi.c
index 795d762..36d67a3 100644
--- a/drivers/usb/gadget/multi.c
+++ b/drivers/usb/gadget/multi.c
@@ -74,8 +74,8 @@ MODULE_LICENSE("GPL");
 
 /***************************** Device Descriptor ****************************/
 
-#define MULTI_VENDOR_NUM	0x0525	/* XXX NetChip */
-#define MULTI_PRODUCT_NUM	0xa4ab	/* XXX */
+#define MULTI_VENDOR_NUM	0x1d6b	/* Linux Foundation */
+#define MULTI_PRODUCT_NUM	0x0104	/* Multifunction Composite Gadget */
 
 
 enum {
-- 
1.7.1

