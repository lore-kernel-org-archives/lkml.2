Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab1APKql (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 05:46:41 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:59657 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852Ab1APKqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 05:46:40 -0500
From: Felipe Balbi <balbi@ti.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>, David Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 1/2] drm: fixup headers_check
Date: Sun, 16 Jan 2011 12:46:22 +0200
Message-Id: <1295174783-4099-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.3.4.598.g85356
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the following headers_check errors:
/linux-2.6/usr/include/drm/drm_mode.h:85: found
__[us]{8,16,32,64} type without #include <linux/types.h>
/linux-2.6/usr/include/drm/i915_drm.h:120: found
__[us]{8,16,32,64} type without #include <linux/types.h>
/linux-2.6/usr/include/drm/mga_drm.h:260: found
__[us]{8,16,32,64} type without #include <linux/types.h>
/linux-2.6/usr/include/drm/radeon_drm.h:758: found
__[us]{8,16,32,64} type without #include <linux/types.h>
/linux-2.6/usr/include/drm/via_drm.h:117: found
__[us]{8,16,32,64} type without #include <linux/types.h>

Cc: David Airlie <airlied@linux.ie>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 include/drm/drm_mode.h   |    2 ++
 include/drm/i915_drm.h   |    1 +
 include/drm/mga_drm.h    |    1 +
 include/drm/radeon_drm.h |    1 +
 include/drm/via_drm.h    |    1 +
 5 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
index 0fc7397..1678d7b 100644
--- a/include/drm/drm_mode.h
+++ b/include/drm/drm_mode.h
@@ -27,6 +27,8 @@
 #ifndef _DRM_MODE_H
 #define _DRM_MODE_H
 
+#include <linux/types.h>
+
 #define DRM_DISPLAY_INFO_LEN	32
 #define DRM_CONNECTOR_NAME_LEN	32
 #define DRM_DISPLAY_MODE_LEN	32
diff --git a/include/drm/i915_drm.h b/include/drm/i915_drm.h
index 0039f1f..4b211c8 100644
--- a/include/drm/i915_drm.h
+++ b/include/drm/i915_drm.h
@@ -27,6 +27,7 @@
 #ifndef _I915_DRM_H_
 #define _I915_DRM_H_
 
+#include <linux/types.h>
 #include "drm.h"
 
 /* Please note that modifications to all structs defined here are
diff --git a/include/drm/mga_drm.h b/include/drm/mga_drm.h
index c16097f..1107097 100644
--- a/include/drm/mga_drm.h
+++ b/include/drm/mga_drm.h
@@ -35,6 +35,7 @@
 #ifndef __MGA_DRM_H__
 #define __MGA_DRM_H__
 
+#include <linux/types.h>
 #include "drm.h"
 
 /* WARNING: If you change any of these defines, make sure to change the
diff --git a/include/drm/radeon_drm.h b/include/drm/radeon_drm.h
index e95a86b..f9ec151 100644
--- a/include/drm/radeon_drm.h
+++ b/include/drm/radeon_drm.h
@@ -33,6 +33,7 @@
 #ifndef __RADEON_DRM_H__
 #define __RADEON_DRM_H__
 
+#include <linux/types.h>
 #include "drm.h"
 
 /* WARNING: If you change any of these defines, make sure to change the
diff --git a/include/drm/via_drm.h b/include/drm/via_drm.h
index fd11a5b..23880b0 100644
--- a/include/drm/via_drm.h
+++ b/include/drm/via_drm.h
@@ -24,6 +24,7 @@
 #ifndef _VIA_DRM_H_
 #define _VIA_DRM_H_
 
+#include <linux/types.h>
 #include "drm.h"
 
 /* WARNING: These defines must be the same as what the Xserver uses.
-- 
1.7.3.4.598.g85356

