Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161127Ab2KNKbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:31:00 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:34205 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2KNKa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:30:58 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Clark <rob@ti.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 05/16] staging/omapdrm: Fix spacing coding style in omap_drv.h
Date: Wed, 14 Nov 2012 19:30:52 +0900
Message-Id: <1352889053-14886-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
References: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors fixed.
- ERROR: "foo * bar" should be "foo *bar"

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/omapdrm/omap_drv.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_drv.h b/drivers/staging/omapdrm/omap_drv.h
index 8f7c447..8f41098 100644
--- a/drivers/staging/omapdrm/omap_drv.h
+++ b/drivers/staging/omapdrm/omap_drv.h
@@ -191,9 +191,9 @@ size_t omap_gem_mmap_size(struct drm_gem_object *obj);
 int omap_gem_tiled_size(struct drm_gem_object *obj, uint16_t *w, uint16_t *h);
 int omap_gem_tiled_stride(struct drm_gem_object *obj, uint32_t orient);
 
-struct dma_buf * omap_gem_prime_export(struct drm_device *dev,
+struct dma_buf *omap_gem_prime_export(struct drm_device *dev,
 		struct drm_gem_object *obj, int flags);
-struct drm_gem_object * omap_gem_prime_import(struct drm_device *dev,
+struct drm_gem_object *omap_gem_prime_import(struct drm_device *dev,
 		struct dma_buf *buffer);
 
 static inline int align_pitch(int pitch, int width, int bpp)
-- 
1.7.9.5

