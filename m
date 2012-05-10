Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab2EJOxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:53:25 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:39390 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756439Ab2EJOxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:53:24 -0400
From: Emil Goode <emilgoode@gmail.com>
To: inki.dae@samsung.com, jy0922.shim@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] drm/exynos: Include missing linux/types.h in header
Date: Thu, 10 May 2012 16:53:20 +0200
Message-Id: <1336661600-2409-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include the linux/types.h file where used types are declared.

Sparse gives the following warning:
/usr/include/drm/exynos_drm.h:92:
	found __[us]{8,16,32,64} type without
	#include <linux/types.h>

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 include/drm/exynos_drm.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/drm/exynos_drm.h b/include/drm/exynos_drm.h
index e478de4..7eb7ae7 100644
--- a/include/drm/exynos_drm.h
+++ b/include/drm/exynos_drm.h
@@ -29,6 +29,8 @@
 #ifndef _EXYNOS_DRM_H_
 #define _EXYNOS_DRM_H_
 
+#include <linux/types.h>
+
 /**
  * User-desired buffer creation information structure.
  *
-- 
1.7.10

