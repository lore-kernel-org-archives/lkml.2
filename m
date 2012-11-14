Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161115Ab2KNKlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:41:20 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52732 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2KNKlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:41:18 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Rob Clark <rob@ti.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 16/16] staging/omapdrm: Fix spacing coding style in omap_plane.c
Date: Wed, 14 Nov 2012 19:41:13 +0900
Message-Id: <1352889673-16188-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
References: <1352888935-14742-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following errors and warnings fixed.
- ERROR: code indent should use tabs where possible
- WARNING: please, no spaces at the start of a line

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/omapdrm/omap_plane.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/omapdrm/omap_plane.c b/drivers/staging/omapdrm/omap_plane.c
index 25d78ca..2a8e5ba 100644
--- a/drivers/staging/omapdrm/omap_plane.c
+++ b/drivers/staging/omapdrm/omap_plane.c
@@ -436,8 +436,8 @@ void omap_plane_install_properties(struct drm_plane *plane,
 		drm_object_attach_property(obj, prop, 0);
 	}
 
-        prop = priv->zorder_prop;
-        if (!prop) {
+	prop = priv->zorder_prop;
+	if (!prop) {
 		prop = drm_property_create_range(dev, 0, "zorder", 0, 3);
 		if (prop == NULL)
 			return;
-- 
1.7.9.5

