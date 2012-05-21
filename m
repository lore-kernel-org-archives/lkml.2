Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab2EUJUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:20:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38544 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387Ab2EUJUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:20:35 -0400
Date: Mon, 21 May 2012 02:15:18 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-97a1c1e918f6cf746352f565f5f2e00916309ede@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        takata@linux-m32r.org, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, takata@linux-m32r.org, anna-maria@glx-um.de
In-Reply-To: <20120518163105.678581749@glx-um.de>
References: <20120518163105.678581749@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] m32r: Use generic time config
Git-Commit-ID: 97a1c1e918f6cf746352f565f5f2e00916309ede
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:15:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  97a1c1e918f6cf746352f565f5f2e00916309ede
Gitweb:     http://git.kernel.org/tip/97a1c1e918f6cf746352f565f5f2e00916309ede
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:48 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:42 +0200

m32r: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Link: http://lkml.kernel.org/r/20120518163105.678581749@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m32r/Kconfig |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/m32r/Kconfig b/arch/m32r/Kconfig
index ef80a65..b638d5b 100644
--- a/arch/m32r/Kconfig
+++ b/arch/m32r/Kconfig
@@ -11,6 +11,7 @@ config M32R
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
+	select ARCH_USES_GETTIMEOFFSET
 
 config SBUS
 	bool
@@ -33,9 +34,6 @@ config HZ
 	int
 	default 100
 
-config ARCH_USES_GETTIMEOFFSET
-	def_bool y
-
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
