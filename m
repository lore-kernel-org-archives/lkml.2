Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab2EUJIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:08:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38300 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab2EUJIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:08:47 -0400
Date: Mon, 21 May 2012 02:08:34 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-6e24f31eab6af44043e9d432bde415c1b4ca1a9e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        mattst88@gmail.com, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        mattst88@gmail.com, tglx@linutronix.de, anna-maria@glx-um.de
In-Reply-To: <20120518163107.510619939@glx-um.de>
References: <20120518163107.510619939@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] alpha: Use generic time config
Git-Commit-ID: 6e24f31eab6af44043e9d432bde415c1b4ca1a9e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:08:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e24f31eab6af44043e9d432bde415c1b4ca1a9e
Gitweb:     http://git.kernel.org/tip/6e24f31eab6af44043e9d432bde415c1b4ca1a9e
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:56 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:41 +0200

alpha: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Acked-by: Matt Turner <mattst88@gmail.com>
Link: http://lkml.kernel.org/r/20120518163107.510619939@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/alpha/Kconfig |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 22e58a9..77ba268 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -15,6 +15,7 @@ config ALPHA
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_CMOS_UPDATE
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
@@ -47,9 +48,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config GENERIC_CMOS_UPDATE
-        def_bool y
-
 config GENERIC_GPIO
 	bool
 
