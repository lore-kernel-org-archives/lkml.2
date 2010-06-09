Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab0FIKjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:39:32 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:49545 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757518Ab0FIKja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:39:30 -0400
Date: Wed, 9 Jun 2010 12:35:53 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/sis: fixed brace coding style issues
Message-ID: <20100609123553.0f2ea0b0@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed brace coding style issues.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/gpu/drm/sis/sis_drv.c |    3 +--
 drivers/gpu/drm/sis/sis_mm.c  |    6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/sis/sis_drv.c b/drivers/gpu/drm/sis/sis_drv.c
index 4fd1f06..776bf9e 100644
--- a/drivers/gpu/drm/sis/sis_drv.c
+++ b/drivers/gpu/drm/sis/sis_drv.c
@@ -47,9 +47,8 @@ static int sis_driver_load(struct drm_device *dev, unsigned long chipset)
 	dev->dev_private = (void *)dev_priv;
 	dev_priv->chipset = chipset;
 	ret = drm_sman_init(&dev_priv->sman, 2, 12, 8);
-	if (ret) {
+	if (ret)
 		kfree(dev_priv);
-	}
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/sis/sis_mm.c b/drivers/gpu/drm/sis/sis_mm.c
index af22111..e4a0f08 100644
--- a/drivers/gpu/drm/sis/sis_mm.c
+++ b/drivers/gpu/drm/sis/sis_mm.c
@@ -225,9 +225,8 @@ static drm_local_map_t *sis_reg_init(struct drm_device *dev)
 		map = entry->map;
 		if (!map)
 			continue;
-		if (map->type == _DRM_REGISTERS) {
+		if (map->type == _DRM_REGISTERS)
 			return map;
-		}
 	}
 	return NULL;
 }
@@ -312,9 +311,8 @@ void sis_reclaim_buffers_locked(struct drm_device * dev,
 		return;
 	}
 
-	if (dev->driver->dma_quiescent) {
+	if (dev->driver->dma_quiescent)
 		dev->driver->dma_quiescent(dev);
-	}
 
 	drm_sman_owner_cleanup(&dev_priv->sman, (unsigned long)file_priv);
 	mutex_unlock(&dev->struct_mutex);
-- 
1.6.4.4

