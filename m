Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab2JGN11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 09:27:27 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:57522 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2JGN1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 09:27:19 -0400
MIME-Version: 1.0
Date: Sun, 7 Oct 2012 21:27:18 +0800
Message-ID: <CAPgLHd8itpLei2m-T-W1U5L_Q83oejtUhSZuDfDvXQrPPNhRTQ@mail.gmail.com>
Subject: [PATCH] drm/nouveau: remove duplicated include from nouveau_drm.c
From: Wei Yongjun <weiyj.lk@gmail.com>
To: airlied@linux.ie
Cc: yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/nouveau/nouveau_drm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drm.c b/drivers/gpu/drm/nouveau/nouveau_drm.c
index ccae8c2..f5c8ccf 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drm.c
@@ -49,7 +49,6 @@
 #include "nouveau_fbcon.h"
 #include "nouveau_fence.h"
 
-#include "nouveau_ttm.h"
 
 MODULE_PARM_DESC(config, "option string to pass to driver core");
 static char *nouveau_config;

