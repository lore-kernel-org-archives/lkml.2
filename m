Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab2EUJS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:18:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38485 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328Ab2EUJSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:18:24 -0400
Date: Mon, 21 May 2012 02:17:50 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-cde1794b069f44ca02f3f4f50a903e9361132244@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ralf@linux-mips.org, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, tglx@linutronix.de, anna-maria@glx-um.de
In-Reply-To: <20120518163106.073559820@glx-um.de>
References: <20120518163106.073559820@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] mips: Use generic time config
Git-Commit-ID: cde1794b069f44ca02f3f4f50a903e9361132244
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:17:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cde1794b069f44ca02f3f4f50a903e9361132244
Gitweb:     http://git.kernel.org/tip/cde1794b069f44ca02f3f4f50a903e9361132244
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:50 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:43 +0200

mips: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Link: http://lkml.kernel.org/r/20120518163106.073559820@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mips/Kconfig |   13 ++-----------
 1 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ce30e2f..c9c330b 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -29,6 +29,8 @@ config MIPS
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select ARCH_DISCARD_MEMBLOCK
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_CMOS_UPDATE
 
 menu "Machine selection"
 
@@ -856,14 +858,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_CLOCKEVENTS
-	bool
-	default y
-
-config GENERIC_CMOS_UPDATE
-	bool
-	default y
-
 config SCHED_OMIT_FRAME_POINTER
 	bool
 	default y
@@ -2050,9 +2044,6 @@ config CPU_HAS_SYNC
 	depends on !CPU_R3000
 	default y
 
-config GENERIC_CLOCKEVENTS_BROADCAST
-	bool
-
 #
 # CPU non-features
 #
