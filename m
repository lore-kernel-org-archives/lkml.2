Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab2HRQZL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 12:25:11 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62696 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab2HRQYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 12:24:16 -0400
From: Fabio Estevam <festevam@gmail.com>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        Mike Frysinger <vapier@gentoo.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>
Subject: [PATCH 03/11] blackfin: defconfig: Remove CONFIG_MISC_DEVICES
Date: Sat, 18 Aug 2012 13:23:47 -0300
Message-Id: <1345307035-3545-3-git-send-email-festevam@gmail.com>
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

Cc: Mike Frysinger <vapier@gentoo.org>
Cc: <uclinux-dist-devel@blackfin.uclinux.org>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 arch/blackfin/configs/BlackStamp_defconfig |    1 -
 arch/blackfin/configs/H8606_defconfig      |    1 -
 arch/blackfin/configs/SRV1_defconfig       |    1 -
 3 files changed, 3 deletions(-)

diff --git a/arch/blackfin/configs/BlackStamp_defconfig b/arch/blackfin/configs/BlackStamp_defconfig
index 7b982d0..8f94e54 100644
--- a/arch/blackfin/configs/BlackStamp_defconfig
+++ b/arch/blackfin/configs/BlackStamp_defconfig
@@ -58,7 +58,6 @@ CONFIG_MTD_M25P80=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_NBD=y
 CONFIG_BLK_DEV_RAM=y
-CONFIG_MISC_DEVICES=y
 CONFIG_EEPROM_AT25=y
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
diff --git a/arch/blackfin/configs/H8606_defconfig b/arch/blackfin/configs/H8606_defconfig
index a26436b..fbdca43 100644
--- a/arch/blackfin/configs/H8606_defconfig
+++ b/arch/blackfin/configs/H8606_defconfig
@@ -45,7 +45,6 @@ CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_M25P80=y
 # CONFIG_M25PXX_USE_FAST_READ is not set
 CONFIG_BLK_DEV_RAM=y
-CONFIG_MISC_DEVICES=y
 CONFIG_EEPROM_AT25=y
 CONFIG_NETDEVICES=y
 CONFIG_NET_ETHERNET=y
diff --git a/arch/blackfin/configs/SRV1_defconfig b/arch/blackfin/configs/SRV1_defconfig
index 0520c16..2fa7b6d 100644
--- a/arch/blackfin/configs/SRV1_defconfig
+++ b/arch/blackfin/configs/SRV1_defconfig
@@ -48,7 +48,6 @@ CONFIG_MTD_COMPLEX_MAPPINGS=y
 CONFIG_MTD_UCLINUX=y
 CONFIG_MTD_NAND=m
 CONFIG_BLK_DEV_RAM=y
-CONFIG_MISC_DEVICES=y
 CONFIG_EEPROM_AT25=m
 CONFIG_NETDEVICES=y
 # CONFIG_NETDEV_1000 is not set
-- 
1.7.9.5

