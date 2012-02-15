Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2BORyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:54:15 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:41545 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811Ab2BORyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:54:14 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Keith Packard <keithp@keithp.com>
Cc: Danny Kukawka <dkukawka@suse.de>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] Revert "drivers/gpu/drm/i915/intel_overlay.c needs seq_file.h"
Date: Wed, 15 Feb 2012 18:53:55 +0100
Message-Id: <1329328435-4569-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329328454;41598635;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit e167976ee7f5fe4b80f7e8f55e087f6c67cf9562,
Since this was already fixed in commit
3bd3c9329973a93fa3ef5e9840f2fd6fa2889e3f some days before this
commit cause seq_file.h to be included twice.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/gpu/drm/i915/intel_overlay.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_overlay.c b/drivers/gpu/drm/i915/intel_overlay.c
index cdf17d4..134c42a 100644
--- a/drivers/gpu/drm/i915/intel_overlay.c
+++ b/drivers/gpu/drm/i915/intel_overlay.c
@@ -25,8 +25,6 @@
  *
  * Derived from Xorg ddx, xf86-video-intel, src/i830_video.c
  */
-
-#include <linux/seq_file.h>
 #include "drmP.h"
 #include "drm.h"
 #include "i915_drm.h"
-- 
1.7.8.3

