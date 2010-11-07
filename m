Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab0KGVKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 16:10:18 -0500
Received: from mail.perches.com ([173.55.12.10]:4542 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab0KGVKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 16:10:17 -0500
Subject: [PATCH] arch/arm/plat-mxc/cpufreq.c: Fix line continuation defect
From: Joe Perches <joe@perches.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Nov 2010 13:10:15 -0800
Message-ID: <1289164215.29216.315.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/plat-mxc/cpufreq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/plat-mxc/cpufreq.c b/arch/arm/plat-mxc/cpufreq.c
index 039538e..9f358af 100644
--- a/arch/arm/plat-mxc/cpufreq.c
+++ b/arch/arm/plat-mxc/cpufreq.c
@@ -154,8 +154,8 @@ static int __init mxc_cpufreq_init(struct cpufreq_policy *policy)
 	ret = cpufreq_frequency_table_cpuinfo(policy, imx_freq_table);
 
 	if (ret < 0) {
-		printk(KERN_ERR "%s: failed to register i.MXC CPUfreq \
-				with error code %d\n", __func__, ret);
+		printk(KERN_ERR "%s: failed to register i.MXC CPUfreq with error code %d\n",
+		       __func__, ret);
 		goto err;
 	}
 


