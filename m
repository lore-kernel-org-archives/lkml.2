Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab1HOWeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 18:34:07 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:55871 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab1HOWeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 18:34:05 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Aug 2011 18:34:05 EDT
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Andy Lutomirski <luto@MIT.EDU>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86-64: remove int 0xcc from entry_64.S documentation
Date: Mon, 15 Aug 2011 19:26:50 -0300
Message-Id: <1313447210-9149-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3ae36655b97a03fa1decf72f04078ef945647c1a (x86-64: Rework vsyscall
emulation and add vsyscall= parameter) removed the special use of the
0xcc IDT vector.

Remove it from Documentation/x86/entry_64.txt also.

Cc: Andy Lutomirski <luto@MIT.EDU>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 Documentation/x86/entry_64.txt |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86/entry_64.txt b/Documentation/x86/entry_64.txt
index 7869f14..bc7226e 100644
--- a/Documentation/x86/entry_64.txt
+++ b/Documentation/x86/entry_64.txt
@@ -27,9 +27,6 @@ Some of these entries are:
    magically-generated functions that make their way to do_IRQ with
    the interrupt number as a parameter.
 
- - emulate_vsyscall: int 0xcc, a special non-ABI entry used by
-   vsyscall emulation.
-
  - APIC interrupts: Various special-purpose interrupts for things
    like TLB shootdown.
 
-- 
1.7.4.4

