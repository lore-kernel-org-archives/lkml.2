Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401Ab2EUJUw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:20:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38548 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325Ab2EUJUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:20:51 -0400
Date: Mon, 21 May 2012 02:20:21 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-5bf8f6bfc950abe23927e0ff54cdb260d19d608e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jonas@southpole.se, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, jonas@southpole.se, anna-maria@glx-um.de
In-Reply-To: <20120518163106.333611712@glx-um.de>
References: <20120518163106.333611712@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] openrisc: Use generic time config
Git-Commit-ID: 5bf8f6bfc950abe23927e0ff54cdb260d19d608e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:20:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5bf8f6bfc950abe23927e0ff54cdb260d19d608e
Gitweb:     http://git.kernel.org/tip/5bf8f6bfc950abe23927e0ff54cdb260d19d608e
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:51 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:43 +0200

openrisc: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Acked-by: Jonas Bonn <jonas@southpole.se>
Link: http://lkml.kernel.org/r/20120518163106.333611712@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/openrisc/Kconfig |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index a478719..be04485 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -17,6 +17,7 @@ config OPENRISC
 	select GENERIC_IOMAP
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
+	select GENERIC_CLOCKEVENTS
 
 config MMU
 	def_bool y
@@ -46,9 +47,6 @@ config NO_IOPORT
 config GENERIC_GPIO
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 config TRACE_IRQFLAGS_SUPPORT
         def_bool y
 
