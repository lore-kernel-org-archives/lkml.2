Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab2IEKv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:51:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56104 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122Ab2IEKv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:51:57 -0400
Date: Wed, 5 Sep 2012 03:51:40 -0700
From: tip-bot for Josh Triplett <josh@joshtriplett.org>
Message-ID: <tip-b92f885f31db782608c8b73942111238020b1f4a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        rdunlap@xenotime.net, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, josh@joshtriplett.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        rdunlap@xenotime.net, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, josh@joshtriplett.org, tglx@linutronix.de
In-Reply-To: <3aaff7a0af1320427952d411a21b8ded29747a1f.1346649518.git.josh@joshtriplett.org>
References: <3aaff7a0af1320427952d411a21b8ded29747a1f.1346649518.git.josh@joshtriplett.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86/Kconfig:
  Disable CONFIG_CRC_T10DIF in defconfigs
Git-Commit-ID: b92f885f31db782608c8b73942111238020b1f4a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 05 Sep 2012 03:51:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b92f885f31db782608c8b73942111238020b1f4a
Gitweb:     http://git.kernel.org/tip/b92f885f31db782608c8b73942111238020b1f4a
Author:     Josh Triplett <josh@joshtriplett.org>
AuthorDate: Sun, 2 Sep 2012 22:21:13 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 5 Sep 2012 10:43:11 +0200

x86/Kconfig: Disable CONFIG_CRC_T10DIF in defconfigs

CONFIG_CRC_T10DIF explicitly states that it exists only for use
by out-of-tree modules; anything in-kernel that needs it selects
it.  Thus, compile it out by default.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/3aaff7a0af1320427952d411a21b8ded29747a1f.1346649518.git.josh@joshtriplett.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/configs/i386_defconfig   |    1 -
 arch/x86/configs/x86_64_defconfig |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 2701b8a..d833bb6 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -311,4 +311,3 @@ CONFIG_SECURITY_SELINUX_BOOTPARAM=y
 CONFIG_SECURITY_SELINUX_DISABLE=y
 CONFIG_CRYPTO_AES_586=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
-CONFIG_CRC_T10DIF=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index c17614e..7ddcd99 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -309,4 +309,3 @@ CONFIG_SECURITY_SELINUX=y
 CONFIG_SECURITY_SELINUX_BOOTPARAM=y
 CONFIG_SECURITY_SELINUX_DISABLE=y
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
-CONFIG_CRC_T10DIF=y
