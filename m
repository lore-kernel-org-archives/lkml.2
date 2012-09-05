Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627Ab2IEKvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:51:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56058 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab2IEKvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:51:04 -0400
Date: Wed, 5 Sep 2012 03:50:44 -0700
From: tip-bot for Josh Triplett <josh@joshtriplett.org>
Message-ID: <tip-3fe2cb8f9e9486980ff03d7e020781cfdb028ffa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        rdunlap@xenotime.net, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, josh@joshtriplett.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        rdunlap@xenotime.net, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, josh@joshtriplett.org, tglx@linutronix.de
In-Reply-To: <bd8a359506b7e1287c680823de16d67608ec52fe.1346649518.git.josh@joshtriplett.org>
References: <bd8a359506b7e1287c680823de16d67608ec52fe.1346649518.git.josh@joshtriplett.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86/Kconfig: Switch to ext4 in defconfigs
Git-Commit-ID: 3fe2cb8f9e9486980ff03d7e020781cfdb028ffa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 05 Sep 2012 03:50:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3fe2cb8f9e9486980ff03d7e020781cfdb028ffa
Gitweb:     http://git.kernel.org/tip/3fe2cb8f9e9486980ff03d7e020781cfdb028ffa
Author:     Josh Triplett <josh@joshtriplett.org>
AuthorDate: Sun, 2 Sep 2012 22:21:05 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 5 Sep 2012 10:43:10 +0200

x86/Kconfig: Switch to ext4 in defconfigs

The current x86 and x86-64 defconfigs do not enable ext4, which
most current distributions default to.  Switch the defconfigs to
ext4, so they will boot on current systems without additional
configuration.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/bd8a359506b7e1287c680823de16d67608ec52fe.1346649518.git.josh@joshtriplett.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/configs/i386_defconfig   |    7 +++----
 arch/x86/configs/x86_64_defconfig |    7 +++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 1903408..2701b8a 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -260,10 +260,9 @@ CONFIG_RTC_CLASS=y
 CONFIG_DMADEVICES=y
 CONFIG_EEEPC_LAPTOP=y
 CONFIG_EFI_VARS=y
-CONFIG_EXT3_FS=y
-# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
-CONFIG_EXT3_FS_POSIX_ACL=y
-CONFIG_EXT3_FS_SECURITY=y
+CONFIG_EXT4_FS=y
+CONFIG_EXT4_FS_POSIX_ACL=y
+CONFIG_EXT4_FS_SECURITY=y
 CONFIG_QUOTA=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index c2c0448..c17614e 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -260,10 +260,9 @@ CONFIG_AMD_IOMMU_STATS=y
 CONFIG_INTEL_IOMMU=y
 # CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
 CONFIG_EFI_VARS=y
-CONFIG_EXT3_FS=y
-# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
-CONFIG_EXT3_FS_POSIX_ACL=y
-CONFIG_EXT3_FS_SECURITY=y
+CONFIG_EXT4_FS=y
+CONFIG_EXT4_FS_POSIX_ACL=y
+CONFIG_EXT4_FS_SECURITY=y
 CONFIG_QUOTA=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
