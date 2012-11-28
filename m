Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab2K1Tpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:45:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58056 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab2K1Tpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:45:33 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Dave Airlie <airlied@redhat.com>
Cc: Joe Perches <joe@perches.com>, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] drm: tegra: Add maintainers entry
Date: Wed, 28 Nov 2012 20:45:28 +0100
Message-Id: <1354131928-25497-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0.1
X-Provags-ID: V02:K0:dYRqnAl/faiWY3ChCLr8L1WKFcgWHLCtfCnFznSVC3M
 xAyZmbDM4iTjl+7zq/gUhO8fSdvOViEzwJgkbxPL694Cf+eXzP
 IU9sCd/XgLuxZHR1SHajEg+hD9uAi4o3Muvb7/XCIeLjMsMrTk
 1IhZFjr2c/ns7G2KMAiiJPFqOD4qmx9Z0lz/pDWT5BWwnN4LTL
 iwzKesCKF+Q8f29JK701o2SH513YIYlL7rUWbC0KAvR1MZiliz
 nW+OlEuMxCcOSNjG8LwZlJW/4maaeHKdo2KGfsGwwBGeKtJGly
 WU1CxjQIp7seyl7aCvGeLg1Wkk9zx+WFliAarj+YpWXWWhprLx
 D38P3u7Kzl9mWqglfmpgokQdn9hyQ7aR5CTl+BhMeIK7TOuIjX
 5IsC21LnLLXcYNXqlKOpPVGDzoRpOLH3lOH216EnPS38nAJ8L0
 Roctw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add myself as the maintainer of the NVIDIA Tegra DRM driver.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Stephen Warren <swarren@nvidia.com>
---
Changes in v3:
- add linux-tegra mailing list

Changes in v2:
- insert entry in alphabetical order
- fix reference to driver directory
- fix reference to git tree

 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0cfc0f1..84062c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2549,6 +2549,15 @@ S:	Supported
 F:	drivers/gpu/drm/exynos
 F:	include/drm/exynos*
 
+DRM DRIVERS FOR NVIDIA TEGRA
+M:	Thierry Reding <thierry.reding@avionic-design.de>
+L:	dri-devel@lists.freedesktop.org
+L:	linux-tegra@vger.kernel.org
+T:	git git://gitorious.org/thierryreding/linux.git
+S:	Maintained
+F:	drivers/gpu/drm/tegra/
+F:	Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
+
 DSCC4 DRIVER
 M:	Francois Romieu <romieu@fr.zoreil.com>
 L:	netdev@vger.kernel.org
-- 
1.8.0.1

