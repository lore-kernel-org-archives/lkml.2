Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab2FLMDA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:03:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62270 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab2FLMC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:02:58 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org
Cc: linux@arm.linux.org.uk, peterz@infradead.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: [RFC 4/4] sched: cpu_power: enable ARCH_POWER
Date: Tue, 12 Jun 2012 14:02:04 +0200
Message-Id: <1339502524-10265-5-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
References: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heteregeneous ARM platform uses arch_scale_freq_power function
to reflect the relative capacity of each core

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
---
 kernel/sched/features.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index de00a48..d98ae90 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -42,7 +42,7 @@ SCHED_FEAT(CACHE_HOT_BUDDY, true)
 /*
  * Use arch dependent cpu power functions
  */
-SCHED_FEAT(ARCH_POWER, false)
+SCHED_FEAT(ARCH_POWER, true)
 
 SCHED_FEAT(HRTICK, false)
 SCHED_FEAT(DOUBLE_TICK, false)
-- 
1.7.9.5

