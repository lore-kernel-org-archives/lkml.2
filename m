Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab1AEXGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:06:18 -0500
Received: from kroah.org ([198.145.64.141]:50694 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab1AEXGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:06:16 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 15:03:24 2011
Message-Id: <20110105230323.978508482@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 15:00:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sergej Pupykin <ml@sergej.pp.ru>, Alex Deucher <alexdeucher@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [06/49] drm/kms: remove spaces from connector names (v2)
In-Reply-To: <20110105230438.GA26241@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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

---
 drivers/gpu/drm/drm_crtc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -144,10 +144,10 @@ static struct drm_conn_prop_enum_list dr
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
 };
 


