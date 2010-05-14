Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830Ab0ENTDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:03:45 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61389 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab0ENTDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:03:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dItTTErONftUAXayk6xyfQgHqzFo4gWhepw0aoiOB6nm6UMr2Ar/HHQ++W2Z8PHVVh
         OALuSU8or8e6ydkzo9jCuKumIIb4kO6vssUTV751xaU1AqrMWeB62o47rRezjEh+fMy+
         H7gfCOdXdZb3mQu5HkwDaMWrMoN48vusfGeKI=
From: Soeren Moeller <soerenmoeller2001@gmail.com>
To: gregkh@suse.de, bernie@plugable.com, amit.kucheria@canonical.com,
       tj@kernel.org, cl@linux-foundation.org, soerenmoeller2001@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: udlfb: fix coding style issues
Date: Fri, 14 May 2010 19:03:00 +0000
Message-Id: <1273863780-15617-1-git-send-email-soerenmoeller2001@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the file udlfb.c that fixes a missing KERN_INFO and removes one whitespace before a newline.

Signed-off-by: Soeren Moeller <soerenmoeller2001@gmail.com>
---
 drivers/staging/udlfb/udlfb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/udlfb/udlfb.c b/drivers/staging/udlfb/udlfb.c
index a78ade0..c294fd3 100644
--- a/drivers/staging/udlfb/udlfb.c
+++ b/drivers/staging/udlfb/udlfb.c
@@ -1438,7 +1438,7 @@ static int __init dlfb_module_init(void)
 	if (res)
 		err("usb_register failed. Error number %d", res);
 
-	printk("VMODES initialized\n");
+	printk(KERN_INFO "VMODES initialized\n");
 
 	return res;
 }
@@ -1567,7 +1567,7 @@ static int dlfb_alloc_urb_list(struct dlfb_data *dev, int count, size_t size)
 
 	kref_get(&dev->kref); /* released in free_render_urbs() */
 
-	dl_notice("allocated %d %d byte urbs \n", i, (int) size);
+	dl_notice("allocated %d %d byte urbs\n", i, (int) size);
 
 	return i;
 }
-- 
1.6.3.3

