Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1IWRSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:18:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50578 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab1IWRSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:18:21 -0400
From: Matt Turner <mattst88@gmail.com>
To: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Matt Turner <mattst88@gmail.com>
Subject: [PATCH] drm: remove unneeded redefinition of DDC_ADDR
Date: Fri, 23 Sep 2011 13:18:15 -0400
Message-Id: <1316798296-21668-1-git-send-email-mattst88@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's already defined in drm_edid.h.

Signed-off-by: Matt Turner <mattst88@gmail.com>
---
 drivers/gpu/drm/drm_edid.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 7425e5c..9fa8316 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -225,7 +225,6 @@ bool drm_edid_is_valid(struct edid *edid)
 }
 EXPORT_SYMBOL(drm_edid_is_valid);
 
-#define DDC_ADDR 0x50
 #define DDC_SEGMENT_ADDR 0x30
 /**
  * Get EDID information via I2C.
-- 
1.7.3.4

