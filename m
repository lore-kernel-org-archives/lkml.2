Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377Ab1LNPNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:13:11 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:28153
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754822Ab1LNPNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:13:08 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h64h)
X-Spam-TCS-SCL: 3:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LW78XO-02-7T6-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] x86: Report cpb and eff_freq_ro flags correctly
Date: Wed, 14 Dec 2011 16:12:54 +0100
Message-ID: <1323875574-17881-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the flags to get rid of the [9] and [10] feature names
in cpuinfo's 'power management' fields and replace them with
meaningful names.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/cpu/powerflags.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/powerflags.c b/arch/x86/kernel/cpu/powerflags.c
index 5abbea2..7b3fe56 100644
--- a/arch/x86/kernel/cpu/powerflags.c
+++ b/arch/x86/kernel/cpu/powerflags.c
@@ -16,5 +16,6 @@ const char *const x86_power_flags[32] = {
 	"100mhzsteps",
 	"hwpstate",
 	"",	/* tsc invariant mapped to constant_tsc */
-		/* nothing */
+	"cpb",  /* core performance boost */
+	"eff_freq_ro", /* Readonly aperf/mperf */
 };
-- 
1.7.5.4


