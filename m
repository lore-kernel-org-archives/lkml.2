Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab2GFOVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 10:21:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54702 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622Ab2GFOVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 10:21:36 -0400
From: therealcykey@gmail.com
To: gregkh@linuxfoumdation.org, kyungmin.park@samsung.com,
        andrzej.p@samsung.com
Cc: benoit@android.com, lockwood@android.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, David Murray <therealcykey@gmail.com>
Subject: [PATCH] Drivers: Staging: ccg: Made checkpatch.pl clean
Date: Fri,  6 Jul 2012 09:20:43 -0500
Message-Id: <1341584444-2414-1-git-send-email-therealcykey@live.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Murray <therealcykey@gmail.com>

Fixed a tiny checkpatch.pl warning.

Signed-off-by: David Murray <therealcykey@gmail.com>
---
 drivers/staging/ccg/ccg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccg/ccg.c b/drivers/staging/ccg/ccg.c
index a5b36a9..c50fa02 100644
--- a/drivers/staging/ccg/ccg.c
+++ b/drivers/staging/ccg/ccg.c
@@ -1143,7 +1143,7 @@ static int ccg_bind(struct usb_composite_dev *cdev)
 	if (gcnum >= 0)
 		device_desc.bcdDevice = cpu_to_le16(0x0200 + gcnum);
 	else {
-		pr_warning("%s: controller '%s' not recognized\n",
+		pr_warn("%s: controller '%s' not recognized\n",
 			longname, gadget->name);
 		device_desc.bcdDevice = __constant_cpu_to_le16(0x9999);
 	}
-- 
1.7.9.5

