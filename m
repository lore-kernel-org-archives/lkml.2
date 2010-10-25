Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab0JYQZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:25:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48310 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203Ab0JYQZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:25:27 -0400
Date: Mon, 25 Oct 2010 18:25:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86-32, mm: Remove duplicated include
Message-ID: <20101025162523.GA4712@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <201010230117.o9N1H2Mk032101@hera.kernel.org>
 <AANLkTimOHBw19TuouqNsEaBcZnfU5kaBoB0Fm+QhRz4h@mail.gmail.com>
 <20101023092429.GA910@liondog.tnic>
 <20101023141534.GC7768@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101023141534.GC7768@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 04:15:34PM +0200, Ingo Molnar wrote:
> Please send a delta patch and we can do any trivial changes via the
> usual channels. The tree hpa sent to Linus is tested and this is
> tricky code.

Ok, here it is, 32-bit randconfig tested for a day.

--
From: Borislav Petkov <bp@alien8.de>
Date: Mon, 25 Oct 2010 18:15:22 +0200
Subject: [PATCH] x86-32, mm: Remove duplicated include

b40827fa7268fda8a62490728a61c2856f33830b added an include directive
which is needless and is taken care of by a previous one. Remove it.

Caught-by: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Signed-off-by: Borislav Petkov <bp@alien8.de>
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
-- 
1.7.1


-- 
Regards/Gruss,
Boris.
