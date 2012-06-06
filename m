Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758463Ab2FFV0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:26:04 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:4766 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634Ab2FFV0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:26:02 -0400
Message-ID: <1339017960.21725.22.camel@x61.thuisdomein>
Subject: [PATCH] u8500_defconfig: delete CONFIG_AB5500_CORE
From: Paul Bolle <pebolle@tiscali.nl>
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 06 Jun 2012 23:26:00 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 06 Jun 2012 21:26:01.0009 (UTC) FILETIME=[F861DA10:01CD442A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 72fb92200d6c31b9982c06784e4bcff2f5b7d8b6 ("mfd/ab5500: delete
AB5500 support") deleted the Kconfig symbol AB5500_CORE. Let's also
delete its last usage in u8500_defconfig.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with "git grep" only.

1) There's also CONFIG_SND_SOC_UX500_AB5500 in
sound/soc/ux500/ux500_msp_dai.h. Was it related? (Note that there's no
Kconfig symbol SND_SOC_UX500_AB5500, so CONFIG_SND_SOC_UX500_AB5500 is
currently undefined.)

 arch/arm/configs/u8500_defconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/configs/u8500_defconfig b/arch/arm/configs/u8500_defconfig
index 2d4f661..5ff8c89 100644
--- a/arch/arm/configs/u8500_defconfig
+++ b/arch/arm/configs/u8500_defconfig
@@ -71,7 +71,6 @@ CONFIG_AB8500_BM=y
 CONFIG_AB8500_BATTERY_THERM_ON_BATCTRL=y
 CONFIG_MFD_STMPE=y
 CONFIG_MFD_TC3589X=y
-CONFIG_AB5500_CORE=y
 CONFIG_AB8500_CORE=y
 CONFIG_REGULATOR=y
 CONFIG_REGULATOR_AB8500=y
-- 
1.7.7.6

