Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab2HRQZI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 12:25:08 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:62696 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab2HRQYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 12:24:18 -0400
From: Fabio Estevam <festevam@gmail.com>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        Mark Salter <msalter@redhat.com>
Subject: [PATCH 04/11] C6X: defconfig: Remove CONFIG_MISC_DEVICES
Date: Sat, 18 Aug 2012 13:23:48 -0300
Message-Id: <1345307035-3545-4-git-send-email-festevam@gmail.com>
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

Cc: Mark Salter <msalter@redhat.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 arch/c6x/configs/dsk6455_defconfig  |    1 -
 arch/c6x/configs/evmc6457_defconfig |    1 -
 arch/c6x/configs/evmc6472_defconfig |    1 -
 arch/c6x/configs/evmc6474_defconfig |    1 -
 arch/c6x/configs/evmc6678_defconfig |    1 -
 5 files changed, 5 deletions(-)

diff --git a/arch/c6x/configs/dsk6455_defconfig b/arch/c6x/configs/dsk6455_defconfig
index 4663487..bdd505f 100644
--- a/arch/c6x/configs/dsk6455_defconfig
+++ b/arch/c6x/configs/dsk6455_defconfig
@@ -25,7 +25,6 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=2
 CONFIG_BLK_DEV_RAM_SIZE=17000
-CONFIG_MISC_DEVICES=y
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
diff --git a/arch/c6x/configs/evmc6457_defconfig b/arch/c6x/configs/evmc6457_defconfig
index bba40e1..259cf2c 100644
--- a/arch/c6x/configs/evmc6457_defconfig
+++ b/arch/c6x/configs/evmc6457_defconfig
@@ -26,7 +26,6 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=2
 CONFIG_BLK_DEV_RAM_SIZE=17000
-CONFIG_MISC_DEVICES=y
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
diff --git a/arch/c6x/configs/evmc6472_defconfig b/arch/c6x/configs/evmc6472_defconfig
index 8c46155..fc26531 100644
--- a/arch/c6x/configs/evmc6472_defconfig
+++ b/arch/c6x/configs/evmc6472_defconfig
@@ -27,7 +27,6 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=2
 CONFIG_BLK_DEV_RAM_SIZE=17000
-CONFIG_MISC_DEVICES=y
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
diff --git a/arch/c6x/configs/evmc6474_defconfig b/arch/c6x/configs/evmc6474_defconfig
index 15533f6..3e79abc 100644
--- a/arch/c6x/configs/evmc6474_defconfig
+++ b/arch/c6x/configs/evmc6474_defconfig
@@ -27,7 +27,6 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=2
 CONFIG_BLK_DEV_RAM_SIZE=17000
-CONFIG_MISC_DEVICES=y
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
diff --git a/arch/c6x/configs/evmc6678_defconfig b/arch/c6x/configs/evmc6678_defconfig
index 5f126d4..7b907b6 100644
--- a/arch/c6x/configs/evmc6678_defconfig
+++ b/arch/c6x/configs/evmc6678_defconfig
@@ -27,7 +27,6 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=2
 CONFIG_BLK_DEV_RAM_SIZE=17000
-CONFIG_MISC_DEVICES=y
 # CONFIG_INPUT is not set
 # CONFIG_SERIO is not set
 # CONFIG_VT is not set
-- 
1.7.9.5

