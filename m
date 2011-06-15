Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab1FOIyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 04:54:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:65515 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab1FOIyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 04:54:16 -0400
X-AuditID: cbfee61a-b7ce2ae000001a8f-f6-4df873358f1e
Date: Wed, 15 Jun 2011 17:54:12 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH] regulator: max8952 - fix wrong gpio valid check
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        jhbird.choi@samsung.com, myungjoo.ham@gmail.com
Message-id: <1308128052-27739-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
X-OriginalArrivalTime: 15 Jun 2011 08:54:06.0175 (UTC)
 FILETIME=[C85FBEF0:01CC2B39]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/regulator/max8952.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index daff7fd..486ed81 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -139,7 +139,7 @@ static int max8952_set_voltage(struct regulator_dev *rdev,
 	s8 vid = -1, i;
 
 	if (!gpio_is_valid(max8952->pdata->gpio_vid0) ||
-			!gpio_is_valid(max8952->pdata->gpio_vid0)) {
+			!gpio_is_valid(max8952->pdata->gpio_vid1)) {
 		/* DVS not supported */
 		return -EPERM;
 	}
-- 
1.7.0

