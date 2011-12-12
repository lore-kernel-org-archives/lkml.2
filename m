Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab1LLD3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:29:20 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:55109
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752971Ab1LLD2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:28:48 -0500
X-SpamScore: 2
X-BigFish: VS2(zzzz1202hzz8275bhz2ei87h2a8h668h839hb79i)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
From: Bob Liu <lliubbo@gmail.com>
To: <linux-kernel@vger.kernel.org>
CC: <sonic.adi@gmail.com>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <vapier@gentoo.org>, Bob Liu <lliubbo@gmail.com>,
        Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH 01/11] blackfin: bf533-stamp: fix ad1836 name
Date: Mon, 12 Dec 2011 11:28:23 +0800
Message-ID: <1323660513-9620-1-git-send-email-lliubbo@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ASoC codec name is "ad1836" and not "ad183x" as the change to rename
things ultimately did not get merged.

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 arch/blackfin/mach-bf533/boards/stamp.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index 2afd02e..d12d4de 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -219,9 +219,10 @@ static struct spi_board_info bfin_spi_board_info[] __initdata = {
 	},
 #endif
 
-#if defined(CONFIG_SND_BF5XX_SOC_AD183X) || defined(CONFIG_SND_BF5XX_SOC_AD183X_MODULE)
+#if defined(CONFIG_SND_BF5XX_SOC_AD1836) || \
+	defined(CONFIG_SND_BF5XX_SOC_AD1836_MODULE)
 	{
-		.modalias = "ad183x",
+		.modalias = "ad1836",
 		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
 		.chip_select = 4,
-- 
1.7.0.4


