Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130Ab1FWWt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:49:57 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24719 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760094Ab1FWWtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:49:55 -0400
Date: Fri, 24 Jun 2011 00:41:01 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: LKML <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>, devel@driverdev.osuosl.org
Subject: [PATCH 20/37] Remove unneeded version.h includes from
 drivers/staging/gma500/
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1106240040050.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by 'make versioncheck' that some includes of
linux/version.h are not needed in drivers/staging/gma500/.
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/gma500/psb_bl.c  |    1 -
 drivers/staging/gma500/psb_drv.h |    1 -
 drivers/staging/gma500/psb_fb.h  |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/gma500/psb_bl.c b/drivers/staging/gma500/psb_bl.c
index 5dffc71..57423f5 100644
--- a/drivers/staging/gma500/psb_bl.c
+++ b/drivers/staging/gma500/psb_bl.c
@@ -21,7 +21,6 @@
  */
 
 #include <linux/backlight.h>
-#include <linux/version.h>
 #include "psb_drv.h"
 #include "psb_intel_reg.h"
 #include "psb_intel_drv.h"
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index e19a454..8e10c1c 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -20,7 +20,6 @@
 #ifndef _PSB_DRV_H_
 #define _PSB_DRV_H_
 
-#include <linux/version.h>
 #include <linux/kref.h>
 
 #include <drm/drmP.h>
diff --git a/drivers/staging/gma500/psb_fb.h b/drivers/staging/gma500/psb_fb.h
index c8ec0d6..9499d60 100644
--- a/drivers/staging/gma500/psb_fb.h
+++ b/drivers/staging/gma500/psb_fb.h
@@ -22,7 +22,6 @@
 #ifndef _PSB_FB_H_
 #define _PSB_FB_H_
 
-#include <linux/version.h>
 #include <drm/drmP.h>
 #include <drm/drm_fb_helper.h>
 
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

