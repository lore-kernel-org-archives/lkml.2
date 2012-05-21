Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab2EUJQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:16:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38466 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320Ab2EUJQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:16:27 -0400
Date: Mon, 21 May 2012 02:16:09 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-60a5e4c3d3df6ec9006576935953dde6cf94f02a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        geert@linux-m68k.org, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        geert@linux-m68k.org, tglx@linutronix.de, anna-maria@glx-um.de
In-Reply-To: <20120518163105.808606368@glx-um.de>
References: <20120518163105.808606368@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] m68k: Use generic time config
Git-Commit-ID: 60a5e4c3d3df6ec9006576935953dde6cf94f02a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:16:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60a5e4c3d3df6ec9006576935953dde6cf94f02a
Gitweb:     http://git.kernel.org/tip/60a5e4c3d3df6ec9006576935953dde6cf94f02a
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:49 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:42 +0200

m68k: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Link: http://lkml.kernel.org/r/20120518163105.808606368@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68k/Kconfig |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index d318c60..2f4b0f0 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -8,6 +8,7 @@ config M68K
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select GENERIC_CPU_DEVICES
 	select FPU if MMU
+	select ARCH_USES_GETTIMEOFFSET if MMU && !COLDFIRE
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
@@ -22,9 +23,6 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	bool
 
-config GENERIC_CLOCKEVENTS
-	bool
-
 config GENERIC_GPIO
 	bool
 
@@ -43,9 +41,6 @@ config TIME_LOW_RES
 	bool
 	default y
 
-config ARCH_USES_GETTIMEOFFSET
-	def_bool MMU && !COLDFIRE
-
 config NO_IOPORT
 	def_bool y
 
