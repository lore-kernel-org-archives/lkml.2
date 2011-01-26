Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182Ab1AZH0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 02:26:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:52983 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab1AZH0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 02:26:50 -0500
Date: Wed, 26 Jan 2011 07:26:26 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4D3E23D1.7010405@kernel.org>
References: <4D3E23D1.7010405@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Remove left over system_64.h
Message-ID: <tip-9a57c3e487d25f69715705dfeef6eb9e4d666ad7@git.kernel.org>
Git-Commit-ID: 9a57c3e487d25f69715705dfeef6eb9e4d666ad7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 26 Jan 2011 07:26:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a57c3e487d25f69715705dfeef6eb9e4d666ad7
Gitweb:     http://git.kernel.org/tip/9a57c3e487d25f69715705dfeef6eb9e4d666ad7
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 24 Jan 2011 17:13:53 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Jan 2011 08:05:58 +0100

x86: Remove left over system_64.h

Left-over from the x86 merge ...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4D3E23D1.7010405@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/system_64.h |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/system_64.h b/arch/x86/include/asm/system_64.h
deleted file mode 100644
index 1159e09..0000000
--- a/arch/x86/include/asm/system_64.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#ifndef _ASM_X86_SYSTEM_64_H
-#define _ASM_X86_SYSTEM_64_H
-
-#include <asm/segment.h>
-#include <asm/cmpxchg.h>
-
-
-static inline unsigned long read_cr8(void)
-{
-	unsigned long cr8;
-	asm volatile("movq %%cr8,%0" : "=r" (cr8));
-	return cr8;
-}
-
-static inline void write_cr8(unsigned long val)
-{
-	asm volatile("movq %0,%%cr8" :: "r" (val) : "memory");
-}
-
-#include <linux/irqflags.h>
-
-#endif /* _ASM_X86_SYSTEM_64_H */
