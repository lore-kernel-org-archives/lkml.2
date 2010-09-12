Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842Ab0ILFLK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 01:11:10 -0400
Received: from mail.perches.com ([173.55.12.10]:1743 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab0ILFLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 01:11:06 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] arch/avr32: Remove pr_<level> uses of KERN_<level>
Date: Sat, 11 Sep 2010 22:10:50 -0700
Message-Id: <89161c7fbe53f17b4e1e29795cb9dfeb7d627553.1284267142.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284267142.git.joe@perches.com>
References: <cover.1284267142.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/avr32/mach-at32ap/at32ap700x.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index e67c999..09a9399 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -256,8 +256,8 @@ static long pll1_set_rate(struct clk *clk, unsigned long rate, int apply)
 			return -EINVAL;
 		if (clk->users > 0)
 			return -EBUSY;
-		pr_debug(KERN_INFO "clk %s: new rate %lu (actual rate %lu)\n",
-				clk->name, rate, actual_rate);
+		pr_debug("clk %s: new rate %lu (actual rate %lu)\n",
+			 clk->name, rate, actual_rate);
 		pm_writel(PLL1, ctrl);
 	}
 
-- 
1.7.3.rc1

