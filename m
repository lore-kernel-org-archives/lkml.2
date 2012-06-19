Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab2FSIa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 04:30:28 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:32912 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab2FSIaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 04:30:25 -0400
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org
Cc: linux@arm.linux.org.uk, a.p.zijlstra@chello.nl, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH v2 5/5] sched: cpu_power: enable ARCH_POWER
Date: Tue, 19 Jun 2012 10:28:56 +0200
Message-Id: <1340094536-20873-6-git-send-email-vincent.guittot@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1340094536-20873-1-git-send-email-vincent.guittot@linaro.org>
References: <1340094536-20873-1-git-send-email-vincent.guittot@linaro.org>
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

