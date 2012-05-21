Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab2EUJWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:22:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38564 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab2EUJWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:22:50 -0400
Date: Mon, 21 May 2012 02:22:01 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-43229d1e0976e42069cbc8cab99273183becd0ec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, liqin.chen@sunplusct.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, liqin.chen@sunplusct.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, anna-maria@glx-um.de
In-Reply-To: <20120518163106.727602709@glx-um.de>
References: <20120518163106.727602709@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] score: Use generic time config
Git-Commit-ID: 43229d1e0976e42069cbc8cab99273183becd0ec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:22:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  43229d1e0976e42069cbc8cab99273183becd0ec
Gitweb:     http://git.kernel.org/tip/43229d1e0976e42069cbc8cab99273183becd0ec
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:52 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:44 +0200

score: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Link: http://lkml.kernel.org/r/20120518163106.727602709@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/score/Kconfig |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 4b28577..f5d3b32 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -9,6 +9,7 @@ config SCORE
        select HAVE_MEMBLOCK_NODE_MAP
        select ARCH_DISCARD_MEMBLOCK
        select GENERIC_CPU_DEVICES
+       select GENERIC_CLOCKEVENTS
 
 choice
 	prompt "System type"
@@ -51,9 +52,6 @@ config GENERIC_HWEIGHT
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 menu "Kernel type"
 
 config 32BIT
