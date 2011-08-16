Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab1HPP3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 11:29:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:44499 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab1HPP3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 11:29:20 -0400
Date: Tue, 16 Aug 2011 15:29:06 GMT
From: tip-bot for Cesar Eduardo Barros <cesarb@cesarb.net>
Message-ID: <tip-664ef2123f4abc05857bf9b2dcccb800fa6fce26@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, cesarb@cesarb.net, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com,
        luto@MIT.EDU
Reply-To: mingo@redhat.com, hpa@zytor.com, cesarb@cesarb.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        luto@MIT.EDU
In-Reply-To: <1313447210-9149-1-git-send-email-cesarb@cesarb.net>
References: <1313447210-9149-1-git-send-email-cesarb@cesarb.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86-64, doc: Remove int 0xcc from entry_64.S documentation
Git-Commit-ID: 664ef2123f4abc05857bf9b2dcccb800fa6fce26
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Aug 2011 15:29:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  664ef2123f4abc05857bf9b2dcccb800fa6fce26
Gitweb:     http://git.kernel.org/tip/664ef2123f4abc05857bf9b2dcccb800fa6fce26
Author:     Cesar Eduardo Barros <cesarb@cesarb.net>
AuthorDate: Mon, 15 Aug 2011 19:26:50 -0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 16 Aug 2011 08:04:08 -0700

x86-64, doc: Remove int 0xcc from entry_64.S documentation

Commit 3ae36655b97a03fa1decf72f04078ef945647c1a (x86-64: Rework vsyscall
emulation and add vsyscall= parameter) removed the special use of the
0xcc IDT vector.

Remove it from Documentation/x86/entry_64.txt also.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Acked-by: Andy Lutomirski <luto@MIT.EDU>
Link: http://lkml.kernel.org/r/1313447210-9149-1-git-send-email-cesarb@cesarb.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
 
