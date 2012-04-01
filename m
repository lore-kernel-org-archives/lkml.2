Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151Ab2DAOb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 10:31:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50247 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085Ab2DAOb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 10:31:26 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King <linux@arm.linux.org.uk>, Mike Turquette <mturquette@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] clk: Remove comment for end of CONFIG_COMMON_CLK section
Date: Sun,  1 Apr 2012 15:31:23 +0100
Message-Id: <1333290683-11815-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment is inaccurate (it actually ends the CONFIG_COMMON_CLK
section, there's no else) and given that we've just got a single level
of ifdef isn't really needed anyway.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 include/linux/clk.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/clk.h b/include/linux/clk.h
index b025272..c9547d9 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -81,7 +81,7 @@ int clk_notifier_register(struct clk *clk, struct notifier_block *nb);
 
 int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
 
-#endif /* !CONFIG_COMMON_CLK */
+#endif
 
 /**
  * clk_get - lookup and obtain a reference to a clock producer.
-- 
1.7.9.1

