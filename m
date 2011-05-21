Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab1EUIn1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 04:43:27 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:54607 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753780Ab1EUInW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 04:43:22 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 12/13] cpufreq: make DB8500 cpufreq driver compile
Date: Sat, 21 May 2011 10:43:12 +0200
Message-ID: <1305967392-16747-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Concluding interface update and movement of the driver by making
the DB8500 cpufreq driver compile in the cpufreq subsystem.

Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Dave Jones <davej@redhat.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/cpufreq/Makefile |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index c7f1a6f..e2fc2d2 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -39,3 +39,5 @@ obj-$(CONFIG_X86_CPUFREQ_NFORCE2)	+= cpufreq-nforce2.o
 
 ##################################################################################d
 
+# ARM SoC drivers
+obj-$(CONFIG_UX500_SOC_DB8500)		+= db8500-cpufreq.o
-- 
1.7.3.2

