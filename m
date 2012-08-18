Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037Ab2HRQZX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 12:25:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53081 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab2HRQYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 12:24:22 -0400
From: Fabio Estevam <festevam@gmail.com>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 06/11] m68k: defconfig: Remove CONFIG_MISC_DEVICES
Date: Sat, 18 Aug 2012 13:23:50 -0300
Message-Id: <1345307035-3545-6-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345307035-3545-1-git-send-email-festevam@gmail.com>
References: <1345307035-3545-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 7c5763 (drivers:misc: Remove MISC_DEVICES config option) removed 
CONFIG_MISC_DEVICES option, so remove the occurrences from the config files 
as well

Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 arch/m68k/configs/m5208evb_defconfig |    1 -
 arch/m68k/configs/m5249evb_defconfig |    1 -
 arch/m68k/configs/m5272c3_defconfig  |    1 -
 arch/m68k/configs/m5275evb_defconfig |    1 -
 arch/m68k/configs/m5307c3_defconfig  |    1 -
 arch/m68k/configs/m5407c3_defconfig  |    1 -
 6 files changed, 6 deletions(-)

diff --git a/arch/m68k/configs/m5208evb_defconfig b/arch/m68k/configs/m5208evb_defconfig
index c161682..dd28495 100644
--- a/arch/m68k/configs/m5208evb_defconfig
+++ b/arch/m68k/configs/m5208evb_defconfig
@@ -46,7 +46,6 @@ CONFIG_MTD_BLOCK=y
 CONFIG_MTD_RAM=y
 CONFIG_MTD_UCLINUX=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_FEC=y
diff --git a/arch/m68k/configs/m5249evb_defconfig b/arch/m68k/configs/m5249evb_defconfig
index a6599e4..6c34506 100644
--- a/arch/m68k/configs/m5249evb_defconfig
+++ b/arch/m68k/configs/m5249evb_defconfig
@@ -44,7 +44,6 @@ CONFIG_MTD_BLOCK=y
 CONFIG_MTD_RAM=y
 CONFIG_MTD_UCLINUX=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 # CONFIG_NETDEV_1000 is not set
diff --git a/arch/m68k/configs/m5272c3_defconfig b/arch/m68k/configs/m5272c3_defconfig
index 3fa60a5..179771d 100644
--- a/arch/m68k/configs/m5272c3_defconfig
+++ b/arch/m68k/configs/m5272c3_defconfig
@@ -42,7 +42,6 @@ CONFIG_MTD_BLOCK=y
 CONFIG_MTD_RAM=y
 CONFIG_MTD_UCLINUX=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_FEC=y
diff --git a/arch/m68k/configs/m5275evb_defconfig b/arch/m68k/configs/m5275evb_defconfig
index a1230e8..b963485 100644
--- a/arch/m68k/configs/m5275evb_defconfig
+++ b/arch/m68k/configs/m5275evb_defconfig
@@ -45,7 +45,6 @@ CONFIG_MTD_BLOCK=y
 CONFIG_MTD_RAM=y
 CONFIG_MTD_UCLINUX=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 CONFIG_FEC=y
diff --git a/arch/m68k/configs/m5307c3_defconfig b/arch/m68k/configs/m5307c3_defconfig
index 43795f4..74a633a 100644
--- a/arch/m68k/configs/m5307c3_defconfig
+++ b/arch/m68k/configs/m5307c3_defconfig
@@ -44,7 +44,6 @@ CONFIG_MTD_BLOCK=y
 CONFIG_MTD_RAM=y
 CONFIG_MTD_UCLINUX=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 # CONFIG_NETDEV_1000 is not set
diff --git a/arch/m68k/configs/m5407c3_defconfig b/arch/m68k/configs/m5407c3_defconfig
index 72746c5..86101f1 100644
--- a/arch/m68k/configs/m5407c3_defconfig
+++ b/arch/m68k/configs/m5407c3_defconfig
@@ -44,7 +44,6 @@ CONFIG_MTD_BLOCK=y
 CONFIG_MTD_RAM=y
 CONFIG_MTD_UCLINUX=y
 CONFIG_BLK_DEV_RAM=y
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
 # CONFIG_NETDEV_1000 is not set
-- 
1.7.9.5

