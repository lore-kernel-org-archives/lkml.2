Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab2INGQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:16:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48988 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab2INGQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:16:13 -0400
Date: Thu, 13 Sep 2012 23:15:59 -0700
From: tip-bot for Vincent Guittot <vincent.guittot@linaro.org>
Message-ID: <tip-bc2a27cd27271c5257989a57f511be86b26f5e54@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, vincent.guittot@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, vincent.guittot@linaro.org, tglx@linutronix.de
In-Reply-To: <1341826026-6504-6-git-send-email-vincent.guittot@linaro.org>
References: <1341826026-6504-6-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: cpu_power: enable ARCH_POWER
Git-Commit-ID: bc2a27cd27271c5257989a57f511be86b26f5e54
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:16:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc2a27cd27271c5257989a57f511be86b26f5e54
Gitweb:     http://git.kernel.org/tip/bc2a27cd27271c5257989a57f511be86b26f5e54
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Mon, 9 Jul 2012 11:27:06 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 13 Sep 2012 16:52:06 +0200

sched: cpu_power: enable ARCH_POWER

Heteregeneous ARM platform uses arch_scale_freq_power function
to reflect the relative capacity of each core

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1341826026-6504-6-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/features.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index c38f52e..eebefca 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -34,7 +34,7 @@ SCHED_FEAT(CACHE_HOT_BUDDY, true)
 /*
  * Use arch dependent cpu power functions
  */
-SCHED_FEAT(ARCH_POWER, false)
+SCHED_FEAT(ARCH_POWER, true)
 
 SCHED_FEAT(HRTICK, false)
 SCHED_FEAT(DOUBLE_TICK, false)
