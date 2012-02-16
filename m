Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab2BPDwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 22:52:46 -0500
Received: from ozlabs.org ([203.10.76.45]:45315 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975Ab2BPDv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 22:51:57 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Message-ID: <1329364286.30342.rusty@rustcorp.com.au>
Date: Thu, 16 Feb 2012 14:21:26 +1030
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/5] drivers/cpufreq/db8500-cpufreq: remove references to cpu_*_map.
Cc: cpufreq@vger.kernel.org
Cc: davej@redhat.com
Cc: jonas.aberg@stericsson.com
Cc: martin.persson@stericsson.com
Cc: sundar.iyer@stericsson.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

This has been obsolescent for a while; time for the final push.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dave Jones <davej@redhat.com>
Cc: cpufreq@vger.kernel.org
Cc: Sundar Iyer <sundar.iyer@stericsson.com>
Cc: Martin Persson <martin.persson@stericsson.com>
Cc: Jonas Aaberg <jonas.aberg@stericsson.com>
---
 drivers/cpufreq/db8500-cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/db8500-cpufreq.c b/drivers/cpufreq/db8500-cpufreq.c
--- a/drivers/cpufreq/db8500-cpufreq.c
+++ b/drivers/cpufreq/db8500-cpufreq.c
@@ -145,7 +145,7 @@ static int __cpuinit db8500_cpufreq_init
 	policy->cpuinfo.transition_latency = 20 * 1000; /* in ns */
 
 	/* policy sharing between dual CPUs */
-	cpumask_copy(policy->cpus, &cpu_present_map);
+	cpumask_copy(policy->cpus, cpu_present_mask);
 
 	policy->shared_type = CPUFREQ_SHARED_TYPE_ALL;
 

