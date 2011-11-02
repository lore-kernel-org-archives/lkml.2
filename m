Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab1KBGVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 02:21:06 -0400
Received: from home.keithp.com ([63.227.221.253]:33665 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541Ab1KBGU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 02:20:59 -0400
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH 7/7] drm/i915: Remove trailing white space
Date: Tue,  1 Nov 2011 23:20:30 -0700
Message-Id: <1320214830-12696-8-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320214830-12696-1-git-send-email-keithp@keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found a couple of bare tabs in intel_dp.c

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index bf20a35..7ebeb01 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1054,7 +1054,7 @@ static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp, bool sync)
 
 	DRM_DEBUG_KMS("Turn eDP VDD off %d\n", intel_dp->want_panel_vdd);
 	WARN(!intel_dp->want_panel_vdd, "eDP VDD not forced on");
-	
+
 	intel_dp->want_panel_vdd = false;
 
 	if (sync) {
@@ -2402,7 +2402,7 @@ intel_dp_init(struct drm_device *dev, int output_reg)
 
 		cur.t8 = (pp_on & PANEL_LIGHT_ON_DELAY_MASK) >>
 			PANEL_LIGHT_ON_DELAY_SHIFT;
-		
+
 		cur.t9 = (pp_off & PANEL_LIGHT_OFF_DELAY_MASK) >>
 			PANEL_LIGHT_OFF_DELAY_SHIFT;
 
-- 
1.7.7

