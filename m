Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab0J3VOD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:14:03 -0400
Received: from mail.perches.com ([173.55.12.10]:3730 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163Ab0J3VJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:37 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 19/39] drivers/regulator: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:36 -0700
Message-Id: <c3e0a1af39a04ba06f0dedce13c1a5e14c13fb60.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/regulator/core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index f1d10c9..813dd30 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1361,8 +1361,7 @@ static int _regulator_disable(struct regulator_dev *rdev,
 	int ret = 0;
 
 	if (WARN(rdev->use_count <= 0,
-			"unbalanced disables for %s\n",
-			rdev_get_name(rdev)))
+		 "unbalanced disables for %s\n", rdev_get_name(rdev)))
 		return -EIO;
 
 	/* are we the last user and permitted to disable ? */
-- 
1.7.3.1.g432b3.dirty

