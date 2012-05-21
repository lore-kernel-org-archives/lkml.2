Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab2EUJZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:25:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38628 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab2EUJZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:25:55 -0400
Date: Mon, 21 May 2012 02:25:23 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-875c9d09b5a6400d6882b0e6e828862a73ce739d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        richard@nod.at, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        richard@nod.at, tglx@linutronix.de, anna-maria@glx-um.de
In-Reply-To: <20120518163107.251597655@glx-um.de>
References: <20120518163107.251597655@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] um: Use generic time config
Git-Commit-ID: 875c9d09b5a6400d6882b0e6e828862a73ce739d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:25:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  875c9d09b5a6400d6882b0e6e828862a73ce739d
Gitweb:     http://git.kernel.org/tip/875c9d09b5a6400d6882b0e6e828862a73ce739d
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:55 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:44 +0200

um: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Acked-by: Richard Weinberger <richard@nod.at>
Link: http://lkml.kernel.org/r/20120518163107.251597655@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/um/Kconfig.common |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/um/Kconfig.common b/arch/um/Kconfig.common
index 20a49ba..806185d 100644
--- a/arch/um/Kconfig.common
+++ b/arch/um/Kconfig.common
@@ -10,6 +10,7 @@ config UML
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IO
+	select GENERIC_CLOCKEVENTS
 
 config MMU
 	bool
@@ -52,10 +53,6 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
-config GENERIC_CLOCKEVENTS
-	bool
-	default y
-
 # Used in kernel/irq/manage.c and include/linux/irq.h
 config IRQ_RELEASE_METHOD
 	bool
