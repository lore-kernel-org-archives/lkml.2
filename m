Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161093Ab2KNKab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:30:31 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52764 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab2KNKa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:30:29 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Clark <rob@ti.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 03/16] staging/omapdrm: Fix spacing coding style in omap_crtc.c
Date: Wed, 14 Nov 2012 19:30:23 +0900
Message-Id: <1352889023-14817-1-git-send-email-yamanetoshi@gmail.com>
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
 drivers/staging/omapdrm/omap_crtc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_crtc.c b/drivers/staging/omapdrm/omap_crtc.c
index cbda7e0..d87bd84 100644
--- a/drivers/staging/omapdrm/omap_crtc.c
+++ b/drivers/staging/omapdrm/omap_crtc.c
@@ -263,8 +263,8 @@ struct drm_crtc *omap_crtc_init(struct drm_device *dev,
 	return crtc;
 
 fail:
-	if (crtc) {
+	if (crtc)
 		omap_crtc_destroy(crtc);
-	}
+
 	return NULL;
 }
-- 
1.7.9.5

