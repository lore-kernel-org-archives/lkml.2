Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab1GGO10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:27:26 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56719 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1GGO1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:27:23 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] gma500: strip unneeded version headers
To: jj@chaosbits.net, greg@kroah.com, linux-kernel@vger.kernel.org
Date: Thu, 07 Jul 2011 15:17:46 +0100
Message-ID: <20110707141745.2749.99838.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Remove unneeded version.h includes from drivers/staging/gma500/

It was pointed out by 'make versioncheck' that some includes of
linux/version.h are not needed in drivers/staging/gma500/.
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
[updated for all th file cleanup and movement]
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/framebuffer.h      |    1 -
 drivers/staging/gma500/mdfld_dsi_dbi.h    |    1 -
 drivers/staging/gma500/mdfld_dsi_output.h |    1 -
 drivers/staging/gma500/psb_drv.h          |    1 -
 4 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/gma500/framebuffer.h b/drivers/staging/gma500/framebuffer.h
index 9416a21..d1b2289 100644
--- a/drivers/staging/gma500/framebuffer.h
+++ b/drivers/staging/gma500/framebuffer.h
@@ -22,7 +22,6 @@
 #ifndef _FRAMEBUFFER_H_
 #define _FRAMEBUFFER_H_
 
-#include <linux/version.h>
 #include <drm/drmP.h>
 #include <drm/drm_fb_helper.h>
 
diff --git a/drivers/staging/gma500/mdfld_dsi_dbi.h b/drivers/staging/gma500/mdfld_dsi_dbi.h
index a76813e..a51e2f8 100644
--- a/drivers/staging/gma500/mdfld_dsi_dbi.h
+++ b/drivers/staging/gma500/mdfld_dsi_dbi.h
@@ -29,7 +29,6 @@
 #define __MDFLD_DSI_DBI_H__
 
 #include <linux/backlight.h>
-#include <linux/version.h>
 #include <drm/drmP.h>
 #include <drm/drm.h>
 #include <drm/drm_crtc.h>
diff --git a/drivers/staging/gma500/mdfld_dsi_output.h b/drivers/staging/gma500/mdfld_dsi_output.h
index 0bf00ea..4300f10 100644
--- a/drivers/staging/gma500/mdfld_dsi_output.h
+++ b/drivers/staging/gma500/mdfld_dsi_output.h
@@ -29,7 +29,6 @@
 #define __MDFLD_DSI_OUTPUT_H__
 
 #include <linux/backlight.h>
-#include <linux/version.h>
 #include <drm/drmP.h>
 #include <drm/drm.h>
 #include <drm/drm_crtc.h>
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 9e4f361..c19045f 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -20,7 +20,6 @@
 #ifndef _PSB_DRV_H_
 #define _PSB_DRV_H_
 
-#include <linux/version.h>
 #include <linux/kref.h>
 
 #include <drm/drmP.h>

