Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172Ab0KROHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:07:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:41204 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756591Ab0KROHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:07:07 -0500
Date: Thu, 18 Nov 2010 14:06:37 GMT
From: tip-bot for Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, penberg@kernel.org, alan@lxorguk.ukuu.org.uk,
        kees.cook@canonical.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, kees.cook@canonical.com, penberg@kernel.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk, mingo@elte.hu
In-Reply-To: <1289931004-16066-1-git-send-email-kees.cook@canonical.com>
References: <1289931004-16066-1-git-send-email-kees.cook@canonical.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: Fix included-by file reference comments
Message-ID: <tip-79250af2d5953b69380a6319b493862bf4ece972@git.kernel.org>
Git-Commit-ID: 79250af2d5953b69380a6319b493862bf4ece972
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 18 Nov 2010 14:06:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79250af2d5953b69380a6319b493862bf4ece972
Gitweb:     http://git.kernel.org/tip/79250af2d5953b69380a6319b493862bf4ece972
Author:     Kees Cook <kees.cook@canonical.com>
AuthorDate: Tue, 16 Nov 2010 10:10:04 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 18 Nov 2010 09:58:54 +0100

x86: Fix included-by file reference comments

Adjust the paths for files that are including verify_cpu.S.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Kees Cook <kees.cook@canonical.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
LKML-Reference: <1289931004-16066-1-git-send-email-kees.cook@canonical.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/verify_cpu.S |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/verify_cpu.S b/arch/x86/kernel/verify_cpu.S
index 5644b4b..0edefc1 100644
--- a/arch/x86/kernel/verify_cpu.S
+++ b/arch/x86/kernel/verify_cpu.S
@@ -17,9 +17,9 @@
  *	file is included at various places and compiled in that context.
  *	This file is expected to run in 32bit code.  Currently:
  *
- *	arch/x86_64/boot/compressed/head_64.S: Boot cpu verification
- *	arch/x86_64/kernel/trampoline_64.S: secondary processor verfication
- *	arch/x86_64/kernel/head_32.S: processor startup
+ *	arch/x86/boot/compressed/head_64.S: Boot cpu verification
+ *	arch/x86/kernel/trampoline_64.S: secondary processor verfication
+ *	arch/x86/kernel/head_32.S: processor startup
  *
  *	verify_cpu, returns the status of longmode and SSE in register %eax.
  *		0: Success    1: Failure
