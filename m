Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab0HIPBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 11:01:16 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:40614 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801Ab0HIPBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 11:01:09 -0400
Date: Mon, 09 Aug 2010 17:02:26 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv7 1/8] USB: gadget: g_multi: fixed vendor and product ID
In-reply-to: <cover.1281365237.git.m.nazarewicz@samsung.com>
To: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        USB <linux-usb@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <49ebe5a39e05aa55a19d33a2141736d215873f86.1281365237.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1281365237.git.m.nazarewicz@samsung.com>
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

