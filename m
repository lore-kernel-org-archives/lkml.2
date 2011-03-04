Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab1CDL7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:59:04 -0500
Received: from server103.greatnet.de ([83.133.97.6]:33998 "EHLO
	server103.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759474Ab1CDL6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:58:54 -0500
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: mingo@elte.hu
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, gorcunov@gmail.com,
        Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCHv2 1/7] x86: remove superflous goal definition of tsc_sync
Date: Fri,  4 Mar 2011 12:58:37 +0100
Message-Id: <1299239923-7092-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This goal definition is superflous.
CONFIG_X86_64_SMP depends on CONFIG_SMP
and tsc_sync.o is already in the definition of CONFIG_SMP.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 arch/x86/kernel/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 4ad4509..6b61081 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -69,7 +69,6 @@ obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_SMP)		+= smpboot.o tsc_sync.o
 obj-$(CONFIG_SMP)		+= setup_percpu.o
-obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-y				+= apic/
 obj-$(CONFIG_X86_REBOOTFIXUPS)	+= reboot_fixups_32.o
-- 
1.7.2.3

