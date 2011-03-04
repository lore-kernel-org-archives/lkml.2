Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891Ab1CDQWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 11:22:14 -0500
Received: from server103.greatnet.de ([83.133.97.6]:59002 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759837Ab1CDQWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 11:22:13 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@elte.hu
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, gorcunov@gmail.com,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCHv3 1/7] x86: remove superflous goal definition of tsc_sync
Date: Fri,  4 Mar 2011 17:21:49 +0100
Message-Id: <1299255715-8680-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This goal definition is superflous.
CONFIG_X86_64_SMP depends on CONFIG_SMP
and tsc_sync.o is already in the definition of CONFIG_SMP.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 4ad4509..743642f 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -67,9 +67,9 @@ obj-$(CONFIG_PCI)		+= early-quirks.o
 apm-y				:= apm_32.o
 obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_SMP)		+= smp.o
-obj-$(CONFIG_SMP)		+= smpboot.o tsc_sync.o
+obj-$(CONFIG_SMP)		+= smpboot.o
+obj-$(CONFIG_SMP)		+= tsc_sync.o
 obj-$(CONFIG_SMP)		+= setup_percpu.o
-obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-y				+= apic/
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
-- 
1.7.2.3

