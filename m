Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab1FFAcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 20:32:24 -0400
Received: from mta31.charter.net ([216.33.127.82]:48413 "EHLO
	mta31.charter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab1FFAcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 20:32:21 -0400
X-Authority-Analysis: v=1.1 cv=vT9vkN3vVXssH3Ov7r/wQUs/sfIFjNPEFFf4aeKIi4A=
 c=1 sm=1 a=b_ZAEtL4iiMA:10 a=lDGNyK2vIvEA:10 a=xzrYXqw+0zwiO4gHSXHcAg==:17
 a=Zh0XGXoQGCX4B2KpgjUA:9 a=xzrYXqw+0zwiO4gHSXHcAg==:117
From: Greg Dietsche <Gregory.Dietsche@cuw.edu>
To: airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>
Subject: [PATCH] savage: remove unecessary if statement
Date: Sun,  5 Jun 2011 19:32:12 -0500
Message-Id: <1307320332-31429-1-git-send-email-Gregory.Dietsche@cuw.edu>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the code always returns ret regardless, so if(ret) check is unecessary.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
---
 drivers/gpu/drm/savage/savage_bci.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/savage/savage_bci.c b/drivers/gpu/drm/savage/savage_bci.c
index bf5f83e..cb1ee4e 100644
--- a/drivers/gpu/drm/savage/savage_bci.c
+++ b/drivers/gpu/drm/savage/savage_bci.c
@@ -647,9 +647,6 @@ int savage_driver_firstopen(struct drm_device *dev)
 	ret = drm_addmap(dev, aperture_base, SAVAGE_APERTURE_SIZE,
 			 _DRM_FRAME_BUFFER, _DRM_WRITE_COMBINING,
 			 &dev_priv->aperture);
-	if (ret)
-		return ret;
-
 	return ret;
 }
 
-- 
1.7.2.5

