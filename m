Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab1DNKGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:06:11 -0400
Received: from relay.parallels.com ([195.214.232.42]:49988 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758668Ab1DNKGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:06:09 -0400
Subject: [PATCH] x86, defconfig: add ext4 filesystem
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Jan Kara <jack@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 14 Apr 2011 14:05:57 +0400
Message-ID: <20110414100557.10017.60174.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ext4 filesystem to x86/x86_64 default configs.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 arch/x86/configs/i386_defconfig   |    4 ++++
 arch/x86/configs/x86_64_defconfig |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 6f98726..0f2e5e6 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -273,6 +273,10 @@ CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
 CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_EXT3_FS_SECURITY=y
+CONFIG_EXT4_FS=y
+# CONFIG_EXT4_USE_FOR_EXT23 is not set
+CONFIG_EXT4_FS_POSIX_ACL=y
+CONFIG_EXT4_FS_SECURITY=y
 CONFIG_QUOTA=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index ee01a9d..b80847b 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -274,6 +274,10 @@ CONFIG_EXT3_FS=y
 # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
 CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_EXT3_FS_SECURITY=y
+CONFIG_EXT4_FS=y
+# CONFIG_EXT4_USE_FOR_EXT23 is not set
+CONFIG_EXT4_FS_POSIX_ACL=y
+CONFIG_EXT4_FS_SECURITY=y
 CONFIG_QUOTA=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set

