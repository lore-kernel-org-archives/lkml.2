Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab1GZOWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:22:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56650 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1GZOWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:22:09 -0400
From: Pieterjan Camerlynck <pieterjan.camerlynck@gmail.com>
To: keithp@keithp.com, airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Pieterjan Camerlynck <pieterjan.camerlynck@gmail.com>
Subject: [PATCH] i915: add Dell OptiPlex FX170 to intel_no_lvds
Date: Tue, 26 Jul 2011 16:23:54 +0200
Message-Id: <1311690234-23333-1-git-send-email-pieterjan.camerlynck@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Dell OptiPlex FX170 claims to have LVDS, but doesn't.

Signed-off-by: Pieterjan Camerlynck <pieterjan.camerlynck@gmail.com>
---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index b28f7bd..2e8ddfc 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -690,6 +690,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
 	},
 	{
 		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Dell OptiPlex FX170",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex FX170"),
+		},
+	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
 		.ident = "AOpen Mini PC",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "AOpen"),
-- 
1.7.3.4

