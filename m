Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab2EUJXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:23:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38572 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab2EUJXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:23:22 -0400
Date: Mon, 21 May 2012 02:22:52 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-8cf200d8d01e71e8708a883a9cd0439cda6c2432@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        lethal@linux-sh.org, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, lethal@linux-sh.org, anna-maria@glx-um.de
In-Reply-To: <20120518163106.857566635@glx-um.de>
References: <20120518163106.857566635@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] sh: Use generic time config
Git-Commit-ID: 8cf200d8d01e71e8708a883a9cd0439cda6c2432
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:22:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8cf200d8d01e71e8708a883a9cd0439cda6c2432
Gitweb:     http://git.kernel.org/tip/8cf200d8d01e71e8708a883a9cd0439cda6c2432
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:53 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:44 +0200

sh: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Link: http://lkml.kernel.org/r/20120518163106.857566635@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/sh/Kconfig |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index ff9e033..cffd8b0 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -28,6 +28,8 @@ config SUPERH
 	select RTC_LIB
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_SHOW
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_CMOS_UPDATE if SH_SH03 || SH_DREAMCAST
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
@@ -86,16 +88,6 @@ config GENERIC_GPIO
 config GENERIC_CALIBRATE_DELAY
 	bool
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	bool
-
-config GENERIC_CMOS_UPDATE
-	def_bool y
-	depends on SH_SH03 || SH_DREAMCAST
-
 config GENERIC_LOCKBREAK
 	def_bool y
 	depends on SMP && PREEMPT
