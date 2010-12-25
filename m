Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab0LYO3P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 09:29:15 -0500
Received: from unix.wroclaw.pl ([94.23.28.62]:43064 "EHLO unix.wroclaw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab0LYO3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 09:29:14 -0500
From: Mariusz Kozlowski <mk@lab.zgora.pl>
To: Chris Wilson <chris@chris-wilson.co.uk>, David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Mariusz Kozlowski <mk@lab.zgora.pl>
Subject: [PATCH] i915: use plane enumerators in intel_pipe_set_base()
Date: Sat, 25 Dec 2010 15:29:03 +0100
Message-Id: <1293287343-7751-1-git-send-email-mk@lab.zgora.pl>
X-Mailer: git-send-email 1.7.0.4
X-SA-Report: SpamAssassin 3.2.5 (2008-06-10) on unix.wroclaw.pl
	Spam=No score=-1.4 bayes=0.5 autolearn=disabled
	Spam Tests:
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'plane' is enumerated type so lets use proper enumerators.

Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
---
 drivers/gpu/drm/i915/intel_display.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index d9b7092..4515d2c 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1588,8 +1588,8 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 	}
 
 	switch (intel_crtc->plane) {
-	case 0:
-	case 1:
+	case PLANE_A:
+	case PLANE_B:
 		break;
 	default:
 		return -EINVAL;
-- 
1.7.0.4

