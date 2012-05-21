Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287Ab2EUJOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:14:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38439 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab2EUJOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:14:42 -0400
Date: Mon, 21 May 2012 02:14:27 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-21b19710a2fbbec3d81e7cb4d74a8ea4f0acfeea@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tony.luck@intel.com, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, tony.luck@intel.com, anna-maria@glx-um.de
In-Reply-To: <20120518163105.547603093@glx-um.de>
References: <20120518163105.547603093@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] ia64: Use generic time config
Git-Commit-ID: 21b19710a2fbbec3d81e7cb4d74a8ea4f0acfeea
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:14:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  21b19710a2fbbec3d81e7cb4d74a8ea4f0acfeea
Gitweb:     http://git.kernel.org/tip/21b19710a2fbbec3d81e7cb4d74a8ea4f0acfeea
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:48 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:42 +0200

ia64: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/20120518163105.547603093@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/ia64/Kconfig |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index bd72669..9f9d57b 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -33,6 +33,8 @@ config IA64
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
+	select ARCH_CLOCKSOURCE_DATA
+	select GENERIC_TIME_VSYSCALL
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
@@ -88,10 +90,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_TIME_VSYSCALL
-	bool
-	default y
-
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool y
 
@@ -106,9 +104,6 @@ config EFI
 	bool
 	default y
 
-config ARCH_CLOCKSOURCE_DATA
-	def_bool y
-
 config SCHED_OMIT_FRAME_POINTER
 	bool
 	default y
