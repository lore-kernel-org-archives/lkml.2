Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab2KNKbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:31:19 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35519 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2KNKbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:31:17 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Clark <rob@ti.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 06/16] staging/omapdrm: Fix spacing coding style in omap_drv.h
Date: Wed, 14 Nov 2012 19:31:09 +0900
Message-Id: <1352889069-14920-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
References: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings fixed.
- WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/omapdrm/omap_drv.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_drv.h b/drivers/staging/omapdrm/omap_drv.h
index 8f41098..1d4aea5 100644
--- a/drivers/staging/omapdrm/omap_drv.h
+++ b/drivers/staging/omapdrm/omap_drv.h
@@ -218,17 +218,17 @@ static inline int objects_lookup(struct drm_device *dev,
 
 	for (i = 0; i < n; i++) {
 		bos[i] = drm_gem_object_lookup(dev, filp, handles[i]);
-		if (!bos[i]) {
+		if (!bos[i])
 			goto fail;
-		}
+
 	}
 
 	return 0;
 
 fail:
-	while (--i > 0) {
+	while (--i > 0)
 		drm_gem_object_unreference_unlocked(bos[i]);
-	}
+
 	return -ENOENT;
 }
 
-- 
1.7.9.5

