Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525Ab1CDQBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 11:01:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:50679 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab1CDQBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 11:01:20 -0500
Date: Fri, 4 Mar 2011 16:00:59 GMT
From: tip-bot for Jan Beulich <JBeulich@novell.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@novell.com, JBeulich@novell.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <4D710BFC0200007800034F3A@vpn.id2.novell.com>
References: <4D710BFC0200007800034F3A@vpn.id2.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Remove dead config option X86_CPU
Message-ID: <tip-24a2a35a18ebc4e143e86ad3fda50ee78de30d06@git.kernel.org>
Git-Commit-ID: 24a2a35a18ebc4e143e86ad3fda50ee78de30d06
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 04 Mar 2011 16:01:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  24a2a35a18ebc4e143e86ad3fda50ee78de30d06
Gitweb:     http://git.kernel.org/tip/24a2a35a18ebc4e143e86ad3fda50ee78de30d06
Author:     Jan Beulich <JBeulich@novell.com>
AuthorDate: Fri, 4 Mar 2011 14:57:48 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 4 Mar 2011 16:34:33 +0100

x86: Remove dead config option X86_CPU

This isn't being referenced anywhere, and the selects done from
it can be easily done together with all the other X86 ones

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <4D710BFC0200007800034F3A@vpn.id2.novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig     |    2 ++
 arch/x86/Kconfig.cpu |    5 -----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d5ed94d..43214e3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -64,6 +64,8 @@ config X86
 	select HAVE_TEXT_POKE_SMP
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
+	select GENERIC_FIND_FIRST_BIT
+	select GENERIC_FIND_NEXT_BIT
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
 	select USE_GENERIC_SMP_HELPERS if SMP
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 283c5a6..ed47e6e 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -294,11 +294,6 @@ config X86_GENERIC
 
 endif
 
-config X86_CPU
-	def_bool y
-	select GENERIC_FIND_FIRST_BIT
-	select GENERIC_FIND_NEXT_BIT
-
 #
 # Define implied options from the CPU selection here
 config X86_INTERNODE_CACHE_SHIFT
