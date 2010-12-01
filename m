Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab0LAPLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:11:30 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:47571 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab0LAPL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:11:29 -0500
From: Alexander Shishkin <virtuoso@slind.org>
To: linux-kernel@vger.kernel.org
Cc: Alexander Shishkin <virtuoso@slind.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org
Subject: [PATCH 1/4] drm: fix headers to include linux/types.h
Date: Wed,  1 Dec 2010 17:10:42 +0200
Message-Id: <1291216245-18574-2-git-send-email-virtuoso@slind.org>
X-Mailer: git-send-email 1.7.2.1.45.gb66c2
In-Reply-To: <1291216245-18574-1-git-send-email-virtuoso@slind.org>
References: <1291216245-18574-1-git-send-email-virtuoso@slind.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For headers that get exported to userland and make use of u32 style
type names, it is advised to include linux/types.h.

This fixes 5 headers_check warnings.

Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: David Airlie <airlied@linux.ie>
CC: Chris Wilson <chris@chris-wilson.co.uk>
CC: dri-devel@lists.freedesktop.org
CC: linux-kernel@vger.kernel.org
CC: intel-gfx@lists.freedesktop.org
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
index 8c641bed..c07c043 100644
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
index 10f8b53..78d9344 100644
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
1.7.2.1.45.gb66c2

