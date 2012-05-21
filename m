Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab2EUJKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:10:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38374 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab2EUJK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:10:28 -0400
Date: Mon, 21 May 2012 02:10:16 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-8d6af9914cacfbb60537cf5c46f9ebfc26ff2440@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        hskinnemoen@gmail.com, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        hskinnemoen@gmail.com, tglx@linutronix.de, anna-maria@glx-um.de
In-Reply-To: <20120518163104.889514832@glx-um.de>
References: <20120518163104.889514832@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] avr32: Use generic time config
Git-Commit-ID: 8d6af9914cacfbb60537cf5c46f9ebfc26ff2440
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:10:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d6af9914cacfbb60537cf5c46f9ebfc26ff2440
Gitweb:     http://git.kernel.org/tip/8d6af9914cacfbb60537cf5c46f9ebfc26ff2440
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:45 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:41 +0200

avr32: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Link: http://lkml.kernel.org/r/20120518163104.889514832@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/avr32/Kconfig |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/avr32/Kconfig b/arch/avr32/Kconfig
index 3dea7231..0bd13ab 100644
--- a/arch/avr32/Kconfig
+++ b/arch/avr32/Kconfig
@@ -12,6 +12,7 @@ config AVR32
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_CLOCKEVENTS
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
@@ -35,9 +36,6 @@ config TRACE_IRQFLAGS_SUPPORT
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool n
 
