Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab2EUJNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:13:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38401 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab2EUJNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:13:04 -0400
Date: Mon, 21 May 2012 02:12:46 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-5227b636eca4226287e43fc1de1e09a694bcaa34@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jesper.nilsson@axis.com, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jesper.nilsson@axis.com, tglx@linutronix.de, anna-maria@glx-um.de
In-Reply-To: <20120518163105.286556794@glx-um.de>
References: <20120518163105.286556794@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] cris: Use generic time config
Git-Commit-ID: 5227b636eca4226287e43fc1de1e09a694bcaa34
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:12:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5227b636eca4226287e43fc1de1e09a694bcaa34
Gitweb:     http://git.kernel.org/tip/5227b636eca4226287e43fc1de1e09a694bcaa34
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:46 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:42 +0200

cris: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Link: http://lkml.kernel.org/r/20120518163105.286556794@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/cris/Kconfig |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index b3abfb0..4a63e7e 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -13,12 +13,6 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
-config GENERIC_CMOS_UPDATE
-	def_bool y
-
-config ARCH_USES_GETTIMEOFFSET
-	def_bool n
-
 config ARCH_HAS_ILOG2_U32
 	bool
 	default n
@@ -49,6 +43,7 @@ config CRIS
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
+	select GENERIC_CMOS_UPDATE
 
 config HZ
 	int
