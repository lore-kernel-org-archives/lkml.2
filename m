Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1C1HG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 03:06:27 -0400
Received: from mail1.elettra.trieste.it ([140.105.4.201]:27953 "EHLO
	elettra.trieste.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750987Ab1C1HG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 03:06:26 -0400
From: Alessio Igor Bogani <abogani@kernel.org>
To: Chris Zankel <chris@zankel.net>
Cc: Tim Bird <tim.bird@am.sony.com>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH] xtensa: Remove obsolete kernel option
Date: Mon, 28 Mar 2011 09:06:14 +0200
Message-Id: <1301295974-4921-1-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL doesn't exist anymore so remove CONFIG_LOCK_KERNEL.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
---
 arch/xtensa/configs/s6105_defconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index 42b7feb..4891abb 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -23,7 +23,6 @@ CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 #
 CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
-CONFIG_LOCK_KERNEL=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
 CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
-- 
1.7.0.4

