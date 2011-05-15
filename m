Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab1EOXio (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:38:44 -0400
Received: from mail.df.lth.se ([194.47.250.12]:10290 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab1EOXim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:38:42 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Dave Jones <davej@redhat.com>
Subject: [PATCH 12/13] cpufreq: make DB8500 cpufreq driver compile
Date: Mon, 16 May 2011 01:38:39 +0200
Message-Id: <1305502719-335-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Concluding interface update and movement of the driver by making
the DB8500 cpufreq driver compile in the cpufreq subsystem.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/cpufreq/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 71fc3b4..fe8d488 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE)	+= cpufreq_conservative.o
 # CPUfreq cross-arch helpers
 obj-$(CONFIG_CPU_FREQ_TABLE)		+= freq_table.o
 
+obj-$(CONFIG_UX500_SOC_DB8500)		+= db8500-cpufreq.o
-- 
1.7.4.4

