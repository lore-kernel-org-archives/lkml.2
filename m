Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab1DAWeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 18:34:50 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:25136 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758791Ab1DAWet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 18:34:49 -0400
Subject: [PATCH] Drivers: cpufreq/cpufreq_stats.c: Fixed brace coding style
 issue
From: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
To: davej@redhat.com, Nagananda Chumbalkar <Nagananda.Chumbalkar@hp.com>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 17:34:47 -0500
Message-ID: <1301697287.15937.5.camel@ks-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0f157586affbd149943440eb26ea2981359d79c1 Mon Sep 17 00:00:00 2001
From: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
Date: Fri, 1 Apr 2011 17:20:49 -0500
Subject: [PATCH] Drivers: cpufreq/cpufreq_stats.c: Fixed brace coding
style issue

Fixed brace coding style issue.

Signed-off-by: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
---
 drivers/cpufreq/cpufreq_stats.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c
b/drivers/cpufreq/cpufreq_stats.c
index 00d73fc..78bf713 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -324,8 +324,7 @@ static int __cpuinit
cpufreq_stat_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block cpufreq_stat_cpu_notifier __refdata =
-{
+static struct notifier_block cpufreq_stat_cpu_notifier __refdata = {
 	.notifier_call = cpufreq_stat_cpu_callback,
 };
 
-- 
1.7.1



