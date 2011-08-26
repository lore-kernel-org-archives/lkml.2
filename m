Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab1HZKXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:23:55 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49236 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab1HZKXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:23:54 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 5/9] gma500: Convert spaces to tabs in accel_2d.c.
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 26 Aug 2011 11:18:57 +0100
Message-ID: <20110826101852.16760.85907.stgit@localhost.localdomain>
In-Reply-To: <20110826101734.16760.64364.stgit@localhost.localdomain>
References: <20110826101734.16760.64364.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akshay Joshi <me@akshayjoshi.com>

Convert the spaces within the accel_2d.c file to tabs in order to comply
with the coding style of the kernel.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
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

