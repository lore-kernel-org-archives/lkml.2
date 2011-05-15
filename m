Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab1EOXib (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:38:31 -0400
Received: from mail.df.lth.se ([194.47.250.12]:10280 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456Ab1EOXi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:38:28 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Dave Jones <davej@redhat.com>
Subject: [PATCH 10/13] mach-ux500: move CPUfreq driver to cpufreq subsystem
Date: Mon, 16 May 2011 01:38:25 +0200
Message-Id: <1305502705-32741-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of the ARM arch subsystem migration, move the DB8500
cpufreq driver to drivers/cpufreq as discussed with Dave Jones. The
Makefile is not updated in order to avoid cross-subsystem conflicts
for this file in merges.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 .../cpufreq.c => drivers/cpufreq/db8500-cpufreq.c  |    0
 1 files changed, 0 insertions(+), 0 deletions(-)
 rename arch/arm/mach-ux500/cpufreq.c => drivers/cpufreq/db8500-cpufreq.c (100%)

diff --git a/arch/arm/mach-ux500/cpufreq.c b/drivers/cpufreq/db8500-cpufreq.c
similarity index 100%
rename from arch/arm/mach-ux500/cpufreq.c
rename to drivers/cpufreq/db8500-cpufreq.c
-- 
1.7.4.4

