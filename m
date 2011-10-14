Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab1JNM3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:29:20 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:58144 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756349Ab1JNM3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:29:19 -0400
Subject: [PATCH 07/21] score: drop unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:28:22 +0200
Message-ID: <1318595302.6132.64.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 arch/score/Kconfig |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/arch/score/Kconfig b/arch/score/Kconfig
index 288add8..df169e8 100644
--- a/arch/score/Kconfig
+++ b/arch/score/Kconfig
@@ -52,16 +52,6 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
-config SCHED_NO_NO_OMIT_FRAME_POINTER
-	def_bool y
-
-config GENERIC_SYSCALL_TABLE
-	def_bool y
-
-config SCORE_L1_CACHE_SHIFT
-	int
-	default "4"
-
 menu "Kernel type"
 
 config 32BIT
@@ -96,15 +86,6 @@ config STACKTRACE_SUPPORT
 
 source "init/Kconfig"
 
-config PROBE_INITRD_HEADER
-	bool "Probe initrd header created by addinitrd"
-	depends on BLK_DEV_INITRD
-	help
-	  Probe initrd header at the last page of kernel image.
-	  Say Y here if you are using arch/score/boot/addinitrd.c to
-	  add initrd or initramfs image to the kernel image.
-	  Otherwise, say N.
-
 config MMU
 	def_bool y
 
-- 
1.7.4.4




