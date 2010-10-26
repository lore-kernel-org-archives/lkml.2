Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab0JZGr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 02:47:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:46106 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785Ab0JZGr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 02:47:28 -0400
Date: Tue, 26 Oct 2010 06:46:35 GMT
From: tip-bot for Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, bp@alien8.de, jaswinderlinux@gmail.com,
        tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, bp@alien8.de, jaswinderlinux@gmail.com,
        tglx@linutronix.de, hpa@linux.intel.com, mingo@elte.hu
In-Reply-To: <20101025162523.GA4712@a1.tnic>
References: <20101025162523.GA4712@a1.tnic>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-32, mm: Remove duplicated #include
Message-ID: <tip-610470ce804f0326ca63fbcdc5be06b750debeb1@git.kernel.org>
Git-Commit-ID: 610470ce804f0326ca63fbcdc5be06b750debeb1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 26 Oct 2010 06:46:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  610470ce804f0326ca63fbcdc5be06b750debeb1
Gitweb:     http://git.kernel.org/tip/610470ce804f0326ca63fbcdc5be06b750debeb1
Author:     Borislav Petkov <bp@alien8.de>
AuthorDate: Mon, 25 Oct 2010 18:25:23 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 Oct 2010 19:39:33 +0200

x86-32, mm: Remove duplicated #include

b40827fa7268fda8a62490728a61c2856f33830b added an include
directive which is needless and is taken care of by a previous
one. Remove it.

Caught-by: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Signed-off-by: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <20101025162523.GA4712@a1.tnic>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/acpi/sleep.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 74a8478..69fd72a 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -15,7 +15,6 @@
 
 #ifdef CONFIG_X86_32
 #include <asm/pgtable.h>
-#include <asm/pgtable_32.h>
 #endif
 
 #include "realmode/wakeup.h"
