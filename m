Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab2K1LK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 06:10:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60727 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab2K1LK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 06:10:26 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm: tegra: Add maintainers entry
Date: Wed, 28 Nov 2012 12:10:17 +0100
Message-Id: <1354101017-31844-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0.1
X-Provags-ID: V02:K0:8a8oBWzLxVrWLwp1oVsMAHFRje97CRTXnk3EP64goYh
 e1ynzMZSF90enrSoh+giTmuS9AlYOGQxkJFv+tMksgDuxclWl9
 tfHdEff0UAWb+aa89bMEKv2SwPZG/vLF1Y6M+a3NyAmd2RT00P
 uUvJBnoK6bLt8hLwrs052Gc0ipZkORxKA5Tx1jB5ocAAJijqCO
 zXWVJ+EnLm9V2BsCtwggkRT8hzvDBAuI2W7gyyGRF0lXvs9dGs
 BglXjN8/ah4u8dAKnWZIKxKZ/Qi5zB60Ym2TbHn912bvmD8Z6K
 Zutg67EZleZG07OiIFlSe7F0H0I5OfyUdQEwQDbYTnjJpmswrh
 +9dPyAeHkYi0Ae6qMaGyQh0eLdA0DkbHKd9ebXHgRQ9Bste0Ag
 XUa/V/UJZkAG9Lm9DHogl0JTltjvJKQZOFoDPmG0yAVBLq4/Wp
 LXI8B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add myself as the maintainer of the NVIDIA Tegra DRM driver.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f503405..27c89b3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2504,6 +2504,14 @@ S:	Supported
 F:	drivers/gpu/drm/exynos
 F:	include/drm/exynos*
 
+NVIDIA TEGRA DRM DRIVER
+M:	Thierry Reding <thierry.reding@avionic-design.de>
+L:	dri-devel@lists.freedesktop.org
+T:	git://gitorious.org/thierryreding/linux.git
+S:	Maintained
+F:	drivers/gpu/drm/tegra
+F:	Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
+
 DSCC4 DRIVER
 M:	Francois Romieu <romieu@fr.zoreil.com>
 L:	netdev@vger.kernel.org
-- 
1.8.0.1

