Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0LFWFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:05:53 -0500
Received: from mail.perches.com ([173.55.12.10]:2357 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754457Ab0LFWFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:24 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 29/29] drivers/regulator: Update WARN uses
Date: Mon,  6 Dec 2010 14:05:19 -0800
Message-Id: <b0588ea464d551f9dbd80c0fee68a780d6279b50.1291670106.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/regulator/core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index a1b1237..5d07e5d 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1379,8 +1379,7 @@ static int _regulator_disable(struct regulator_dev *rdev,
 	*supply_rdev_ptr = NULL;
 
 	if (WARN(rdev->use_count <= 0,
-			"unbalanced disables for %s\n",
-			rdev_get_name(rdev)))
+		 "unbalanced disables for %s\n", rdev_get_name(rdev)))
 		return -EIO;
 
 	/* are we the last user and permitted to disable ? */
-- 
1.7.3.2.245.g03276.dirty

