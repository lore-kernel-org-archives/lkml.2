Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab0J3VNM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:13:12 -0400
Received: from mail.perches.com ([173.55.12.10]:3730 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab0J3VJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:40 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>, linux-omap@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 23/39] drivers/video/omap2/dss: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:40 -0700
Message-Id: <3dffcda8949a6625985223b6fbf18815b93646d7.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing initial argument.
Coalesce long formats.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/video/omap2/dss/core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/video/omap2/dss/core.c b/drivers/video/omap2/dss/core.c
index 8e89f60..2a98237 100644
--- a/drivers/video/omap2/dss/core.c
+++ b/drivers/video/omap2/dss/core.c
@@ -867,8 +867,7 @@ static void reset_device(struct device *dev, int check)
 		dev->platform_data = NULL;
 		while (dev_p < dev_end) {
 			if (*dev_p) {
-				WARN("%s: struct device fields will be "
-						"discarded\n",
+				WARN(1, "%s: struct device fields will be discarded\n",
 				     __func__);
 				break;
 			}
-- 
1.7.3.1.g432b3.dirty

