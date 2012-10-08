Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab2JHOoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 10:44:10 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59222 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab2JHOoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 10:44:07 -0400
MIME-Version: 1.0
Date: Mon, 8 Oct 2012 22:44:06 +0800
Message-ID: <CAPgLHd-=1KXjxCpNq7yhvKjQkRPuHucA-1q_1ijTUhmEOKR=Xg@mail.gmail.com>
Subject: [PATCH v2] gma500: medfield: drop bogus NULL check in mdfld_dsi_output_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: airlied@linux.ie, alan@lxorguk.ukuu.org.uk
Cc: yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Drop the NULL test for dev since it never be NULL.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/gma500/mdfld_dsi_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/gma500/mdfld_dsi_output.c b/drivers/gpu/drm/gma500/mdfld_dsi_output.c
index 32dba2a..b6f49d9 100644
--- a/drivers/gpu/drm/gma500/mdfld_dsi_output.c
+++ b/drivers/gpu/drm/gma500/mdfld_dsi_output.c
@@ -506,7 +506,7 @@ void mdfld_dsi_output_init(struct drm_device *dev,
 
 	dev_dbg(dev->dev, "init DSI output on pipe %d\n", pipe);
 
-	if (!dev || ((pipe != 0) && (pipe != 2))) {
+	if ((pipe != 0) && (pipe != 2)) {
 		DRM_ERROR("Invalid parameter\n");
 		return;
 	}


