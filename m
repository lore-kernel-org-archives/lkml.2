Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0LFWHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:07:49 -0500
Received: from mail.perches.com ([173.55.12.10]:2334 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab0LFWFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:23 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/29] drivers/video/omap2/dss: Update WARN uses
Date: Mon,  6 Dec 2010 14:05:05 -0800
Message-Id: <7959493a11e106fa030c0f912cd8b9c3af20a9f8.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
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
1.7.3.2.245.g03276.dirty

