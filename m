Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab2HRQZi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 12:25:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53081 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab2HRQY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 12:24:29 -0400
From: Fabio Estevam <festevam@gmail.com>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH 09/11] score: defconfig: Remove CONFIG_MISC_DEVICES
Date: Sat, 18 Aug 2012 13:23:53 -0300
Message-Id: <1345307035-3545-9-git-send-email-festevam@gmail.com>
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

Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 arch/score/configs/spct6600_defconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/score/configs/spct6600_defconfig b/arch/score/configs/spct6600_defconfig
index df1edbf..4e7f498 100644
--- a/arch/score/configs/spct6600_defconfig
+++ b/arch/score/configs/spct6600_defconfig
@@ -33,7 +33,6 @@ CONFIG_BLK_DEV_LOOP=y
 CONFIG_BLK_DEV_CRYPTOLOOP=y
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=1
-# CONFIG_MISC_DEVICES is not set
 CONFIG_NETDEVICES=y
 # CONFIG_NETDEV_1000 is not set
 # CONFIG_NETDEV_10000 is not set
-- 
1.7.9.5

