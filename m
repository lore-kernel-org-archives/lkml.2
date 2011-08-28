Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384Ab1H1MDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Aug 2011 08:03:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36384 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab1H1MDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Aug 2011 08:03:31 -0400
From: Arun Thomas <arun.thomas@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andre Przywara <andre.przywara@amd.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Christoph Lameter <cl@linux.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Arun Thomas <arun.thomas@gmail.com>
Subject: [PATCH] x86, cpu: Add cpufeature flag for TSC-Deadline
Date: Sun, 28 Aug 2011 14:03:12 +0200
Message-Id: <1314532992-19495-1-git-send-email-arun.thomas@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a flag for TSC-Deadline mode, which allows software to
set the local APIC timer to one-shot interrupt at an absolute time
(i.e., a TSC deadline).

Signed-off-by: Arun Thomas <arun.thomas@gmail.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index f24ed51..f19e1e8 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -121,6 +121,7 @@
 #define X86_FEATURE_X2APIC	(4*32+21) /* x2APIC */
 #define X86_FEATURE_MOVBE	(4*32+22) /* MOVBE instruction */
 #define X86_FEATURE_POPCNT      (4*32+23) /* POPCNT instruction */
+#define X86_FEATURE_TSC_DEADLINE (4*32+24) /* APIC supports TSC deadline mode */
 #define X86_FEATURE_AES		(4*32+25) /* AES instructions */
 #define X86_FEATURE_XSAVE	(4*32+26) /* XSAVE/XRSTOR/XSETBV/XGETBV */
 #define X86_FEATURE_OSXSAVE	(4*32+27) /* "" XSAVE enabled in the OS */
-- 
1.7.4.1

