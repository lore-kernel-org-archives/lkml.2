Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab1LHEgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 23:36:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55150 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab1LHEgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 23:36:13 -0500
Date: Wed, 7 Dec 2011 20:35:41 -0800
From: tip-bot for Don Zickus <dzickus@redhat.com>
Message-ID: <tip-4f941c57fe7e04e38c2401d53516bfd16038c9ab@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rdunlap@xenotime.net, tglx@linutronix.de, sfr@canb.auug.org.au,
        dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, tglx@linutronix.de, sfr@canb.auug.org.au,
        dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <20111207210630.GI1669@redhat.com>
References: <20111207210630.GI1669@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86, NMI: NMI selftest depends on the local apic
Git-Commit-ID: 4f941c57fe7e04e38c2401d53516bfd16038c9ab
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 07 Dec 2011 20:35:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f941c57fe7e04e38c2401d53516bfd16038c9ab
Gitweb:     http://git.kernel.org/tip/4f941c57fe7e04e38c2401d53516bfd16038c9ab
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Wed, 7 Dec 2011 16:06:30 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 7 Dec 2011 23:26:55 +0100

x86, NMI: NMI selftest depends on the local apic

The selftest doesn't work with out a local apic for now.

Reported-by: Randy Durlap <rdunlap@xenotime.net>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Link: http://lkml.kernel.org/r/20111207210630.GI1669@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 97da3c1..aa4158f 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -289,7 +289,7 @@ config DEBUG_STRICT_USER_COPY_CHECKS
 
 config DEBUG_NMI_SELFTEST
 	bool "NMI Selftest"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && X86_LOCAL_APIC
 	---help---
 	  Enabling this option turns on a quick NMI selftest to verify
 	  that the NMI behaves correctly.
