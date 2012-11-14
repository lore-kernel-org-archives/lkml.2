Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161122Ab2KNKdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:33:05 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:55463 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab2KNKdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:33:03 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Clark <rob@ti.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 09/16] staging/omapdrm: Fix spacing coding style in omap_gem.c
Date: Wed, 14 Nov 2012 19:32:56 +0900
Message-Id: <1352889176-15134-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
References: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following error fixed.
- ERROR: "foo ** bar" should be "foo **bar"

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/omapdrm/omap_gem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/omapdrm/omap_gem.c b/drivers/staging/omapdrm/omap_gem.c
index 8a9b1ce..94c04a5 100644
--- a/drivers/staging/omapdrm/omap_gem.c
+++ b/drivers/staging/omapdrm/omap_gem.c
@@ -25,7 +25,7 @@
 #include "omap_dmm_tiler.h"
 
 /* remove these once drm core helpers are merged */
-struct page ** _drm_gem_get_pages(struct drm_gem_object *obj, gfp_t gfpmask);
+struct page **_drm_gem_get_pages(struct drm_gem_object *obj, gfp_t gfpmask);
 void _drm_gem_put_pages(struct drm_gem_object *obj, struct page **pages,
 		bool dirty, bool accessed);
 int _drm_gem_create_mmap_offset_size(struct drm_gem_object *obj, size_t size);
-- 
1.7.9.5

