Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab2KNKeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:34:21 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34844 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab2KNKeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:34:20 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Clark <rob@ti.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 11/16] staging/omapdrm: Fix spacing coding style in omap_gem.c
Date: Wed, 14 Nov 2012 19:33:43 +0900
Message-Id: <1352889224-15202-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
References: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors fixed.
- ERROR: space prohibited after that '!' (ctx:BxW)

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/omapdrm/omap_gem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_gem.c b/drivers/staging/omapdrm/omap_gem.c
index e615871..c38992b 100644
--- a/drivers/staging/omapdrm/omap_gem.c
+++ b/drivers/staging/omapdrm/omap_gem.c
@@ -952,7 +952,7 @@ int omap_gem_put_pages(struct drm_gem_object *obj)
 void *omap_gem_vaddr(struct drm_gem_object *obj)
 {
 	struct omap_gem_object *omap_obj = to_omap_bo(obj);
-	WARN_ON(! mutex_is_locked(&obj->dev->struct_mutex));
+	WARN_ON(!mutex_is_locked(&obj->dev->struct_mutex));
 	if (!omap_obj->vaddr) {
 		struct page **pages;
 		int ret = get_pages(obj, &pages);
@@ -971,7 +971,7 @@ void omap_gem_describe(struct drm_gem_object *obj, struct seq_file *m)
 	struct omap_gem_object *omap_obj = to_omap_bo(obj);
 	uint64_t off = 0;
 
-	WARN_ON(! mutex_is_locked(&dev->struct_mutex));
+	WARN_ON(!mutex_is_locked(&dev->struct_mutex));
 
 	if (obj->map_list.map)
 		off = (uint64_t)obj->map_list.hash.key;
-- 
1.7.9.5

