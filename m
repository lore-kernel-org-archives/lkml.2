Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab2LUOHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 09:07:03 -0500
Received: from www.linutronix.de ([62.245.132.108]:52720 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2LUOGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 09:06:45 -0500
From: Torben Hohn <torbenh@linutronix.de>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>, Marek Vasut <marex@denx.de>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Torben Hohn <torbenh@linutronix.de>
Subject: [PATCH 2/2] mxs timer: decrease mxs_clockevent_device.min_delta_ns to 2 clock cycles
Date: Fri, 21 Dec 2012 15:06:16 +0100
Message-Id: <1356098776-10498-3-git-send-email-torbenh@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1356098776-10498-1-git-send-email-torbenh@linutronix.de>
References: <1356098776-10498-1-git-send-email-torbenh@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Torben Hohn <torbenh@linutronix.de>
---
 arch/arm/mach-mxs/timer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-mxs/timer.c b/arch/arm/mach-mxs/timer.c
index 689a2b5..cf45e0a 100644
--- a/arch/arm/mach-mxs/timer.c
+++ b/arch/arm/mach-mxs/timer.c
@@ -219,7 +219,7 @@ static int __init mxs_clockevent_init(struct clk *timer_clk)
 		mxs_clockevent_device.max_delta_ns =
 			clockevent_delta2ns(0xfffffffe, &mxs_clockevent_device);
 		mxs_clockevent_device.min_delta_ns =
-			clockevent_delta2ns(0xf, &mxs_clockevent_device);
+			clockevent_delta2ns(0x2, &mxs_clockevent_device);
 	}
 
 	clockevents_register_device(&mxs_clockevent_device);
-- 
1.7.10.4

