Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272Ab2EHHVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 03:21:39 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:58720 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758205Ab2EHHVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 03:21:36 -0400
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
Subject: [PATCH 11/12] ARM: imx: eukrea_mbimxsd25: use IMX_GPIO_NR
Date: Tue,  8 May 2012 09:20:26 +0200
Message-Id: <1336461627-30315-11-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336461627-30315-1-git-send-email-eric@eukrea.com>
References: <1336461627-30315-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
---
 arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c b/arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c
index fcc366a..dfd2da8 100644
--- a/arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c
+++ b/arch/arm/mach-imx/eukrea_mbimxsd25-baseboard.c
@@ -97,10 +97,10 @@ static iomux_v3_cfg_t eukrea_mbimxsd_pads[] = {
 	MX25_PAD_CSPI1_RDY__GPIO_2_22,
 };
 
-#define GPIO_LED1	83
-#define GPIO_SWITCH1	82
-#define GPIO_SD1CD	52
-#define GPIO_LCDPWR	26
+#define GPIO_LED1		IMX_GPIO_NR(3, 19)
+#define GPIO_SWITCH1	IMX_GPIO_NR(3, 18)
+#define GPIO_SD1CD		IMX_GPIO_NR(2, 20)
+#define GPIO_LCDPWR		IMX_GPIO_NR(1, 26)
 #define	GPIO_SPI1_SS0	IMX_GPIO_NR(1, 16)
 #define	GPIO_SPI1_SS1	IMX_GPIO_NR(1, 17)
 #define	GPIO_SPI1_IRQ	IMX_GPIO_NR(2, 22)
-- 
1.7.7.6

