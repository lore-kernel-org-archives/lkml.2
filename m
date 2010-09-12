Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab0ILFLH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 01:11:07 -0400
Received: from mail.perches.com ([173.55.12.10]:1714 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab0ILFLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 01:11:05 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/11] arch/arm: Remove pr_<level> uses of KERN_<level>
Date: Sat, 11 Sep 2010 22:10:49 -0700
Message-Id: <78519236782f0f4a848d67aefb5fe7b3ce375cee.1284267142.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284267142.git.joe@perches.com>
References: <cover.1284267142.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/mach-pxa/cpufreq-pxa2xx.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-pxa/cpufreq-pxa2xx.c b/arch/arm/mach-pxa/cpufreq-pxa2xx.c
index 50d5939..58093d9 100644
--- a/arch/arm/mach-pxa/cpufreq-pxa2xx.c
+++ b/arch/arm/mach-pxa/cpufreq-pxa2xx.c
@@ -312,8 +312,7 @@ static int pxa_set_target(struct cpufreq_policy *policy,
 	freqs.cpu = policy->cpu;
 
 	if (freq_debug)
-		pr_debug(KERN_INFO "Changing CPU frequency to %d Mhz, "
-			 "(SDRAM %d Mhz)\n",
+		pr_debug("Changing CPU frequency to %d Mhz, (SDRAM %d Mhz)\n",
 			 freqs.new / 1000, (pxa_freq_settings[idx].div2) ?
 			 (new_freq_mem / 2000) : (new_freq_mem / 1000));
 
-- 
1.7.3.rc1

