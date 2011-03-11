Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab1CKJyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:54:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:38684 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab1CKJx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:53:58 -0500
Date: Fri, 11 Mar 2011 09:53:15 GMT
From: tip-bot for Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@openvz.org, tglx@linutronix.de, henne@nachtwindheim.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, tglx@linutronix.de, henne@nachtwindheim.de,
        mingo@elte.hu
In-Reply-To: <1299826956-8607-1-git-send-email-henne@nachtwindheim.de>
References: <1299826956-8607-1-git-send-email-henne@nachtwindheim.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: Remove superflous goal definition of tsc_sync
Message-ID: <tip-ec8df88f6bd808db47ac7a06c96dcc90d7ed6ecc@git.kernel.org>
Git-Commit-ID: ec8df88f6bd808db47ac7a06c96dcc90d7ed6ecc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 11 Mar 2011 09:53:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec8df88f6bd808db47ac7a06c96dcc90d7ed6ecc
Gitweb:     http://git.kernel.org/tip/ec8df88f6bd808db47ac7a06c96dcc90d7ed6ecc
Author:     Henrik Kretzschmar <henne@nachtwindheim.de>
AuthorDate: Fri, 11 Mar 2011 08:02:35 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 11 Mar 2011 08:13:59 +0100

x86: Remove superflous goal definition of tsc_sync

The extra tsc_sync.o goal definition is superflous.
CONFIG_X86_64_SMP depends on CONFIG_SMP
and tsc_sync.o is already in the definition of CONFIG_SMP.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <1299826956-8607-1-git-send-email-henne@nachtwindheim.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 6ac5036..62445ba 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -66,9 +66,9 @@ obj-$(CONFIG_PCI)		+= early-quirks.o
 apm-y				:= apm_32.o
 obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_SMP)		+= smp.o
-obj-$(CONFIG_SMP)		+= smpboot.o tsc_sync.o
+obj-$(CONFIG_SMP)		+= smpboot.o
+obj-$(CONFIG_SMP)		+= tsc_sync.o
 obj-$(CONFIG_SMP)		+= setup_percpu.o
-obj-$(CONFIG_X86_64_SMP)	+= tsc_sync.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-y				+= apic/
