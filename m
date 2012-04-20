Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab2DTWHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:07:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34193 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333Ab2DTWHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:07:22 -0400
Date: Fri, 20 Apr 2012 15:07:11 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-447657e31235c692f579c639250317c7f565cd0d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
In-Reply-To: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
References: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, extable:
  Remove the now-unused __ASM_EX_SEC macros
Git-Commit-ID: 447657e31235c692f579c639250317c7f565cd0d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Apr 2012 15:07:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  447657e31235c692f579c639250317c7f565cd0d
Gitweb:     http://git.kernel.org/tip/447657e31235c692f579c639250317c7f565cd0d
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 20 Apr 2012 12:20:30 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Apr 2012 13:51:40 -0700

x86, extable: Remove the now-unused __ASM_EX_SEC macros

Nothing should use them anymore; only _ASM_EXTABLE() should ever be
used.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: David Daney <david.daney@cavium.com>
Link: http://lkml.kernel.org/r/CA%2B55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com
---
 arch/x86/include/asm/asm.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index ff3f6bf..53dce41 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -4,11 +4,9 @@
 #ifdef __ASSEMBLY__
 # define __ASM_FORM(x)	x
 # define __ASM_FORM_COMMA(x) x,
-# define __ASM_EX_SEC	.section __ex_table, "a"
 #else
 # define __ASM_FORM(x)	" " #x " "
 # define __ASM_FORM_COMMA(x) " " #x ","
-# define __ASM_EX_SEC	" .section __ex_table,\"a\"\n"
 #endif
 
 #ifdef CONFIG_X86_32
