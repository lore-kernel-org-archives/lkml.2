Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab2BENvQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 08:51:16 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:44911
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754773Ab2BENvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 08:51:15 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] drm: Fix typo in vmwgfx_drv.c
Date: Sun,  5 Feb 2012 22:50:36 +0900
Message-Id: <1328449836-1752-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "unsuported" to "unsupported" in
drivers/gpu/drm/vmwgfx/vmwgfx_drv.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index f390f5f..2d6f573 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -430,7 +430,7 @@ static int vmw_driver_load(struct drm_device *dev, unsigned long chipset)
 	svga_id = vmw_read(dev_priv, SVGA_REG_ID);
 	if (svga_id != SVGA_ID_2) {
 		ret = -ENOSYS;
-		DRM_ERROR("Unsuported SVGA ID 0x%x\n", svga_id);
+		DRM_ERROR("Unsupported SVGA ID 0x%x\n", svga_id);
 		mutex_unlock(&dev_priv->hw_mutex);
 		goto out_err0;
 	}
-- 
1.7.6.5

