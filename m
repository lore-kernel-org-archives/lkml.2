Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161059Ab2KNK3F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:29:05 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33078 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2KNK3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:29:02 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Clark <rob@ti.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 01/16] staging/omapdrm: Fix spacing coding style in omap_connector.c
Date: Wed, 14 Nov 2012 19:28:54 +0900
Message-Id: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings fixed.
- WARNING: braces {} are not necessary for any arm of this statement
- WARNING: braces {} are not necessary for single statement blocks

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/omapdrm/omap_connector.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_connector.c b/drivers/staging/omapdrm/omap_connector.c
index 38be186..91edb3f 100644
--- a/drivers/staging/omapdrm/omap_connector.c
+++ b/drivers/staging/omapdrm/omap_connector.c
@@ -146,11 +146,10 @@ enum drm_connector_status omap_connector_detect(
 	enum drm_connector_status ret;
 
 	if (dssdrv->detect) {
-		if (dssdrv->detect(dssdev)) {
+		if (dssdrv->detect(dssdev))
 			ret = connector_status_connected;
-		} else {
+		else
 			ret = connector_status_disconnected;
-		}
 	} else {
 		ret = connector_status_unknown;
 	}
@@ -383,9 +382,8 @@ struct drm_connector *omap_connector_init(struct drm_device *dev,
 	return connector;
 
 fail:
-	if (connector) {
+	if (connector)
 		omap_connector_destroy(connector);
-	}
 
 	return NULL;
 }
-- 
1.7.9.5

