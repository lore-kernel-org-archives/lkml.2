Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab2BZWom (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 17:44:42 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21991 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2BZWok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 17:44:40 -0500
Date: Sun, 26 Feb 2012 23:42:36 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Alan Cox <alan@linux.intel.com>
cc: trivial@kernel.org, David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@suse.de>, Dave Airlie <airlied@redhat.com>,
        Octavian Purdila <octavian.purdila@intel.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Benjamin Defnet <benjamin.r.defnet@intel.com>,
        Rajesh Poornachandran <rajesh.poornachandran@intel.com>
Subject: [PATCH][trivial] gma500: remove redundant ';' and redundant 'else'
 from drivers/gpu/drm/gma500/power.c
Message-ID: <alpine.LNX.2.00.1202262340390.6089@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/gpu/drm/gma500/power.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/gma500/power.c b/drivers/gpu/drm/gma500/power.c
index 9402569..6486f61 100644
--- a/drivers/gpu/drm/gma500/power.c
+++ b/drivers/gpu/drm/gma500/power.c
@@ -302,7 +302,7 @@ int psb_runtime_suspend(struct device *dev)
 
 int psb_runtime_resume(struct device *dev)
 {
-	return gma_power_resume(dev);;
+	return gma_power_resume(dev);
 }
 
 int psb_runtime_idle(struct device *dev)
@@ -311,6 +311,5 @@ int psb_runtime_idle(struct device *dev)
 	struct drm_psb_private *dev_priv = drmdev->dev_private;
 	if (dev_priv->display_count)
 		return 0;
-	else
-		return 1;
+	return 1;
 }
-- 
1.7.9.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

