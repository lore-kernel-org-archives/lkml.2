Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1AJRiy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:38:54 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56206 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab1AJRiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 12:38:52 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "drm/kms: remove spaces from connector names (v2)" has been added to staging queue
Date: Mon, 10 Jan 2011 11:38:47 -0600
Message-Id: <1294681127-7113-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: Alex Deucher <alexdeucher@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    drm/kms: remove spaces from connector names (v2)

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From afe2c414358ba8e4c5dd21e4819f7e930d3ddc33 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexdeucher@gmail.com>
Date: Wed, 8 Dec 2010 19:09:42 -0500
Subject: [PATCH] drm/kms: remove spaces from connector names (v2)

commit e76116ca9671e2e5239054a40303b94feab585ad upstream.

Grub doesn't parse spaces in parameters correctly, so
this makes it impossible to force video= parameters
for kms on the grub kernel command line.

v2: shorten the names to make them easier to type.

Reported-by: Sergej Pupykin <ml@sergej.pp.ru>

Cc: Sergej Pupykin <ml@sergej.pp.ru>
Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/drm_crtc.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index d91fb8c..81ba0e6 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -153,12 +153,12 @@ static struct drm_conn_prop_enum_list drm_connector_enum_list[] =
 	{ DRM_MODE_CONNECTOR_SVIDEO, "SVIDEO", 0 },
 	{ DRM_MODE_CONNECTOR_LVDS, "LVDS", 0 },
 	{ DRM_MODE_CONNECTOR_Component, "Component", 0 },
-	{ DRM_MODE_CONNECTOR_9PinDIN, "9-pin DIN", 0 },
-	{ DRM_MODE_CONNECTOR_DisplayPort, "DisplayPort", 0 },
-	{ DRM_MODE_CONNECTOR_HDMIA, "HDMI Type A", 0 },
-	{ DRM_MODE_CONNECTOR_HDMIB, "HDMI Type B", 0 },
+	{ DRM_MODE_CONNECTOR_9PinDIN, "DIN", 0 },
+	{ DRM_MODE_CONNECTOR_DisplayPort, "DP", 0 },
+	{ DRM_MODE_CONNECTOR_HDMIA, "HDMI-A", 0 },
+	{ DRM_MODE_CONNECTOR_HDMIB, "HDMI-B", 0 },
 	{ DRM_MODE_CONNECTOR_TV, "TV", 0 },
-	{ DRM_MODE_CONNECTOR_eDP, "Embedded DisplayPort", 0 },
+	{ DRM_MODE_CONNECTOR_eDP, "eDP", 0 },
 };

 static struct drm_prop_enum_list drm_encoder_enum_list[] =
--
1.7.0.4

