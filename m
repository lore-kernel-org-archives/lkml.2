Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab2KNKkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:40:21 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:64091 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab2KNKkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:40:20 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Clark <rob@ti.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 12/16] staging/omapdrm: Fix spacing coding style in omap_gem_dmabuf.c
Date: Wed, 14 Nov 2012 19:40:14 +0900
Message-Id: <1352889614-16052-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/omapdrm/omap_gem_dmabuf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_gem_dmabuf.c b/drivers/staging/omapdrm/omap_gem_dmabuf.c
index c6f3ef6..9a30206 100644
--- a/drivers/staging/omapdrm/omap_gem_dmabuf.c
+++ b/drivers/staging/omapdrm/omap_gem_dmabuf.c
@@ -191,13 +191,13 @@ struct dma_buf_ops omap_dmabuf_ops = {
 		.mmap = omap_gem_dmabuf_mmap,
 };
 
-struct dma_buf * omap_gem_prime_export(struct drm_device *dev,
+struct dma_buf *omap_gem_prime_export(struct drm_device *dev,
 		struct drm_gem_object *obj, int flags)
 {
 	return dma_buf_export(obj, &omap_dmabuf_ops, obj->size, 0600);
 }
 
-struct drm_gem_object * omap_gem_prime_import(struct drm_device *dev,
+struct drm_gem_object *omap_gem_prime_import(struct drm_device *dev,
 		struct dma_buf *buffer)
 {
 	struct drm_gem_object *obj;
-- 
1.7.9.5

