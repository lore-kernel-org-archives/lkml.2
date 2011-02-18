Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab1BRJFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:05:16 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56486 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819Ab1BRJFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:05:06 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: Knut Petersen <knut_petersen@t-online.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 6/7] drm/i915/lvds: Add AOpen i915GMm-HFS to the list of false-positive LVDS" has been added to staging queue
Date: Fri, 18 Feb 2011 10:05:04 +0100
Message-Id: <1298019904-2472-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: Knut Petersen <knut_petersen@t-online.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 6/7] drm/i915/lvds: Add AOpen i915GMm-HFS to the list of false-positive LVDS

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 15e528ac2343c1851cc17043a6cbf00c0c054425 Mon Sep 17 00:00:00 2001
From: Knut Petersen <knut_petersen@t-online.de>
Date: Fri, 14 Jan 2011 15:38:10 +0000
Subject: [PATCH 6/7] drm/i915/lvds: Add AOpen i915GMm-HFS to the list of false-positive LVDS

commit 22ab70d3262ddb6e69b3c246a34e2967ba5eb1e8 upstream.

Signed-off-by: Knut Petersen <knut_petersen@t-online.de>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 66df0c3..49c724e 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -894,6 +894,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
 	},
 	{
 		.callback = intel_no_lvds_dmi_callback,
+		.ident = "AOpen i915GMm-HFS",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AOpen"),
+			DMI_MATCH(DMI_BOARD_NAME, "i915GMm-HFS"),
+		},
+	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
 		.ident = "Aopen i945GTt-VFA",
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "AO00001JW"),
--
1.7.0.4

