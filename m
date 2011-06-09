Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab1FINJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:09:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:33378 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757685Ab1FINJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:09:08 -0400
Date: Thu, 9 Jun 2011 13:09:01 GMT
From: tip-bot for Ralf Baechle <ralf@linux-mips.org>
Message-ID: <tip-8a118c3872945d54e0cacdea06c93527cdfb8782@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <20110601180611.061710714@duck.linux-mips.net>
References: <20110601180611.061710714@duck.linux-mips.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] pcpskr: MIPS: Make config dependencies finer grained
Git-Commit-ID: 8a118c3872945d54e0cacdea06c93527cdfb8782
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Jun 2011 13:09:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a118c3872945d54e0cacdea06c93527cdfb8782
Gitweb:     http://git.kernel.org/tip/8a118c3872945d54e0cacdea06c93527cdfb8782
Author:     Ralf Baechle <ralf@linux-mips.org>
AuthorDate: Wed, 1 Jun 2011 19:05:10 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Jun 2011 15:01:41 +0200

pcpskr: MIPS: Make config dependencies finer grained

Only the Siemens-Nixdorf RM series workstations and the Jazz family
workstations have PC speakers built in; Malta can connect one via the
infamous AMR connector with an AMR sound card or a little creativity.
So we don't want to offer the PC speaker driver on all MIPS systems.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Link: http://lkml.kernel.org/r/20110601180611.061710714@duck.linux-mips.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/mips/Kconfig |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index bf35bb6..45f7aac 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -5,7 +5,6 @@ config MIPS
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_IRQ_WORK
-	select HAVE_PCSPKR_PLATFORM
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select HAVE_ARCH_KGDB
@@ -186,6 +185,7 @@ config MACH_JAZZ
 	select CSRC_R4K
 	select DEFAULT_SGI_PARTITION if CPU_BIG_ENDIAN
 	select GENERIC_ISA_DMA
+	select HAVE_PCSPKR_PLATFORM
 	select IRQ_CPU
 	select I8253
 	select I8259
@@ -267,6 +267,7 @@ config MIPS_MALTA
 	select CSRC_R4K
 	select DMA_NONCOHERENT
 	select GENERIC_ISA_DMA
+	select HAVE_PCSPKR_PLATFORM
 	select IRQ_CPU
 	select IRQ_GIC
 	select HW_HAS_PCI
@@ -641,6 +642,7 @@ config SNI_RM
 	select DEFAULT_SGI_PARTITION if CPU_BIG_ENDIAN
 	select DMA_NONCOHERENT
 	select GENERIC_ISA_DMA
+	select HAVE_PCSPKR_PLATFORM
 	select HW_HAS_EISA
 	select HW_HAS_PCI
 	select IRQ_CPU
