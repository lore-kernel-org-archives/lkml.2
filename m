Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161109Ab2KNKcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:32:36 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57687 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab2KNKcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:32:35 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Clark <rob@ti.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 08/16] staging/omapdrm: Fix spacing coding style in omap_fb.c
Date: Wed, 14 Nov 2012 19:32:17 +0900
Message-Id: <1352889137-15079-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/omapdrm/omap_fb.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_fb.c b/drivers/staging/omapdrm/omap_fb.c
index 75d2ff1..09028e9 100644
--- a/drivers/staging/omapdrm/omap_fb.c
+++ b/drivers/staging/omapdrm/omap_fb.c
@@ -307,17 +307,16 @@ struct drm_connector *omap_framebuffer_get_next_connector(
 	struct list_head *connector_list = &dev->mode_config.connector_list;
 	struct drm_connector *connector = from;
 
-	if (!from) {
+	if (!from)
 		return list_first_entry(connector_list, typeof(*from), head);
-	}
 
 	list_for_each_entry_from(connector, connector_list, head) {
 		if (connector != from) {
 			struct drm_encoder *encoder = connector->encoder;
 			struct drm_crtc *crtc = encoder ? encoder->crtc : NULL;
-			if (crtc && crtc->fb == fb) {
+			if (crtc && crtc->fb == fb)
 				return connector;
-			}
+
 		}
 	}
 
@@ -466,8 +465,8 @@ struct drm_framebuffer *omap_framebuffer_init(struct drm_device *dev,
 	return fb;
 
 fail:
-	if (fb) {
+	if (fb)
 		omap_framebuffer_destroy(fb);
-	}
+
 	return ERR_PTR(ret);
 }
-- 
1.7.9.5

