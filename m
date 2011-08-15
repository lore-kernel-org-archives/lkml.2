Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab1HOVOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 17:14:17 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:65500 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab1HOVOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 17:14:16 -0400
From: Akshay Joshi <me@akshayjoshi.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Akshay Joshi <me@akshayjoshi.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: GMA500: Convert spaces to tabs in accel_2d.c.
Date: Mon, 15 Aug 2011 17:13:34 -0400
Message-Id: <1313442815-12792-1-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the spaces within the accel_2d.c file to tabs in order to comply
with the coding style of the kernel.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 drivers/staging/gma500/accel_2d.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/gma500/accel_2d.c b/drivers/staging/gma500/accel_2d.c
index 14400fc..be92371 100644
--- a/drivers/staging/gma500/accel_2d.c
+++ b/drivers/staging/gma500/accel_2d.c
@@ -118,7 +118,7 @@ static int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
 		size -= submit_size;
 		ret = psb_2d_wait_available(dev_priv, submit_size);
 		if (ret)
-		        break;
+			break;
 
 		submit_size <<= 2;
 
@@ -388,19 +388,19 @@ int psb_accel_ioctl(struct drm_device *dev, void *data, struct drm_file *file)
 	for (i = 0; i < op->size; i++, op_ptr++) {
 		u32 r = *op_ptr & 0xF0000000;
 		/* Fill in the GTT offsets for the command buffer */
-        	if (r == PSB_2D_SRC_SURF_BH ||
-			r == PSB_2D_DST_SURF_BH || 
+		if (r == PSB_2D_SRC_SURF_BH ||
+			r == PSB_2D_DST_SURF_BH ||
 			r == PSB_2D_MASK_SURF_BH ||
 			r == PSB_2D_PAT_SURF_BH) {
 			i++;
 			op_ptr++;
 			if (i == op->size)
 				goto bad;
-                        if (*op_ptr)
+			if (*op_ptr)
 				goto bad;
-                        *op_ptr = gtt->offset;
-                        continue;
-                }
+			*op_ptr = gtt->offset;
+			continue;
+		}
 	}
 	psbfb_2d_submit(dev_priv, op->cmd, op->size);
 	err = 0;
-- 
1.7.5.4

