Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab1ELChw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 22:37:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:60083 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab1ELChu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 22:37:50 -0400
X-AuditID: cbfee61a-b7c84ae000006ee6-45-4dcb47fdec53
Date: Thu, 12 May 2011 11:37:48 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] regulator: max8997: remove useless code
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>, myungjoo.ham@gmail.com,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Message-id: <1305167868-9080-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 12 May 2011 02:37:49.0000 (UTC)
 FILETIME=[9548BC80:01CC104D]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>

fix unreachable code.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/regulator/max8997.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8997.c b/drivers/regulator/max8997.c
index 77e0cfb..b1c1444 100644
--- a/drivers/regulator/max8997.c
+++ b/drivers/regulator/max8997.c
@@ -267,7 +267,6 @@ static int max8997_get_enable_register(struct regulator_dev *rdev,
 	default:
 		/* Not controllable or not exists */
 		return -EINVAL;
-		break;
 	}
 
 	return 0;
-- 
1.7.4.1

