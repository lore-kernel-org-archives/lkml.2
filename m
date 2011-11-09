Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab1KIUFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:05:15 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:53570 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1KIUFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:05:14 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mips: loongson2_clock: include linux/module.h
Date: Wed,  9 Nov 2011 22:05:09 +0200
Message-Id: <1320869109-9508-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following compilation failure with v3.2-rc1 by including module.h:

  CC [M]  arch/mips/kernel/cpufreq/loongson2_clock.o
arch/mips/kernel/cpufreq/loongson2_clock.c:39:1: error: data definition has no type or storage class [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:39:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Werror=implicit-int]
arch/mips/kernel/cpufreq/loongson2_clock.c:39:1: error: parameter names (without types) in function declaration [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:51:1: error: data definition has no type or storage class [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:51:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Werror=implicit-int]
arch/mips/kernel/cpufreq/loongson2_clock.c:51:1: error: parameter names (without types) in function declaration [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:71:1: error: data definition has no type or storage class [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:71:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Werror=implicit-int]
arch/mips/kernel/cpufreq/loongson2_clock.c:71:1: error: parameter names (without types) in function declaration [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:76:1: error: data definition has no type or storage class [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:76:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Werror=implicit-int]
arch/mips/kernel/cpufreq/loongson2_clock.c:76:1: error: parameter names (without types) in function declaration [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:82:1: error: data definition has no type or storage class [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:82:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Werror=implicit-int]
arch/mips/kernel/cpufreq/loongson2_clock.c:82:1: error: parameter names (without types) in function declaration [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:87:1: error: data definition has no type or storage class [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:87:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL' [-Werror=implicit-int]
arch/mips/kernel/cpufreq/loongson2_clock.c:87:1: error: parameter names (without types) in function declaration [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:93:1: error: data definition has no type or storage class [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:93:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Werror=implicit-int]
arch/mips/kernel/cpufreq/loongson2_clock.c:93:1: error: parameter names (without types) in function declaration [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:131:1: error: data definition has no type or storage class [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:131:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Werror=implicit-int]
arch/mips/kernel/cpufreq/loongson2_clock.c:131:1: error: parameter names (without types) in function declaration [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:147:1: error: data definition has no type or storage class [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:147:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Werror=implicit-int]
arch/mips/kernel/cpufreq/loongson2_clock.c:147:1: error: parameter names (without types) in function declaration [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:166:1: error: data definition has no type or storage class [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:166:1: error: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL' [-Werror=implicit-int]
arch/mips/kernel/cpufreq/loongson2_clock.c:166:1: error: parameter names (without types) in function declaration [-Werror]
arch/mips/kernel/cpufreq/loongson2_clock.c:168:15: error: expected declaration specifiers or '...' before string constant
arch/mips/kernel/cpufreq/loongson2_clock.c:169:20: error: expected declaration specifiers or '...' before string constant
arch/mips/kernel/cpufreq/loongson2_clock.c:170:16: error: expected declaration specifiers or '...' before string constant

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 arch/mips/kernel/cpufreq/loongson2_clock.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/kernel/cpufreq/loongson2_clock.c b/arch/mips/kernel/cpufreq/loongson2_clock.c
index cefc6e2..5426779 100644
--- a/arch/mips/kernel/cpufreq/loongson2_clock.c
+++ b/arch/mips/kernel/cpufreq/loongson2_clock.c
@@ -7,6 +7,7 @@
  * for more details.
  */
 
+#include <linux/module.h>
 #include <linux/cpufreq.h>
 #include <linux/platform_device.h>
 
-- 
1.7.2.5

