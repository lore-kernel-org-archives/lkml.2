Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab2KNKkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:40:36 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52732 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab2KNKke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:40:34 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Clark <rob@ti.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 13/16] staging/omapdrm: Fix spacing coding style in omap_gem_helper.c
Date: Wed, 14 Nov 2012 19:40:29 +0900
Message-Id: <1352889629-16086-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/omapdrm/omap_gem_helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/omapdrm/omap_gem_helpers.c b/drivers/staging/omapdrm/omap_gem_helpers.c
index f895363..1b54110 100644
--- a/drivers/staging/omapdrm/omap_gem_helpers.c
+++ b/drivers/staging/omapdrm/omap_gem_helpers.c
@@ -32,7 +32,7 @@
  * @obj: obj in question
  * @gfpmask: gfp mask of requested pages
  */
-struct page ** _drm_gem_get_pages(struct drm_gem_object *obj, gfp_t gfpmask)
+struct page **_drm_gem_get_pages(struct drm_gem_object *obj, gfp_t gfpmask)
 {
 	struct inode *inode;
 	struct address_space *mapping;
-- 
1.7.9.5

