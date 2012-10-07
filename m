Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2JGN0l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 09:26:41 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:48274 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2JGN0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 09:26:35 -0400
MIME-Version: 1.0
Date: Sun, 7 Oct 2012 21:26:35 +0800
Message-ID: <CAPgLHd-jRBwCsmN-sVJAcnedx_t59TurCV5aepVteD-mvUvphQ@mail.gmail.com>
Subject: [PATCH] drm/i915: remove duplicated include from intel_modes.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: daniel.vetter@ffwll.ch, airlied@linux.ie
Cc: yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/i915/intel_modes.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_modes.c b/drivers/gpu/drm/i915/intel_modes.c
index cabd84b..8c97b7a 100644
--- a/drivers/gpu/drm/i915/intel_modes.c
+++ b/drivers/gpu/drm/i915/intel_modes.c
@@ -28,7 +28,6 @@
 #include <linux/fb.h>
 #include <drm/drm_edid.h>
 #include <drm/drmP.h>
-#include <drm/drm_edid.h>
 #include "intel_drv.h"
 #include "i915_drv.h"
 

