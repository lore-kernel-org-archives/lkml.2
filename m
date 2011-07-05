Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab1GEOuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:50:44 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59153 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab1GEOum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:50:42 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 31/49] gma500: tidy the framebuffer fixme and oddments
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:40:56 +0100
Message-ID: <20110705144054.23872.45096.stgit@localhost.localdomain>
In-Reply-To: <20110705141038.23872.55303.stgit@localhost.localdomain>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_fb.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 349fff8..17c3cf6 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -591,7 +591,6 @@ int psb_fbdev_init(struct drm_device *dev)
 {
 	struct psb_fbdev *fbdev;
 	struct drm_psb_private *dev_priv = dev->dev_private;
-	int num_crtc;
 
 	fbdev = kzalloc(sizeof(struct psb_fbdev), GFP_KERNEL);
 	if (!fbdev) {
@@ -602,10 +601,7 @@ int psb_fbdev_init(struct drm_device *dev)
 	dev_priv->fbdev = fbdev;
 	fbdev->psb_fb_helper.funcs = &psb_fb_helper_funcs;
 
-	/* FIXME: check Medfield */
-	num_crtc = 2;
-
-	drm_fb_helper_init(dev, &fbdev->psb_fb_helper, num_crtc,
+	drm_fb_helper_init(dev, &fbdev->psb_fb_helper, 2,
 							INTELFB_CONN_LIMIT);
 
 	drm_fb_helper_single_add_all_connectors(&fbdev->psb_fb_helper);

