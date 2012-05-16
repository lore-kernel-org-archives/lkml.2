Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675Ab2EPIJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:09:21 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:10629
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877Ab2EPIJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:09:09 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bh)
From: <sonic.zhang@analog.com>
To: Chris Ball <cjb@laptop.org>, <linux-mmc@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        Sonic Zhang <sonic.zhang@analog.com>, Bob Liu <lliubbo@gmail.com>
Subject: [PATCH] mmc: bfin_sdh: Update Kconfig to support new RSI controller in bf60x.
Date: Wed, 16 May 2012 15:58:10 +0800
Message-ID: <1337155090-12172-1-git-send-email-sonic.zhang@analog.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 drivers/mmc/host/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 2bc06e7..788e394 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -500,7 +500,7 @@ config MMC_VIA_SDMMC
 
 config SDH_BFIN
 	tristate "Blackfin Secure Digital Host support"
-	depends on (BF54x && !BF544) || (BF51x && !BF512)
+	depends on (BF54x && !BF544) || (BF51x && !BF512) || BF60x
 	help
 	  If you say yes here you will get support for the Blackfin on-chip
 	  Secure Digital Host interface.  This includes support for MMC and
@@ -513,7 +513,7 @@ config SDH_BFIN
 
 config SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
 	bool "Blackfin EZkit Missing SDH_CMD Pull Up Resistor Workaround"
-	depends on SDH_BFIN
+	depends on SDH_BFIN && !BF60x
 	help
 	  If you say yes here SD-Cards may work on the EZkit.
 
-- 
1.7.0.4


