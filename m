Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472Ab2EUJRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:17:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38475 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303Ab2EUJRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:17:18 -0400
Date: Mon, 21 May 2012 02:16:59 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-d6412e2bdcd8dae1d502b49aff418275742d2887@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        monstr@monstr.eu, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        monstr@monstr.eu, tglx@linutronix.de, anna-maria@glx-um.de
In-Reply-To: <20120518163105.939597527@glx-um.de>
References: <20120518163105.939597527@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] microblaze: Use generic time config
Git-Commit-ID: d6412e2bdcd8dae1d502b49aff418275742d2887
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:17:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d6412e2bdcd8dae1d502b49aff418275742d2887
Gitweb:     http://git.kernel.org/tip/d6412e2bdcd8dae1d502b49aff418275742d2887
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:49 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:43 +0200

microblaze: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Michal Simek <monstr@monstr.eu>
Link: http://lkml.kernel.org/r/20120518163105.939597527@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/microblaze/Kconfig |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index ac22dc7..3e786ac 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -22,6 +22,7 @@ config MICROBLAZE
 	select GENERIC_PCI_IOMAP
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
+	select GENERIC_CLOCKEVENTS
 
 config SWAP
 	def_bool n
@@ -50,12 +51,6 @@ config GENERIC_HWEIGHT
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config GENERIC_TIME_VSYSCALL
-	def_bool n
-
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 config GENERIC_GPIO
 	def_bool y
 
