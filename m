Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab2GED7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 23:59:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59084 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab2GED7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 23:59:36 -0400
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: [PATCH 5/6] mfd: max77686: Remove the clocks from the list of regulators
Date: Thu,  5 Jul 2012 09:28:24 +0530
Message-Id: <1341460705-10868-5-git-send-email-yadi.brar@samsung.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1341460705-10868-1-git-send-email-yadi.brar@samsung.com>
References: <1341460705-10868-1-git-send-email-yadi.brar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the clocks from the list of regulators to correct the value of
MAX77686_REG_MAX which is used in the regulator driver to represent the no.
of regulators present in max77686.

Signed-off-by: Yadwinder Singh Brar <yadi.brar@samsung.com>
---
 include/linux/mfd/max77686.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/include/linux/mfd/max77686.h b/include/linux/mfd/max77686.h
index fcf3126..3d7ae4d 100644
--- a/include/linux/mfd/max77686.h
+++ b/include/linux/mfd/max77686.h
@@ -67,9 +67,6 @@ enum max77686_regulators {
 	MAX77686_BUCK7,
 	MAX77686_BUCK8,
 	MAX77686_BUCK9,
-	MAX77686_EN32KHZ_AP,
-	MAX77686_EN32KHZ_CP,
-	MAX77686_P32KH,
 
 	MAX77686_REG_MAX,
 };
-- 
1.7.0.4

