Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab2JWGRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:17:40 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60559 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756581Ab2JWGRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:17:38 -0400
From: Kelvin Cheung <keguang.zhang@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org
Cc: mturquette@linaro.org, Kelvin Cheung <keguang.zhang@gmail.com>
Subject: [PATCH 4/4] MIPS: Loongson1B: Fix a typo
Date: Tue, 23 Oct 2012 14:17:03 +0800
Message-Id: <1350973023-7667-5-git-send-email-keguang.zhang@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1350973023-7667-1-git-send-email-keguang.zhang@gmail.com>
References: <1350973023-7667-1-git-send-email-keguang.zhang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo in the code.

Signed-off-by: Kelvin Cheung <keguang.zhang@gmail.com>
---
 arch/mips/loongson1/common/clock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/loongson1/common/clock.c b/arch/mips/loongson1/common/clock.c
index 7db0a6a..07133de 100644
--- a/arch/mips/loongson1/common/clock.c
+++ b/arch/mips/loongson1/common/clock.c
@@ -22,7 +22,7 @@ void __init plat_time_init(void)
 	/* setup mips r4k timer */
 	clk = clk_get(NULL, "cpu");
 	if (IS_ERR(clk))
-		panic("unable to get dc clock, err=%ld", PTR_ERR(clk));
+		panic("unable to get cpu clock, err=%ld", PTR_ERR(clk));
 
 	mips_hpt_frequency = clk_get_rate(clk) / 2;
 }
-- 
1.7.1

