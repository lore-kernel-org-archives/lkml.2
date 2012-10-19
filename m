Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681Ab2JSQSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:18:05 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45788 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab2JSQSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:18:03 -0400
From: Sangho Yi <antiroot@gmail.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: linux-kernel@vger.kernel.org, Sangho Yi <antiroot@gmail.com>
Subject: [PATCH] devfreq: exynos4_bus.c: Fixed an alignment of the func call args.
Date: Sat, 20 Oct 2012 01:16:34 +0900
Message-Id: <1350663394-2711-1-git-send-email-antiroot@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed the following check item (via checkpatch.pl --strict option):
CHECK: Alignment should match open parenthesis

Signed-off-by: Sangho Yi <antiroot@gmail.com>
---
 drivers/devfreq/exynos4_bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
index 88ddc77..f4089c4 100644
--- a/drivers/devfreq/exynos4_bus.c
+++ b/drivers/devfreq/exynos4_bus.c
@@ -1034,7 +1034,7 @@ static __devinit int exynos4_busfreq_probe(struct platform_device *pdev)
 	opp = opp_find_freq_floor(dev, &exynos4_devfreq_profile.initial_freq);
 	if (IS_ERR(opp)) {
 		dev_err(dev, "Invalid initial frequency %lu kHz.\n",
-		       exynos4_devfreq_profile.initial_freq);
+			exynos4_devfreq_profile.initial_freq);
 		err = PTR_ERR(opp);
 		goto err_opp_add;
 	}
--
1.7.9.5

