Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab0LMVnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:43:20 -0500
Received: from mail.perches.com ([173.55.12.10]:2569 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376Ab0LMVm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:42:27 -0500
From: Joe Perches <joe@perches.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] dma: ste_dma40: Use vsprintf extension %pR for struct resource
Date: Mon, 13 Dec 2010 13:42:18 -0800
Message-Id: <0a39cc13678686b4f53f5e85297b44158cc7ffca.1292276119.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1292276119.git.joe@perches.com>
References: <cover.1292276119.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/dma/ste_dma40.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index fab68a5..f1a8e1d 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2855,9 +2855,8 @@ static int __init d40_probe(struct platform_device *pdev)
 	if (request_mem_region(res->start, resource_size(res),
 			       D40_NAME " I/O lcpa") == NULL) {
 		ret = -EBUSY;
-		dev_err(&pdev->dev,
-			"[%s] Failed to request LCPA region 0x%x-0x%x\n",
-			__func__, res->start, res->end);
+		dev_err(&pdev->dev, "[%s] Failed to request LCPA region %pR\n",
+			__func__, res);
 		goto failure;
 	}
 
-- 
1.7.3.3.398.g0b0cd.dirty

