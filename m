Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab2JTKc6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 06:32:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64099 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab2JTKc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 06:32:57 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: David Airlie <airlied@linux.ie>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] drm: fb: cma: Fix typo in debug message
Date: Sat, 20 Oct 2012 12:32:46 +0200
Message-Id: <1350729172-12506-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.7.12.4
X-Provags-ID: V02:K0:XYlM700aHycn2imsKhi7YQfMTU4DoNF63xmUqiH4mdP
 v9bHwwY4lj1qTGTW+rsubSEvcek3Fud8Ta3/UyzoDTmyz8uneq
 MaQXBGp0XZ3RrfPRVNER5rAVUtS43gwkqHEWSVV30MAVqAXl0I
 fN04X8S76bPQvqxbIFQs5KTyLVe4+d9xxsEykgWV6/HJ1nTczB
 NakTV2mjwPjBquBdBez3lcyAl/iG/kPNsDiXJfF+vJFra5KhZ1
 Ob6Puv/NLPssRrkWhaLuviid6Q1PdXPFcsZvb1497lsJ2snVjf
 ZNiwYwZz5g8oIAbbJKI0L+iy0ewzIjHqn2MEb9aIkU9LSFRtc3
 /ka5avIky9sm56b8aXLcCs4O9YnTIQc0/evAy37tmUb8bv9Kmc
 TySun469fpDIRxekexdidjVLmgVDWCCgqTt2QwFZwEjpIgloD1
 L55nn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The debug message showing the resolution of a framebuffer to be
allocated is missing a closing parenthesis.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/gpu/drm/drm_fb_cma_helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_fb_cma_helper.c b/drivers/gpu/drm/drm_fb_cma_helper.c
index 09e11a5..d6c80a3 100644
--- a/drivers/gpu/drm/drm_fb_cma_helper.c
+++ b/drivers/gpu/drm/drm_fb_cma_helper.c
@@ -206,7 +206,7 @@ static int drm_fbdev_cma_create(struct drm_fb_helper *helper,
 	size_t size;
 	int ret;
 
-	DRM_DEBUG_KMS("surface width(%d), height(%d) and bpp(%d\n",
+	DRM_DEBUG_KMS("surface width(%d), height(%d) and bpp(%d)\n",
 			sizes->surface_width, sizes->surface_height,
 			sizes->surface_bpp);
 
-- 
1.7.12.4

