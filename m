Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161107Ab2KNKbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:31:38 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40416 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932782Ab2KNKbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:31:37 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Clark <rob@ti.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 07/16] staging/omapdrm: Fix spacing coding style in omap_encoder.c
Date: Wed, 14 Nov 2012 19:31:27 +0900
Message-Id: <1352889087-14956-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/omapdrm/omap_encoder.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_encoder.c b/drivers/staging/omapdrm/omap_encoder.c
index 31c735d..5341d5e 100644
--- a/drivers/staging/omapdrm/omap_encoder.c
+++ b/drivers/staging/omapdrm/omap_encoder.c
@@ -72,9 +72,9 @@ static void omap_encoder_mode_set(struct drm_encoder *encoder,
 
 	for (i = 0; i < priv->num_connectors; i++) {
 		struct drm_connector *connector = priv->connectors[i];
-		if (connector->encoder == encoder) {
+		if (connector->encoder == encoder)
 			omap_connector_mode_set(connector, mode);
-		}
+
 	}
 }
 
@@ -163,9 +163,8 @@ struct drm_encoder *omap_encoder_init(struct drm_device *dev,
 	return encoder;
 
 fail:
-	if (encoder) {
+	if (encoder)
 		omap_encoder_destroy(encoder);
-	}
 
 	return NULL;
 }
-- 
1.7.9.5

