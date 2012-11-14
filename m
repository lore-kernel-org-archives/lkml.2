Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932891Ab2KNKku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:40:50 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38023 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932836Ab2KNKkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:40:49 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Clark <rob@ti.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 14/16] staging/omapdrm: Fix spacing coding style in omap_gem_helper.c
Date: Wed, 14 Nov 2012 19:40:43 +0900
Message-Id: <1352889643-16120-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
References: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warning fixed.
- WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/omapdrm/omap_gem_helpers.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_gem_helpers.c b/drivers/staging/omapdrm/omap_gem_helpers.c
index 1b54110..ffb8cce 100644
--- a/drivers/staging/omapdrm/omap_gem_helpers.c
+++ b/drivers/staging/omapdrm/omap_gem_helpers.c
@@ -80,9 +80,9 @@ struct page **_drm_gem_get_pages(struct drm_gem_object *obj, gfp_t gfpmask)
 	return pages;
 
 fail:
-	while (i--) {
+	while (i--)
 		page_cache_release(pages[i]);
-	}
+
 	drm_free_large(pages);
 	return ERR_CAST(p);
 }
-- 
1.7.9.5

