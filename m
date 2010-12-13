Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab0LMVmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:42:52 -0500
Received: from mail.perches.com ([173.55.12.10]:2577 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246Ab0LMVma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:42:30 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH 4/5] video: mx3fb: Use vsprintf extension %pR for struct resource
Date: Mon, 13 Dec 2010 13:42:21 -0800
Message-Id: <b3c183f21ed73116f4c158249836ac5ab68862cb.1292276119.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1292276119.git.joe@perches.com>
References: <cover.1292276119.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/video/mx3fb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index ca0f6be..cb01391 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -1474,8 +1474,7 @@ static int mx3fb_probe(struct platform_device *pdev)
 		goto eremap;
 	}
 
-	pr_debug("Remapped %x to %x at %p\n", sdc_reg->start, sdc_reg->end,
-		 mx3fb->reg_base);
+	pr_debug("Remapped %pR at %p\n", sdc_reg, mx3fb->reg_base);
 
 	/* IDMAC interface */
 	dmaengine_get();
-- 
1.7.3.3.398.g0b0cd.dirty

