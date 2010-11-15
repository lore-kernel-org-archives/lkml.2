Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733Ab0KODO6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:14:58 -0500
Received: from mail.perches.com ([173.55.12.10]:1127 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376Ab0KODF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:29 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/44] drivers/cpufreq: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:23 -0800
Message-Id: <a4bef9c18ce34e80870a07c728ee25e8efac6d9d.1289789604.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/cpufreq/cpufreq_conservative.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 526bfbf..b0d8f3d 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -118,7 +118,7 @@ static inline cputime64_t get_cpu_idle_time_jiffy(unsigned int cpu,
 	if (wall)
 		*wall = (cputime64_t)jiffies_to_usecs(cur_wall_time);
 
-	return (cputime64_t)jiffies_to_usecs(idle_time);;
+	return (cputime64_t)jiffies_to_usecs(idle_time);
 }
 
 static inline cputime64_t get_cpu_idle_time(unsigned int cpu, cputime64_t *wall)
-- 
1.7.3.1.g432b3.dirty

