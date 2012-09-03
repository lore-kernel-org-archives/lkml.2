Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2ICFV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:21:59 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60246 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab2ICFVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:21:10 -0400
X-Originating-IP: 217.70.178.139
X-Originating-IP: 50.43.46.74
Date: Sun, 2 Sep 2012 22:21:05 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 2/5] x86: Switch to ext4 in defconfigs
Message-ID: <bd8a359506b7e1287c680823de16d67608ec52fe.1346649518.git.josh@joshtriplett.org>
References: <cover.1346649518.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1346649518.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current x86 and x86-64 defconfigs do not enable ext4, which most
current distributions default to.  Switch the defconfigs to ext4, so
they will boot on current systems without additional configuration.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
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
-- 
1.7.10.4

