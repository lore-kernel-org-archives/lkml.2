Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab0J3VOI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:14:08 -0400
Received: from mail.perches.com ([173.55.12.10]:3744 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab0J3VJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:34 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 14/39] drivers/media/video: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:31 -0700
Message-Id: <def5be1d0f38494d6aea661227e7d9a24e08590b.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing newlines.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |    2 +-
 drivers/media/video/sr030pc30.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index 2e7c547..91fc213 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -543,7 +543,7 @@ static void fimc_dma_run(void *priv)
 	unsigned long flags;
 	u32 ret;
 
-	if (WARN(!ctx, "null hardware context"))
+	if (WARN(!ctx, "null hardware context\n"))
 		return;
 
 	fimc = ctx->fimc_dev;
diff --git a/drivers/media/video/sr030pc30.c b/drivers/media/video/sr030pc30.c
index c9dc67a..864696b 100644
--- a/drivers/media/video/sr030pc30.c
+++ b/drivers/media/video/sr030pc30.c
@@ -735,7 +735,7 @@ static int sr030pc30_s_power(struct v4l2_subdev *sd, int on)
 	const struct sr030pc30_platform_data *pdata = info->pdata;
 	int ret;
 
-	if (WARN(pdata == NULL, "No platform data!"))
+	if (WARN(pdata == NULL, "No platform data!\n"))
 		return -ENOMEM;
 
 	/*
-- 
1.7.3.1.g432b3.dirty

