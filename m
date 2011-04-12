Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308Ab1DLERr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 00:17:47 -0400
Received: from hylle01.itea.ntnu.no ([129.241.56.100]:45629 "EHLO
	hylle01.itea.ntnu.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab1DLERq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 00:17:46 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Apr 2011 00:17:46 EDT
Date: Tue, 12 Apr 2011 06:10:18 +0200
From: Ole Henrik Jahren <olehenja@alumni.ntnu.no>
To: dri-devel@lists.freedesktop.org
Cc: chris@chris-wilson.co.uk, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix typo in include/drm/i915_drm.h
Message-ID: <20110412041018.GC17720@siv.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ole Henrik Jahren <olehenja@alumni.ntnu.no>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
---

While adding DRM ioctl decoding support to strace, I noticed something
that looks very much like a typo. If it is intended this way, sorry
about the noise.

 include/drm/i915_drm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/drm/i915_drm.h b/include/drm/i915_drm.h
index 0039f1f..ca7b8af 100644
--- a/include/drm/i915_drm.h
+++ b/include/drm/i915_drm.h
@@ -237,7 +237,7 @@ typedef struct _drm_i915_sarea {
 #define DRM_IOCTL_I915_GEM_GET_APERTURE	DRM_IOR  (DRM_COMMAND_BASE + DRM_I915_GEM_GET_APERTURE, struct drm_i915_gem_get_aperture)
 #define DRM_IOCTL_I915_GET_PIPE_FROM_CRTC_ID DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_GET_PIPE_FROM_CRTC_ID, struct drm_i915_get_pipe_from_crtc_id)
 #define DRM_IOCTL_I915_GEM_MADVISE	DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_GEM_MADVISE, struct drm_i915_gem_madvise)
-#define DRM_IOCTL_I915_OVERLAY_PUT_IMAGE	DRM_IOW(DRM_COMMAND_BASE + DRM_IOCTL_I915_OVERLAY_ATTRS, struct drm_intel_overlay_put_image)
+#define DRM_IOCTL_I915_OVERLAY_PUT_IMAGE	DRM_IOW(DRM_COMMAND_BASE + DRM_I915_OVERLAY_PUT_IMAGE, struct drm_intel_overlay_put_image)
 #define DRM_IOCTL_I915_OVERLAY_ATTRS	DRM_IOWR(DRM_COMMAND_BASE + DRM_I915_OVERLAY_ATTRS, struct drm_intel_overlay_attrs)
 
 /* Allow drivers to submit batchbuffers directly to hardware, relying
-- 
1.7.5.rc1

