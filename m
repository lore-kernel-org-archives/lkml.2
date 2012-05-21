Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab2EUJUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:20:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38514 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409Ab2EUJT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:19:58 -0400
Date: Mon, 21 May 2012 02:19:31 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-b9ed27dfcd8b68de90dc285acd9e7c7113964888@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        benh@kernel.crashing.org, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, tglx@linutronix.de, anna-maria@glx-um.de
In-Reply-To: <20120518163106.464567389@glx-um.de>
References: <20120518163106.464567389@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] powerpc: Use generic time config
Git-Commit-ID: b9ed27dfcd8b68de90dc285acd9e7c7113964888
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:19:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9ed27dfcd8b68de90dc285acd9e7c7113964888
Gitweb:     http://git.kernel.org/tip/b9ed27dfcd8b68de90dc285acd9e7c7113964888
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:51 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:43 +0200

powerpc: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Link: http://lkml.kernel.org/r/20120518163106.464567389@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/powerpc/Kconfig |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index feab3ba..901215f 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -27,15 +27,6 @@ config MMU
 	bool
 	default y
 
-config GENERIC_CMOS_UPDATE
-	def_bool y
-
-config GENERIC_TIME_VSYSCALL
-	def_bool y
-
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool PPC64
 
@@ -144,6 +135,9 @@ config PPC
 	select HAVE_BPF_JIT if (PPC64 && NET)
 	select HAVE_ARCH_JUMP_LABEL
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_CMOS_UPDATE
+	select GENERIC_TIME_VSYSCALL
+	select GENERIC_CLOCKEVENTS
 
 config EARLY_PRINTK
 	bool
