Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab0KGWIi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 17:08:38 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:22705 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab0KGWIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 17:08:37 -0500
Date: Sun, 7 Nov 2010 22:57:18 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Ingo Molnar <mingo@redhat.com>, x86@kernel.org
Subject: [PATCH] x86 apic: Including a header once is enough, no need to do
 it twice (asm/atomic.h)
Message-ID: <alpine.LNX.2.00.1011072253360.26247@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In arch/x86/kernel/apic/apic.c, <asm/atomic.h> is included twice. Once is 
enough.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 apic.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 850657d..3f838d5 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -52,7 +52,6 @@
 #include <asm/mce.h>
 #include <asm/kvm_para.h>
 #include <asm/tsc.h>
-#include <asm/atomic.h>
 
 unsigned int num_processors;
 


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

