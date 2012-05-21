Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab2EUJTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:19:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38492 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169Ab2EUJT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:19:28 -0400
Date: Mon, 21 May 2012 02:18:41 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-ea5332098e68e2380429ce8025996fad61ca28a6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dhowells@redhat.com, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, tglx@linutronix.de, anna-maria@glx-um.de
In-Reply-To: <20120518163106.201635926@glx-um.de>
References: <20120518163106.201635926@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] mn10300: Use generic time config
Git-Commit-ID: ea5332098e68e2380429ce8025996fad61ca28a6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:18:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea5332098e68e2380429ce8025996fad61ca28a6
Gitweb:     http://git.kernel.org/tip/ea5332098e68e2380429ce8025996fad61ca28a6
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:50 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:43 +0200

mn10300: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: David Howells <dhowells@redhat.com>
Link: http://lkml.kernel.org/r/20120518163106.201635926@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mn10300/Kconfig |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 3aa3de0..7f78057 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -6,6 +6,7 @@ config MN10300
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_KGDB
 	select HAVE_NMI_WATCHDOG if MN10300_WD_TIMER
+	select GENERIC_CLOCKEVENTS
 
 config AM33_2
 	def_bool n
@@ -42,15 +43,9 @@ config RWSEM_XCHGADD_ALGORITHM
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config GENERIC_CMOS_UPDATE
-        def_bool n
-
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 config GENERIC_BUG
 	def_bool y
 
