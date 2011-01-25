Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab1AYBPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:15:19 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:53272 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab1AYBPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:15:18 -0500
Message-ID: <4D3E23D1.7010405@kernel.org>
Date: Mon, 24 Jan 2011 17:13:53 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: remove left over system_64.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


left-over from x86 merging...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/system_64.h |   22 ----------------------
 1 file changed, 22 deletions(-)

Index: linux-2.6/arch/x86/include/asm/system_64.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/system_64.h
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
