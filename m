Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab2EUJZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:25:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38590 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab2EUJZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:25:01 -0400
Date: Mon, 21 May 2012 02:24:33 -0700
From: tip-bot for Anna-Maria Gleixner <anna-maria@glx-um.de>
Message-ID: <tip-4ec008d630d9d96579b5911c140bb8de2aa68f0e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        cmetcalf@tilera.com, tglx@linutronix.de, anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cmetcalf@tilera.com, tglx@linutronix.de, anna-maria@glx-um.de
In-Reply-To: <20120518163107.122560037@glx-um.de>
References: <20120518163107.122560037@glx-um.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] tile: Use generic time config
Git-Commit-ID: 4ec008d630d9d96579b5911c140bb8de2aa68f0e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:24:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4ec008d630d9d96579b5911c140bb8de2aa68f0e
Gitweb:     http://git.kernel.org/tip/4ec008d630d9d96579b5911c140bb8de2aa68f0e
Author:     Anna-Maria Gleixner <anna-maria@glx-um.de>
AuthorDate: Fri, 18 May 2012 16:45:54 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:44 +0200

tile: Use generic time config

Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Link: http://lkml.kernel.org/r/20120518163107.122560037@glx-um.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/tile/Kconfig |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 96033e2..b56772c 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -13,6 +13,7 @@ config TILE
 	select GENERIC_IRQ_SHOW
 	select SYS_HYPERVISOR
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_CLOCKEVENTS
 
 # FIXME: investigate whether we need/want these options.
 #	select HAVE_IOREMAP_PROT
@@ -46,9 +47,6 @@ config NEED_PER_CPU_PAGE_FIRST_CHUNK
 config SYS_SUPPORTS_HUGETLBFS
 	def_bool y
 
-config GENERIC_CLOCKEVENTS
-	def_bool y
-
 # FIXME: tilegx can implement a more efficient rwsem.
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
