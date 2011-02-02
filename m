Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1BBBL7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:11:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:34886 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab1BBAnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960298"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: alexdeucher@gmail.com, ml@sergej.pp.ru, airlied@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [8/139] drm/kms: remove spaces from connector names (v2)
Message-Id: <20110202004322.1BEBA3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Alex Deucher <alexdeucher@gmail.com>

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/drm_crtc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6.35.y/drivers/gpu/drm/drm_crtc.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpu/drm/drm_crtc.c
+++ linux-2.6.35.y/drivers/gpu/drm/drm_crtc.c
@@ -155,12 +155,12 @@ static struct drm_conn_prop_enum_list dr
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
