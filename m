Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab2IEKw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:52:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56145 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab2IEKw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:52:56 -0400
Date: Wed, 5 Sep 2012 03:52:36 -0700
From: tip-bot for Josh Triplett <josh@joshtriplett.org>
Message-ID: <tip-be2f328d8616c81b86e4013974608776c317bbeb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        rdunlap@xenotime.net, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, josh@joshtriplett.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        rdunlap@xenotime.net, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, josh@joshtriplett.org, tglx@linutronix.de
In-Reply-To: <2521e983a63595cd7a331236d929577660f89c72.1346649518.git.josh@joshtriplett.org>
References: <2521e983a63595cd7a331236d929577660f89c72.1346649518.git.josh@joshtriplett.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86/Kconfig: Turn off CONFIG_BLK_DEV_RAM
Git-Commit-ID: be2f328d8616c81b86e4013974608776c317bbeb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 05 Sep 2012 03:52:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be2f328d8616c81b86e4013974608776c317bbeb
Gitweb:     http://git.kernel.org/tip/be2f328d8616c81b86e4013974608776c317bbeb
Author:     Josh Triplett <josh@joshtriplett.org>
AuthorDate: Sun, 2 Sep 2012 22:21:21 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 5 Sep 2012 10:43:11 +0200

x86/Kconfig: Turn off CONFIG_BLK_DEV_RAM

The vast majority of systems either use initramfs or mount a
root filesystem directly from the kernel.  Distros have
defaulted to initramfs for years.  Only highly specialized
systems would use an actual filesystem-image initrd at this
point, and such systems don't rely on defconfig anyway.  Drop
initrd support (and specifically RAM block device support) from
the defconfigs.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/2521e983a63595cd7a331236d929577660f89c72.1346649518.git.josh@joshtriplett.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/configs/i386_defconfig   |    2 --
 arch/x86/configs/x86_64_defconfig |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index d833bb6..a6533a2 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -144,8 +144,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_DEBUG_DEVRES=y
 CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_SIZE=16384
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
 CONFIG_BLK_DEV_SR_VENDOR=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 7ddcd99..18f3cc4 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -144,8 +144,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_DEBUG_DEVRES=y
 CONFIG_CONNECTOR=y
 CONFIG_BLK_DEV_LOOP=y
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_SIZE=16384
 CONFIG_BLK_DEV_SD=y
 CONFIG_BLK_DEV_SR=y
 CONFIG_BLK_DEV_SR_VENDOR=y
