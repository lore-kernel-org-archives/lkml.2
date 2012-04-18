Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab2DRNgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:36:33 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35833 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab2DRNgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:36:31 -0400
From: alexdeucher@gmail.com
To: airlied@gmail.com, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        stable@vger.kernel.org
Subject: [PATCH] drm/radeon: fix logic inversion in load detect fix
Date: Wed, 18 Apr 2012 09:36:22 -0400
Message-Id: <1334756182-28963-1-git-send-email-alexdeucher@gmail.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <s5hy5pt89dy.wl%tiwai@suse.de>
References: <s5hy5pt89dy.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
---
 drivers/gpu/drm/radeon/radeon_connectors.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 910ea6d..4bbb6d4 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -977,7 +977,7 @@ radeon_dvi_detect(struct drm_connector *connector, bool force)
 
 			encoder = obj_to_encoder(obj);
 
-			if (encoder->encoder_type != DRM_MODE_ENCODER_DAC ||
+			if (encoder->encoder_type != DRM_MODE_ENCODER_DAC &&
 			    encoder->encoder_type != DRM_MODE_ENCODER_TVDAC)
 				continue;
 
-- 
1.7.7.5

