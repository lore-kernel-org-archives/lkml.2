Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab2EUJN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:13:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38412 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2EUJNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:13:54 -0400
Date: Mon, 21 May 2012 02:13:37 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-24a6f35e192ed54205024742eb8a4a2f99c1da9d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, anna-maria@glx-um.de, rkuo@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, anna-maria@glx-um.de, rkuo@codeaurora.org
In-Reply-To: <20120518163105.416570309@glx-um.de>
References: <20120518163105.416570309@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] hexagon: Use generic time config
Git-Commit-ID: 24a6f35e192ed54205024742eb8a4a2f99c1da9d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:13:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  24a6f35e192ed54205024742eb8a4a2f99c1da9d
Gitweb:     http://git.kernel.org/tip/24a6f35e192ed54205024742eb8a4a2f99c1da9d
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:47 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:42 +0200

hexagon: Use generic time config

config GENERIC_TIME not longer used.

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Richard Kuo <rkuo@codeaurora.org>
Link: http://lkml.kernel.org/r/20120518163105.416570309@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/hexagon/Kconfig |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/hexagon/Kconfig b/arch/hexagon/Kconfig
index 9059e39..7727ed9 100644
--- a/arch/hexagon/Kconfig
+++ b/arch/hexagon/Kconfig
@@ -28,6 +28,9 @@ config HEXAGON
 	select NO_IOPORT
 	select GENERIC_IOMAP
 	# mostly generic routines, with some accelerated ones
+	select KTIME_SCALAR
+	select GENERIC_CLOCKEVENTS
+	select GENERIC_CLOCKEVENTS_BROADCAST
 	---help---
 	  Qualcomm Hexagon is a processor architecture designed for high
 	  performance and low power across a wide variety of applications.
@@ -56,9 +59,6 @@ config PCI
 config EARLY_PRINTK
 	def_bool y
 
-config KTIME_SCALAR
-	def_bool y
-
 config MMU
 	def_bool y
 
@@ -98,15 +98,6 @@ config GENERIC_FIND_NEXT_BIT
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
-config GENERIC_CLOCKEVENTS_BROADCAST
-	def_bool y
-
 config STACKTRACE_SUPPORT
 	def_bool y
 	select STACKTRACE
