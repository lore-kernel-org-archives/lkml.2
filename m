Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1HVXKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:10:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:51246 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab1HVXKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:10:06 -0400
Date: Mon, 22 Aug 2011 23:10:00 GMT
From: tip-bot for Arun Thomas <arun.thomas@gmail.com>
Message-ID: <tip-be604e695f9a0db4cd5c4c232857a10c6bc9dee4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, arun.thomas@gmail.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        arun.thomas@gmail.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1313782943-3898-1-git-send-email-arun.thomas@gmail.com>
References: <1313782943-3898-1-git-send-email-arun.thomas@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpufeature] x86, cpu: Add cpufeature flag for PCIDs
Git-Commit-ID: be604e695f9a0db4cd5c4c232857a10c6bc9dee4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (hera.kernel.org [127.0.0.1]); Mon, 22 Aug 2011 23:10:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be604e695f9a0db4cd5c4c232857a10c6bc9dee4
Gitweb:     http://git.kernel.org/tip/be604e695f9a0db4cd5c4c232857a10c6bc9dee4
Author:     Arun Thomas <arun.thomas@gmail.com>
AuthorDate: Fri, 19 Aug 2011 21:42:23 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 22 Aug 2011 13:52:32 -0700

x86, cpu: Add cpufeature flag for PCIDs

This patch add a flag for Process-Context Identifiers (PCIDs) aka
Address Space Identifiers (ASIDs) aka Tagged TLB support.

Signed-off-by: Arun Thomas <arun.thomas@gmail.com>
Link: http://lkml.kernel.org/r/1313782943-3898-1-git-send-email-arun.thomas@gmail.com
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/cpufeature.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 4258aac..f24ed51 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -114,6 +114,7 @@
 #define X86_FEATURE_CX16	(4*32+13) /* CMPXCHG16B */
 #define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
 #define X86_FEATURE_PDCM	(4*32+15) /* Performance Capabilities */
+#define X86_FEATURE_PCID	(4*32+17) /* Process Context Identifiers */
 #define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
 #define X86_FEATURE_XMM4_1	(4*32+19) /* "sse4_1" SSE-4.1 */
 #define X86_FEATURE_XMM4_2	(4*32+20) /* "sse4_2" SSE-4.2 */
